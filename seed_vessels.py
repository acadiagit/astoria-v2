#!/usr/bin/env python3
"""
Astoria v2 — Phase 3: Seed vessel records into Supabase.

Run this from the Mac:
    cd ~/coworker/astoria-v2
    pip3 install psycopg2-binary
    python3 seed_vessels.py

This inserts 911 vessel records from the Machias Ship Registers Part I (A-K)
into the Supabase `documents` table.
"""

import json
import hashlib
import psycopg2
import sys
import os

# --- Supabase connection ---
DB_URL = "postgresql://postgres:wMACHx0762303@db.mvxlmhxlfbdtnueysrex.supabase.co:5432/postgres"
ARCHIVE_NAME = "Machias Ship Registers 1780-1930"

# Load extracted vessels
VESSELS_JSON = os.path.join(os.path.dirname(os.path.abspath(__file__)), "vessels_extracted.json")

if not os.path.exists(VESSELS_JSON):
    print(f"ERROR: Cannot find {VESSELS_JSON}")
    sys.exit(1)

with open(VESSELS_JSON, "r") as f:
    vessels = json.load(f)

print(f"Loaded {len(vessels)} vessel records from JSON")

# --- Build document fields ---
def make_title(v):
    name = v["vessel_name"]  # already Title Case from extraction
    vtype = v["vessel_type"].title()
    return f"Ship Registry: {name} ({vtype})"

def make_metadata(v):
    meta = {
        "type": "ship",
        "ship_name": v["vessel_name"],  # already Title Case from extraction
        "ship_type": v["vessel_type"],
        "entry_number": v["entry_num"],
    }
    if v.get("hailing_port"):
        meta["hailing_port"] = v["hailing_port"]
    if v.get("official_number"):
        meta["official_number"] = int(v["official_number"])
    if v.get("place_built"):
        meta["place_built"] = v["place_built"]
    if v.get("year_built"):
        meta["year_built"] = v["year_built"]
    if v.get("builder"):
        meta["builder"] = v["builder"]
    if v.get("tonnage"):
        meta["tonnage"] = v["tonnage"]
    if v.get("length_ft"):
        meta["length_ft"] = v["length_ft"]
    if v.get("beam_ft"):
        meta["breadth_ft"] = v["beam_ft"]
    if v.get("depth_ft"):
        meta["depth_ft"] = v["depth_ft"]
    if v.get("decks"):
        meta["decks"] = v["decks"]
    if v.get("masts"):
        meta["masts"] = v["masts"]
    if v.get("stern_type"):
        meta["stern"] = v["stern_type"]
    if v.get("head_type"):
        meta["head"] = v["head_type"]
    return meta

def make_checksum(v):
    content = f"{v['entry_num']}_{v['vessel_name']}_{v['vessel_type']}_{v['raw_content'][:200]}"
    return hashlib.sha256(content.encode()).hexdigest()

# --- Connect and insert ---
print(f"Connecting to Supabase...")
conn = psycopg2.connect(DB_URL)
cur = conn.cursor()

# Check current count
cur.execute("SELECT COUNT(*) FROM documents")
before_count = cur.fetchone()[0]
print(f"Documents before: {before_count}")

# Insert with ON CONFLICT to skip duplicates
BATCH_SIZE = 50
inserted = 0
skipped = 0

for i in range(0, len(vessels), BATCH_SIZE):
    batch = vessels[i:i + BATCH_SIZE]
    try:
        for v in batch:
            title = make_title(v)
            raw_content = v["raw_content"]
            metadata = make_metadata(v)
            checksum = make_checksum(v)

            cur.execute(
                """INSERT INTO documents (title, archive_name, content_type, raw_content, checksum, metadata)
                   VALUES (%s, %s, 'text', %s, %s, %s::jsonb)
                   ON CONFLICT (checksum) DO NOTHING
                   RETURNING id""",
                (title, ARCHIVE_NAME, raw_content, checksum, json.dumps(metadata))
            )
            result = cur.fetchone()
            if result:
                inserted += 1
            else:
                skipped += 1

        conn.commit()
        pct = 100 * (i + len(batch)) / len(vessels)
        print(f"  Processed {i + len(batch)}/{len(vessels)} ({pct:.0f}%) — inserted: {inserted}, skipped: {skipped}")

    except Exception as e:
        conn.rollback()
        print(f"  ERROR at batch {i}: {e}")
        # Try to continue
        conn = psycopg2.connect(DB_URL)
        cur = conn.cursor()

# Final count
cur.execute("SELECT COUNT(*) FROM documents")
after_count = cur.fetchone()[0]

print(f"\n{'='*50}")
print(f"SEEDING COMPLETE")
print(f"{'='*50}")
print(f"Inserted: {inserted}")
print(f"Skipped (duplicates): {skipped}")
print(f"Documents before: {before_count}")
print(f"Documents after:  {after_count}")
print(f"Net added: {after_count - before_count}")

cur.close()
conn.close()

if inserted > 0:
    print(f"\nNEXT STEP: Regenerate embeddings for new documents.")
    print(f"SSH into the VM and run:")
    print(f"  ssh astoria-vm")
    print(f"  cd ~/astoria-v2/backend")
    print(f"  docker compose exec backend python -m scripts.seed_embeddings")
    print(f"\nThis will generate E5-large-v2 embeddings for all {after_count} documents.")
