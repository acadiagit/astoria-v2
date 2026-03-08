#!/usr/bin/env python3
"""
Astoria v2 — Phase 3: Extract vessel records from Machias Ship Registers PDF.
Parses the raw text output of pdftotext and produces structured vessel records,
then generates SQL INSERT statements for the Supabase `documents` table.

Source: "Ship Registers and Enrollments of Machias, Maine, 1780-1930"
        National Archives Project, 1942. Part I: A-K.
"""

import re
import json
import hashlib
from datetime import datetime

# ---------------------------------------------------------------------------
# 1. Load raw text
# ---------------------------------------------------------------------------
RAW_TEXT_PATH = "/sessions/ecstatic-practical-pasteur/vessel_records_raw.txt"

with open(RAW_TEXT_PATH, "r") as f:
    raw_text = f.read()

# ---------------------------------------------------------------------------
# 2. Split into individual vessel entries
# ---------------------------------------------------------------------------
# Each entry starts with:  NUMBER. VESSEL NAME, type, of port
# The vessel name is in ALL CAPS. Types: schooner, brig, bark, sloop, ship, gas screw, steamer
ENTRY_PATTERN = re.compile(
    r'^(\d+)\s*[\.\,]\s+'                           # entry number
    r'([A-Z][A-Z\s\.\'\-\&\$]+?)\s*,\s*'           # vessel name (ALL CAPS)
    r'(schooner|brig|bark|sloop|ship|gas screw|steamer)'  # vessel type
    r'\s*,?\s*of\s+',
    re.MULTILINE | re.IGNORECASE
)

# Find all entry start positions
matches = list(ENTRY_PATTERN.finditer(raw_text))
print(f"Found {len(matches)} vessel entry headers")

# Extract each entry's full text (from this header to the next header)
entries = []
for i, match in enumerate(matches):
    start = match.start()
    end = matches[i + 1].start() if i + 1 < len(matches) else len(raw_text)

    entry_num = int(match.group(1))
    vessel_name = match.group(2).strip()
    vessel_type = match.group(3).strip().lower()

    # Get the full text of this entry
    full_text = raw_text[start:end].strip()

    # Clean up the vessel name (remove extra spaces from OCR)
    vessel_name = re.sub(r'\s+', ' ', vessel_name).strip()
    # Fix OCR spacing in names: "A . B . PERRY" -> "A. B. PERRY"
    vessel_name = re.sub(r'\s+\.', '.', vessel_name)
    vessel_name = re.sub(r'\.\s+', '. ', vessel_name)
    # Remove trailing periods or commas
    vessel_name = vessel_name.rstrip('.,').strip()
    # Convert to Title Case for readability and case-insensitive search
    vessel_name = vessel_name.title()

    entries.append({
        "entry_num": entry_num,
        "vessel_name": vessel_name,
        "vessel_type": vessel_type,
        "raw_text": full_text,
    })

print(f"Extracted {len(entries)} complete vessel entries")

# ---------------------------------------------------------------------------
# 3. Parse structured fields from each entry
# ---------------------------------------------------------------------------

def parse_hailing_port(text):
    """Extract hailing port from 'of PORT' pattern after vessel type."""
    m = re.search(
        r'(?:schooner|brig|bark|sloop|ship|gas screw|steamer)\s*,?\s*of\s+(.+?)[\.\s]*(?:Official|Built|Previously|\d+\s*/\s*\d+|\d+[\.\s]\d+\s*(?:gross|tons))',
        text, re.IGNORECASE
    )
    if m:
        port = m.group(1).strip()
        # Clean OCR artifacts and trailing punctuation
        port = re.sub(r'\s+', ' ', port)
        port = port.rstrip(' .,;:')
        return port

    # Fallback: simpler pattern - get everything after "of" until period
    m = re.search(
        r'(?:schooner|brig|bark|sloop|ship|gas screw|steamer)\s*,?\s*of\s+([A-Z][A-Za-z\s,\.]+?)(?:\.\s+(?:Official|Built|Previously)|\.\s+\d)',
        text, re.IGNORECASE
    )
    if m:
        port = m.group(1).strip().rstrip(' .,;:')
        port = re.sub(r'\s+', ' ', port)
        return port
    return None

def parse_official_number(text):
    """Extract Official No. from entry."""
    m = re.search(r'Official\s+No[\.\s]+(\d+)', text, re.IGNORECASE)
    if m:
        return m.group(1)
    return None

def parse_build_info(text):
    """Extract build location, year, and builder."""
    # Pattern: Built at LOCATION, YEAR, by BUILDER, master carpenter.
    # First try with builder
    m = re.search(
        r'Built\s+at\s+(.+?)\s*,\s*'                    # location
        r'(\d{4})\s*'                                      # year
        r',\s*by\s+(.+?)'                                  # builder name
        r'(?:\s*,\s*master\s+carpenter)?'                 # optional title
        r'\s*\.\s*\d',                                     # period then tonnage digit
        text, re.IGNORECASE
    )
    if m:
        location = re.sub(r'\s+', ' ', m.group(1).strip().rstrip(' ,'))
        year = int(m.group(2))
        builder = None
        if m.group(3):
            builder = re.sub(r'\s+', ' ', m.group(3).strip().rstrip(' ,'))
            # Remove trailing "master carpenter" if it got captured
            builder = re.sub(r'\s*,?\s*master\s+carpenter\s*$', '', builder, flags=re.IGNORECASE).strip()
        return location, year, builder

    # Simpler pattern: Built at LOCATION, YEAR.
    m = re.search(r'Built\s+at\s+(.+?)\s*,\s*(\d{4})', text, re.IGNORECASE)
    if m:
        location = re.sub(r'\s+', ' ', m.group(1).strip().rstrip(' ,'))
        year = int(m.group(2))
        return location, year, None

    return None, None, None

def parse_tonnage(text):
    """Extract tonnage info. The historical format uses 95ths: NNN NN/95 tons."""
    # Pattern 1: NNN.NN gross tons, NNN.NN net tons
    m = re.search(r'(\d+\.?\d*)\s+gross\s+tons?\s*,?\s*(\d+\.?\d*)\s+net\s+tons?', text, re.IGNORECASE)
    if m:
        try:
            return float(m.group(1))
        except:
            pass

    # Pattern 2: NNN.NN tons (decimal format)
    m = re.search(r'(\d+\.\d+)\s+tons', text, re.IGNORECASE)
    if m:
        try:
            return float(m.group(1))
        except:
            pass

    # Pattern 3: NNN NN/95 tons (95ths fraction format)
    m = re.search(r'(\d+)\s+(\d+)\s*/\s*(\d+)\s+tons', text, re.IGNORECASE)
    if m:
        try:
            whole = int(m.group(1))
            numer = int(m.group(2))
            denom = int(m.group(3))
            return round(whole + numer / denom, 2)
        except:
            pass

    # Pattern 4: NNN tons (whole number)
    m = re.search(r'(\d+)\s+tons', text, re.IGNORECASE)
    if m:
        try:
            return float(m.group(1))
        except:
            pass

    return None

def parse_dimensions(text):
    """Extract dimensions: length x beam x depth."""
    # Pattern: NN.N ft. x NN.N ft. x N.N ft (decimal format)
    m = re.search(
        r'(\d+\.?\d*)\s*ft\.?\s*(?:\d+(?:\s*/\s*\d+)?\s*in\.?\s*)?x\s*'
        r'(\d+\.?\d*)\s*ft\.?\s*(?:\d+(?:\s*/\s*\d+)?\s*in\.?\s*)?x\s*'
        r'(\d+\.?\d*)\s*ft',
        text, re.IGNORECASE
    )
    if m:
        try:
            length = float(m.group(1))
            beam = float(m.group(2))
            depth = float(m.group(3))
            # Sanity check: vessels are typically 30-250 ft long
            if 10 < length < 500 and 5 < beam < 100 and 2 < depth < 50:
                return length, beam, depth
        except:
            pass

    # Broader pattern: look for three numbers separated by x near "ft"
    m = re.search(
        r'(\d+[\.\s]?\d*)\s*(?:ft|Ft)[\.\s]*(?:\d+[^x]*?)?\s*x\s*'
        r'(\d+[\.\s]?\d*)\s*(?:ft|Ft)[\.\s]*(?:\d+[^x]*?)?\s*x\s*'
        r'(\d+[\.\s]?\d*)\s*(?:ft|Ft)',
        text, re.IGNORECASE
    )
    if m:
        try:
            length = float(m.group(1).replace(' ', ''))
            beam = float(m.group(2).replace(' ', ''))
            depth = float(m.group(3).replace(' ', ''))
            if 10 < length < 500 and 5 < beam < 100 and 2 < depth < 50:
                return length, beam, depth
        except:
            pass
    return None, None, None

def parse_deck_masts(text):
    """Extract deck and mast configuration."""
    decks = None
    masts = None
    m = re.search(r'(\w+)\s+deck', text, re.IGNORECASE)
    if m:
        word = m.group(1).lower()
        deck_map = {'one': 1, 'two': 2, 'three': 3, '1': 1, '2': 2, '3': 3}
        decks = deck_map.get(word)

    m = re.search(r'(\w+)\s+mast', text, re.IGNORECASE)
    if m:
        word = m.group(1).lower()
        mast_map = {'one': 1, 'two': 2, 'three': 3, 'four': 4, '1': 1, '2': 2, '3': 3, '4': 4}
        masts = mast_map.get(word)

    return decks, masts

def parse_stern_head(text):
    """Extract stern type and head type."""
    stern = None
    head = None
    m = re.search(r'(square|elliptic|round)\s+stern', text, re.IGNORECASE)
    if m:
        stern = m.group(1).lower()

    m = re.search(r'a\s+(billethead|figurehead|scrollhead|plain head)', text, re.IGNORECASE)
    if m:
        head = m.group(1).lower()

    return stern, head

# Parse all entries
vessels = []
for entry in entries:
    text = entry["raw_text"]

    port = parse_hailing_port(text)
    if port:
        # Normalize port names: remove OCR extra spaces before commas/periods
        port = re.sub(r'\s+,', ',', port)
        port = re.sub(r'\s+\.', '.', port)
        # Normalize common OCR variants
        port = port.replace('Mass .', 'Mass.').replace('Mass,', 'Mass.')
        port = port.replace('Conn .', 'Conn.').replace('N . Y .', 'N.Y.')
        port = port.replace('N . J .', 'N.J.').replace('N . H .', 'N.H.')
        port = port.replace('R . I .', 'R.I.')

    official_no = parse_official_number(text)
    build_location, build_year, builder = parse_build_info(text)
    if build_location:
        build_location = re.sub(r'\s+,', ',', build_location)
        build_location = re.sub(r'\s+\.', '.', build_location)
    if builder:
        builder = re.sub(r'\s+\.', '.', builder)
        builder = re.sub(r'\s+,', ',', builder)
        builder = builder.strip().rstrip(' ,')
    tonnage = parse_tonnage(text)
    length, beam, depth = parse_dimensions(text)
    decks, masts = parse_deck_masts(text)
    stern, head = parse_stern_head(text)

    vessel = {
        "entry_num": entry["entry_num"],
        "vessel_name": entry["vessel_name"],
        "vessel_type": entry["vessel_type"],
        "hailing_port": port,
        "official_number": official_no,
        "place_built": build_location,
        "year_built": build_year,
        "builder": builder,
        "tonnage": tonnage,
        "length_ft": length,
        "beam_ft": beam,
        "depth_ft": depth,
        "decks": decks,
        "masts": masts,
        "stern_type": stern,
        "head_type": head,
        "raw_content": entry["raw_text"],
    }
    vessels.append(vessel)

# ---------------------------------------------------------------------------
# 4. Statistics
# ---------------------------------------------------------------------------
print(f"\n{'='*60}")
print(f"EXTRACTION SUMMARY")
print(f"{'='*60}")
print(f"Total vessels extracted: {len(vessels)}")
print(f"Unique vessel names: {len(set(v['vessel_name'] for v in vessels))}")

# Vessel types
types = {}
for v in vessels:
    types[v["vessel_type"]] = types.get(v["vessel_type"], 0) + 1
print(f"\nVessel types:")
for t, c in sorted(types.items(), key=lambda x: -x[1]):
    print(f"  {t}: {c}")

# Build years
years = [v["year_built"] for v in vessels if v["year_built"]]
if years:
    print(f"\nBuild year range: {min(years)} - {max(years)}")

# Ports
ports = {}
for v in vessels:
    if v["hailing_port"]:
        ports[v["hailing_port"]] = ports.get(v["hailing_port"], 0) + 1
print(f"\nTop 10 hailing ports:")
for p, c in sorted(ports.items(), key=lambda x: -x[1])[:10]:
    print(f"  {p}: {c}")

# Parse success rates
def pct(field):
    count = sum(1 for v in vessels if v.get(field))
    return f"{count}/{len(vessels)} ({100*count/len(vessels):.0f}%)"

print(f"\nField extraction rates:")
print(f"  Hailing port:    {pct('hailing_port')}")
print(f"  Official number: {pct('official_number')}")
print(f"  Place built:     {pct('place_built')}")
print(f"  Year built:      {pct('year_built')}")
print(f"  Builder:         {pct('builder')}")
print(f"  Tonnage:         {pct('tonnage')}")
print(f"  Dimensions:      {pct('length_ft')}")
print(f"  Decks:           {pct('decks')}")
print(f"  Masts:           {pct('masts')}")

# ---------------------------------------------------------------------------
# 5. Generate SQL INSERT statements
# ---------------------------------------------------------------------------
def escape_sql(s):
    """Escape single quotes for SQL."""
    if s is None:
        return "NULL"
    return "'" + str(s).replace("'", "''") + "'"

def make_document_title(v):
    """Create a readable title matching existing format: 'Ship Registry: Name'."""
    name = v["vessel_name"]  # already Title Case from extraction
    vtype = v["vessel_type"].title()
    return f"Ship Registry: {name} ({vtype})"

def make_raw_content(v):
    """The raw_content is the full register entry text as extracted from the PDF."""
    return v["raw_content"]

def make_metadata(v):
    """Create metadata JSON matching existing seed data format."""
    meta = {
        "type": "ship",
        "ship_name": v["vessel_name"],  # already Title Case from extraction
        "ship_type": v["vessel_type"],
        "entry_number": v["entry_num"],
    }
    if v["hailing_port"]:
        meta["hailing_port"] = v["hailing_port"]
    if v["official_number"]:
        meta["official_number"] = int(v["official_number"])
    if v["place_built"]:
        meta["place_built"] = v["place_built"]
    if v["year_built"]:
        meta["year_built"] = v["year_built"]
    if v["builder"]:
        meta["builder"] = v["builder"]
    if v["tonnage"]:
        meta["tonnage"] = v["tonnage"]
    if v["length_ft"]:
        meta["length_ft"] = v["length_ft"]
    if v["beam_ft"]:
        meta["breadth_ft"] = v["beam_ft"]
    if v["depth_ft"]:
        meta["depth_ft"] = v["depth_ft"]
    if v["decks"]:
        meta["decks"] = v["decks"]
    if v["masts"]:
        meta["masts"] = v["masts"]
    if v["stern_type"]:
        meta["stern"] = v["stern_type"]
    if v["head_type"]:
        meta["head"] = v["head_type"]
    return meta

def make_checksum(v):
    """Generate SHA-256 checksum for deduplication."""
    content = f"{v['entry_num']}_{v['vessel_name']}_{v['vessel_type']}_{v['raw_content'][:200]}"
    return hashlib.sha256(content.encode()).hexdigest()

ARCHIVE_NAME = "Machias Ship Registers 1780-1930"

# Generate SQL
SQL_OUTPUT_PATH = "/sessions/ecstatic-practical-pasteur/vessel_inserts.sql"

with open(SQL_OUTPUT_PATH, "w") as f:
    f.write("-- Astoria v2 Phase 3: Vessel Records from Machias Ship Registers Part I (A-K)\n")
    f.write(f"-- Generated: {datetime.now().isoformat()}\n")
    f.write(f"-- Total records: {len(vessels)}\n")
    f.write("-- Source: Ship Registers and Enrollments of Machias, Maine, 1780-1930\n")
    f.write("--         National Archives Project, 1942\n")
    f.write("-- \n")
    f.write("-- IMPORTANT: This uses ON CONFLICT to skip existing records.\n")
    f.write("-- Run from Mac: psql 'postgresql://postgres:wMACHx0762303@db.mvxlmhxlfbdtnueysrex.supabase.co:5432/postgres' -f vessel_inserts.sql\n\n")

    f.write("BEGIN;\n\n")

    for v in vessels:
        title = make_document_title(v)
        raw_content = make_raw_content(v)
        metadata = make_metadata(v)
        checksum = make_checksum(v)

        f.write(f"INSERT INTO documents (title, archive_name, content_type, raw_content, checksum, metadata)\n")
        f.write(f"VALUES (\n")
        f.write(f"  {escape_sql(title)},\n")
        f.write(f"  {escape_sql(ARCHIVE_NAME)},\n")
        f.write(f"  'text',\n")
        f.write(f"  {escape_sql(raw_content)},\n")
        f.write(f"  {escape_sql(checksum)},\n")
        f.write(f"  {escape_sql(json.dumps(metadata))}::jsonb\n")
        f.write(f") ON CONFLICT (checksum) DO NOTHING;\n\n")

    f.write("COMMIT;\n")

print(f"\nSQL file written to: {SQL_OUTPUT_PATH}")

# Also save vessels as JSON for reference
JSON_OUTPUT_PATH = "/sessions/ecstatic-practical-pasteur/vessels_extracted.json"
with open(JSON_OUTPUT_PATH, "w") as f:
    json.dump(vessels, f, indent=2, default=str)
print(f"JSON reference saved to: {JSON_OUTPUT_PATH}")

# Show a few sample entries
print(f"\n{'='*60}")
print("SAMPLE ENTRIES")
print(f"{'='*60}")
for v in vessels[:3]:
    print(f"\n#{v['entry_num']}: {v['vessel_name']} ({v['vessel_type']})")
    print(f"  Port: {v['hailing_port']}")
    print(f"  Built: {v['place_built']}, {v['year_built']} by {v['builder']}")
    print(f"  Tonnage: {v['tonnage']} tons")
    if v['length_ft']:
        print(f"  Dimensions: {v['length_ft']} x {v['beam_ft']} x {v['depth_ft']} ft")
    print(f"  Config: {v['decks']} deck(s), {v['masts']} mast(s), {v['stern_type']} stern, {v['head_type']}")
