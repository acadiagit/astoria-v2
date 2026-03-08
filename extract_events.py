#!/usr/bin/env python3
"""
Astoria v2 — Phase 3A: Extract structured events from vessel raw_content.

Parses each vessel record's raw text to extract individual enrollment
and registration events, producing structured data for the vessel_events table.

Events capture:
  - event_type: enrolled/registered (domestic vs foreign trade)
  - event_port: where document was issued (vessel was present)
  - previous_port: where vessel came from (enables voyage reconstruction)
  - master: captain at that time
  - owners_text: full ownership string for text search
"""

import re
import json
import hashlib
from datetime import datetime

# ---------------------------------------------------------------------------
# 1. Load extracted vessels
# ---------------------------------------------------------------------------
VESSELS_JSON = "/sessions/ecstatic-practical-pasteur/vessels_extracted.json"

with open(VESSELS_JSON, "r") as f:
    vessels = json.load(f)

print(f"Loaded {len(vessels)} vessel records")

# ---------------------------------------------------------------------------
# 2. Event extraction patterns
# ---------------------------------------------------------------------------

# Main event pattern: Enrolled/Registered, [of PORT,] No. NN, DATE, at PORT
EVENT_PATTERN = re.compile(
    r'(Enrolled|Registered)\s*'
    r'(\(\s*temporary\s*\))?\s*'              # optional (temporary)
    r',?\s*'
    r'(?:of\s+([^,]+?)\s*,\s*)?'              # optional "of PORT,"
    r'No\s*[\.\,]\s*(\d+)\s*,\s*'             # No. NN
    r'([A-Z][a-z]+\.?\s+\d+\s*,?\s*\d{4})\s*' # date: Mon. DD, YYYY
    r',?\s*at\s+([^\.]+)',                      # at PORT
    re.IGNORECASE
)

# Previously enrolled/registered pattern
PREVIOUS_PATTERN = re.compile(
    r'Previously\s+'
    r'(enrolled|registered)\s*'
    r'(\(\s*temporary\s*\))?\s*'
    r'([A-Z][a-z]+\.?\s+\d+\s*,?\s*\d{4})?\s*'  # optional date
    r',?\s*at\s+([^\.]+)',
    re.IGNORECASE
)

# Master pattern — handles OCR-spaced initials like "A . L . Mitchell ."
# Match "Master:" then capture everything up to a sentence-ending period
# (period followed by space+uppercase, or period at end, or "Previously", or "Change")
MASTER_PATTERN = re.compile(
    r'Master\s*[:\;]\s*(.+?)(?:\.\s*(?:Previously|Change|Surrendered|$|\n))',
    re.IGNORECASE
)

# Owners pattern (grab everything between "Owners:" and "Master:")
OWNERS_PATTERN = re.compile(
    r'Owners?\s*[:\;]\s*(.+?)(?:\s*Master\s*[:\;])',
    re.IGNORECASE | re.DOTALL
)

# Change of master
CHANGE_MASTER_PATTERN = re.compile(
    r'Change\s+of\s+master\s*[:\;]\s*([^,\.]+?)(?:\s*,\s*([A-Z][a-z]+\.?\s+\d+\s*,?\s*\d{4}))?(?:\.|,)',
    re.IGNORECASE
)

# Notes: tonnage amended, readmeasured, surrendered, trade changed
NOTES_PATTERNS = [
    (re.compile(r'having\s+tonnage\s+amended\s*,?\s*(\d+[\.\s]?\d*)\s*tons?', re.IGNORECASE), 'tonnage_amended'),
    (re.compile(r'having\s+been\s+readmeasured\s*\.?\s*(\d+[\.\s]?\d*)\s*tons?', re.IGNORECASE), 'readmeasured'),
    (re.compile(r'Surrendered\s*,?\s*([^\.]+)', re.IGNORECASE), 'surrendered'),
    (re.compile(r'trade\s+changed', re.IGNORECASE), 'trade_changed'),
]

# ---------------------------------------------------------------------------
# 3. Date parsing helper
# ---------------------------------------------------------------------------
MONTH_MAP = {
    'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
    'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12
}

def parse_date(date_str):
    """Parse date strings like 'Nov. 14, 1873' or 'Sept 7 , 1855'."""
    if not date_str:
        return None
    # Clean OCR artifacts
    date_str = re.sub(r'\s+', ' ', date_str.strip())
    date_str = date_str.replace(' ,', ',').replace(' .', '.')

    # Try pattern: Mon[.] DD, YYYY
    m = re.match(r'([A-Za-z]+)\.?\s*(\d+)\s*,?\s*(\d{4})', date_str)
    if m:
        month_str = m.group(1).lower()[:3]
        day = int(m.group(2))
        year = int(m.group(3))
        month = MONTH_MAP.get(month_str)
        if month and 1 <= day <= 31 and 1700 <= year <= 1950:
            try:
                return f"{year}-{month:02d}-{day:02d}"
            except:
                pass
    return None

def clean_text(s):
    """Clean OCR spacing artifacts."""
    if not s:
        return None
    s = re.sub(r'\s+', ' ', s).strip()
    # Fix OCR-spaced initials: "A . L ." → "A. L."
    s = re.sub(r'(\w)\s+\.', r'\1.', s)
    s = re.sub(r'\s+,', ',', s)
    s = s.strip(' .,;:')
    return s if s else None

def normalize_port(port_str):
    """Normalize OCR-garbled port names."""
    if not port_str:
        return None
    port_str = clean_text(port_str)
    if not port_str:
        return None
    # Remove trailing clauses like "having been readmeasured", "having tonnage amended"
    port_str = re.sub(r',?\s*having\s+.*$', '', port_str, flags=re.IGNORECASE).strip()
    # Normalize Machias variants (OCR misreadings)
    machias_variants = re.compile(
        r'^(?:lachias|llachias|Hachias|l\'achias|Machies|liachias|'
        r'Machia[^s]|[lI1]achias|Macliias|Maehias|Mach\s*ias|'
        r'Machins|Mechias|Plachias|ilachias|hlachias|"\s*achias|'
        r'Machin s|Macbi[ae]s|Macl[il]as|Macbias|Macliins|Maehins|'
        r'M achias|Macliias|Macliins)$',
        re.IGNORECASE
    )
    if machias_variants.match(port_str):
        return 'Machias'
    # Catch "Machias" or close variants with trailing junk
    if re.match(r'^[Mm]ach', port_str) and len(port_str) > 10:
        return 'Machias'
    # Lowercase "machias"
    if port_str.lower() == 'machias':
        return 'Machias'
    # Broad catch: anything 5-10 chars that looks like garbled "Machias"
    # (not Millbridge, Cherryfield, or other real ports)
    clean_lower = re.sub(r'[^a-z]', '', port_str.lower())
    if len(clean_lower) >= 5 and len(clean_lower) <= 10:
        # Check if it's close to "machias" or "machins"
        from difflib import SequenceMatcher
        ratio = SequenceMatcher(None, clean_lower, 'machias').ratio()
        if ratio >= 0.55 and clean_lower not in ('millbridge', 'cherryfield'):
            return 'Machias'
    # Also catch ports that captured trailing owner/master text
    if re.search(r'Owners|Master|Jamers|Ormers|Ovmers', port_str, re.IGNORECASE):
        first_word = port_str.split(',')[0].split(' ')[0].strip()
        if first_word:
            return normalize_port(first_word)
        return 'Machias'
    # Catch very short fragments (likely garbled Machias)
    if len(clean_lower) <= 3:
        return 'Machias'
    return port_str

# ---------------------------------------------------------------------------
# 4. Extract events from each vessel
# ---------------------------------------------------------------------------

all_events = []
vessels_with_events = 0
vessels_without_events = 0

for v in vessels:
    vessel_name = v["vessel_name"]
    raw = v["raw_content"]
    entry_num = v["entry_num"]

    # Find all enrollment/registration events
    event_matches = list(EVENT_PATTERN.finditer(raw))

    if not event_matches:
        vessels_without_events += 1
        continue

    vessels_with_events += 1

    for ei, em in enumerate(event_matches):
        event_type_raw = em.group(1).lower()
        is_temporary = bool(em.group(2))
        of_port = normalize_port(em.group(3))  # "of PORT" (sometimes different from hailing port)
        doc_number = em.group(4)
        date_str = em.group(5)
        event_port = normalize_port(em.group(6))

        # Build event type
        if is_temporary:
            event_type = f"{event_type_raw}_temporary"
        else:
            event_type = event_type_raw

        # Parse the date
        event_date = parse_date(date_str)

        # Get the text block for this event (from this match to next match or end)
        event_start = em.start()
        event_end = event_matches[ei + 1].start() if ei + 1 < len(event_matches) else len(raw)
        event_text = raw[event_start:event_end]

        # Extract master from this event block
        master = None
        mm = MASTER_PATTERN.search(event_text)
        if mm:
            master = clean_text(mm.group(1))
            if master:
                # Remove trailing periods and whitespace
                master = master.rstrip(' .')
                # Handle "same" variants
                if master.lower() in ('same', 'sane', 'samo', 'snme', 'sanc', 'samc', 'sanie'):
                    master = '(same as previous)'
                # Skip if just a single letter (truncated by OCR)
                elif len(master) <= 1:
                    master = None

        # Extract owners from this event block
        owners_text = None
        om = OWNERS_PATTERN.search(event_text)
        if om:
            owners_text = clean_text(om.group(1))
            if owners_text and owners_text.lower() in ('same', 'same.', 'sane', 'samo'):
                owners_text = '(same as previous)'

        # Extract "Previously enrolled/registered at PORT"
        previous_port = None
        pm = PREVIOUS_PATTERN.search(event_text)
        if pm:
            previous_port = normalize_port(pm.group(4))

        # Extract change of master
        change_master = None
        cm = CHANGE_MASTER_PATTERN.search(event_text)
        if cm:
            change_master = clean_text(cm.group(1))

        # Check for notes
        notes_list = []
        for pattern, note_type in NOTES_PATTERNS:
            nm = pattern.search(event_text)
            if nm:
                notes_list.append(note_type)
        if change_master:
            notes_list.append(f"change_of_master: {change_master}")

        notes = "; ".join(notes_list) if notes_list else None

        event = {
            "vessel_name": vessel_name,
            "entry_num": entry_num,
            "event_type": event_type,
            "event_date": event_date,
            "event_port": event_port,
            "previous_port": previous_port,
            "doc_number": doc_number,
            "master": master,
            "owners_text": owners_text,
            "notes": notes,
            "event_index": ei,
        }
        all_events.append(event)

# ---------------------------------------------------------------------------
# 5. Statistics
# ---------------------------------------------------------------------------
print(f"\n{'='*60}")
print(f"EVENT EXTRACTION SUMMARY")
print(f"{'='*60}")
print(f"Vessels with events: {vessels_with_events}")
print(f"Vessels without events: {vessels_without_events}")
print(f"Total events extracted: {len(all_events)}")

# Event types
types = {}
for e in all_events:
    types[e["event_type"]] = types.get(e["event_type"], 0) + 1
print(f"\nEvent types:")
for t, c in sorted(types.items(), key=lambda x: -x[1]):
    print(f"  {t}: {c}")

# Events per vessel
events_per = {}
for e in all_events:
    events_per[e["vessel_name"]] = events_per.get(e["vessel_name"], 0) + 1
avg_events = sum(events_per.values()) / len(events_per) if events_per else 0
max_events_vessel = max(events_per.items(), key=lambda x: x[1]) if events_per else ("N/A", 0)
print(f"\nEvents per vessel: avg={avg_events:.1f}, max={max_events_vessel[1]} ({max_events_vessel[0]})")

# Field extraction rates
def pct(field):
    count = sum(1 for e in all_events if e.get(field))
    return f"{count}/{len(all_events)} ({100*count/len(all_events):.0f}%)"

print(f"\nField rates:")
print(f"  Event date:     {pct('event_date')}")
print(f"  Event port:     {pct('event_port')}")
print(f"  Previous port:  {pct('previous_port')}")
print(f"  Master:         {pct('master')}")
print(f"  Owners:         {pct('owners_text')}")
print(f"  Notes:          {pct('notes')}")

# Top ports
ports = {}
for e in all_events:
    if e["event_port"]:
        p = e["event_port"]
        ports[p] = ports.get(p, 0) + 1
print(f"\nTop 10 event ports:")
for p, c in sorted(ports.items(), key=lambda x: -x[1])[:10]:
    print(f"  {p}: {c}")

# Top masters
masters = {}
for e in all_events:
    if e["master"] and e["master"] != '(same as previous)':
        masters[e["master"]] = masters.get(e["master"], 0) + 1
print(f"\nTop 10 masters (captains):")
for m, c in sorted(masters.items(), key=lambda x: -x[1])[:10]:
    print(f"  {m}: {c}")

# Voyage legs (events with previous_port)
voyage_legs = sum(1 for e in all_events if e["previous_port"])
print(f"\nVoyage legs (with previous port): {voyage_legs}")

# ---------------------------------------------------------------------------
# 6. Save as JSON
# ---------------------------------------------------------------------------
EVENTS_JSON = "/sessions/ecstatic-practical-pasteur/vessel_events.json"
with open(EVENTS_JSON, "w") as f:
    json.dump(all_events, f, indent=2, default=str)
print(f"\nEvents saved to: {EVENTS_JSON}")

# ---------------------------------------------------------------------------
# 7. Show sample events
# ---------------------------------------------------------------------------
print(f"\n{'='*60}")
print("SAMPLE EVENTS (A. J. Dyer)")
print(f"{'='*60}")
for e in all_events:
    if e["vessel_name"] == "A. J. Dyer":
        print(f"  [{e['event_index']}] {e['event_type']} | {e['event_date']} | at {e['event_port']}")
        if e['previous_port']:
            print(f"       Previously at: {e['previous_port']}")
        if e['master']:
            print(f"       Master: {e['master']}")
        print()
