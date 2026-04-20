#!/usr/bin/env python3
"""
Astoria v2 — Phase 3A: Seed vessel events into Supabase.

Run this from the Mac:
    cd ~/coworker/astoria-v2
    source .venv/bin/activate
    python3 seed_events.py

Prerequisites:
    1. Run 004_vessel_events.sql in Supabase SQL Editor first
    2. pip install psycopg2-binary (already in venv from Phase 2)

This inserts 2,155 structured events extracted from 575 vessel records
into the Supabase `vessel_events` table.
"""

import json
import psycopg2
import sys
import os

# --- Supabase connection ---
DB_URL = "postgresql://postgres:wMACHx0762303@db.cnkbkzfacepjgnvamlvn.supabase.co:5432/postgres"

# Load extracted events
EVENTS_JSON = os.path.join(os.path.dirname(os.path.abspath(__file__)), "vessel_events.json")

if not os.path.exists(EVENTS_JSON):
    print(f"ERROR: Cannot find {EVENTS_JSON}")
    print(f"Run extract_events.py first to generate vessel_events.json")
    sys.exit(1)

with open(EVENTS_JSON, "r") as f:
    events = json.load(f)

print(f"Loaded {len(events)} events from JSON")

# --- Connect ---
print(f"Connecting to Supabase...")
conn = psycopg2.connect(DB_URL)
cur = conn.cursor()

# Check if vessel_events table exists
cur.execute("""
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_name = 'vessel_events'
    )
""")
if not cur.fetchone()[0]:
    print("ERROR: vessel_events table does not exist!")
    print("Run 004_vessel_events.sql in Supabase SQL Editor first.")
    sys.exit(1)

# Check current count
cur.execute("SELECT COUNT(*) FROM vessel_events")
before_count = cur.fetchone()[0]
print(f"Events before: {before_count}")

if before_count > 0:
    print(f"\nWARNING: vessel_events already has {before_count} rows.")
    resp = input("Delete existing events and re-seed? [y/N]: ").strip().lower()
    if resp == 'y':
        cur.execute("DELETE FROM vessel_events")
        conn.commit()
        print(f"Deleted {before_count} existing events.")
    else:
        print("Aborting.")
        sys.exit(0)

# --- Build a lookup: vessel_name → document_id ---
print("Building vessel → document_id mapping...")
cur.execute("""
    SELECT id, metadata->>'ship_name' AS ship_name
    FROM documents
    WHERE metadata->>'type' = 'ship'
""")
vessel_doc_map = {}
for doc_id, ship_name in cur.fetchall():
    if ship_name:
        vessel_doc_map[ship_name] = doc_id

print(f"Found {len(vessel_doc_map)} vessel documents")

# --- Insert events ---
BATCH_SIZE = 50
inserted = 0
skipped = 0
missing_vessel = set()

for i in range(0, len(events), BATCH_SIZE):
    batch = events[i:i + BATCH_SIZE]
    try:
        for e in batch:
            # Look up document_id for this vessel
            doc_id = vessel_doc_map.get(e["vessel_name"])
            if not doc_id:
                missing_vessel.add(e["vessel_name"])
                skipped += 1
                continue

            cur.execute(
                """INSERT INTO vessel_events
                   (document_id, vessel_name, event_type, event_date, event_port,
                    previous_port, doc_number, master, owners_text, notes, event_index, metadata)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s::jsonb)""",
                (
                    doc_id,
                    e["vessel_name"],
                    e["event_type"],
                    e.get("event_date"),
                    e.get("event_port"),
                    e.get("previous_port"),
                    e.get("doc_number"),
                    e.get("master"),
                    e.get("owners_text"),
                    e.get("notes"),
                    e.get("event_index", 0),
                    json.dumps({"entry_num": e.get("entry_num")})
                )
            )
            inserted += 1

        conn.commit()
        pct = 100 * (i + len(batch)) / len(events)
        print(f"  Processed {i + len(batch)}/{len(events)} ({pct:.0f}%) — inserted: {inserted}, skipped: {skipped}")

    except Exception as ex:
        conn.rollback()
        print(f"  ERROR at batch {i}: {ex}")
        conn = psycopg2.connect(DB_URL)
        cur = conn.cursor()

# Final count
cur.execute("SELECT COUNT(*) FROM vessel_events")
after_count = cur.fetchone()[0]

print(f"\n{'='*50}")
print(f"EVENT SEEDING COMPLETE")
print(f"{'='*50}")
print(f"Inserted: {inserted}")
print(f"Skipped (no matching document): {skipped}")
print(f"Events in table: {after_count}")

if missing_vessel:
    print(f"\nVessels without matching document ({len(missing_vessel)}):")
    for v in sorted(missing_vessel)[:10]:
        print(f"  - {v}")
    if len(missing_vessel) > 10:
        print(f"  ... and {len(missing_vessel) - 10} more")

# Quick stats
cur.execute("""
    SELECT event_type, COUNT(*) FROM vessel_events GROUP BY event_type ORDER BY COUNT(*) DESC
""")
print(f"\nEvent types in database:")
for etype, count in cur.fetchall():
    print(f"  {etype}: {count}")

cur.execute("""
    SELECT COUNT(DISTINCT vessel_name) FROM vessel_events
""")
print(f"\nDistinct vessels with events: {cur.fetchone()[0]}")

cur.execute("""
    SELECT COUNT(*) FROM vessel_events WHERE previous_port IS NOT NULL
""")
print(f"Voyage legs (with previous port): {cur.fetchone()[0]}")

cur.close()
conn.close()

print(f"\nDone! The vessel_events table is ready for queries.")
print(f"Next: rebuild Docker on the VM to pick up the updated retrieval code.")
