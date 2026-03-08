#!/usr/bin/env python3
"""
Astoria v2 — Seed person_roles into Supabase.

Run from Mac:
    cd ~/coworker/astoria-v2
    source .venv/bin/activate
    python3 seed_people.py

Prerequisites:
    1. Run 005_person_roles.sql in Supabase SQL Editor first
    2. pip install psycopg2-binary (already in venv)
"""

import json
import psycopg2
import sys
import os

DB_URL = "postgresql://postgres:wMACHx0762303@db.mvxlmhxlfbdtnueysrex.supabase.co:5432/postgres"

ROLES_JSON = os.path.join(os.path.dirname(os.path.abspath(__file__)), "person_roles.json")

if not os.path.exists(ROLES_JSON):
    print(f"ERROR: Cannot find {ROLES_JSON}")
    sys.exit(1)

with open(ROLES_JSON, "r") as f:
    roles = json.load(f)

print(f"Loaded {len(roles)} person-role records")

conn = psycopg2.connect(DB_URL)
cur = conn.cursor()

# Check table exists
cur.execute("""
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables WHERE table_name = 'person_roles'
    )
""")
if not cur.fetchone()[0]:
    print("ERROR: person_roles table does not exist! Run 005_person_roles.sql first.")
    sys.exit(1)

cur.execute("SELECT COUNT(*) FROM person_roles")
before_count = cur.fetchone()[0]
print(f"Records before: {before_count}")

if before_count > 0:
    resp = input(f"person_roles already has {before_count} rows. Delete and re-seed? [y/N]: ").strip().lower()
    if resp == 'y':
        cur.execute("DELETE FROM person_roles")
        conn.commit()
        print(f"Deleted {before_count} existing records.")
    else:
        print("Aborting.")
        sys.exit(0)

# Build vessel_name → document_id map
cur.execute("""
    SELECT id, metadata->>'ship_name' AS ship_name
    FROM documents WHERE metadata->>'type' = 'ship'
""")
vessel_doc_map = {}
for doc_id, ship_name in cur.fetchall():
    if ship_name:
        vessel_doc_map[ship_name] = doc_id

print(f"Found {len(vessel_doc_map)} vessel documents")

BATCH_SIZE = 50
inserted = 0
skipped = 0

for i in range(0, len(roles), BATCH_SIZE):
    batch = roles[i:i + BATCH_SIZE]
    try:
        for r in batch:
            doc_id = vessel_doc_map.get(r["vessel_name"])
            if not doc_id:
                skipped += 1
                continue

            cur.execute(
                """INSERT INTO person_roles
                   (person_name, person_name_normalized, last_name, vessel_name,
                    role, ownership_share, residence, first_date, last_date,
                    event_count, document_id)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",
                (
                    r["person_name"],
                    r["person_name_normalized"],
                    r.get("last_name"),
                    r["vessel_name"],
                    r["role"],
                    r.get("ownership_share"),
                    r.get("residence"),
                    r.get("first_date"),
                    r.get("last_date"),
                    r.get("event_count", 1),
                    doc_id,
                )
            )
            inserted += 1
        conn.commit()
        pct = 100 * (i + len(batch)) / len(roles)
        print(f"  Processed {i + len(batch)}/{len(roles)} ({pct:.0f}%) — inserted: {inserted}")
    except Exception as ex:
        conn.rollback()
        print(f"  ERROR at batch {i}: {ex}")
        conn = psycopg2.connect(DB_URL)
        cur = conn.cursor()

cur.execute("SELECT COUNT(*) FROM person_roles")
after_count = cur.fetchone()[0]

print(f"\n{'='*50}")
print(f"PEOPLE SEEDING COMPLETE")
print(f"{'='*50}")
print(f"Inserted: {inserted}")
print(f"Skipped: {skipped}")
print(f"Records in table: {after_count}")

# Stats
cur.execute("SELECT role, COUNT(*) FROM person_roles GROUP BY role ORDER BY COUNT(*) DESC")
print(f"\nBy role:")
for role, count in cur.fetchall():
    print(f"  {role}: {count}")

cur.execute("SELECT COUNT(DISTINCT person_name_normalized) FROM person_roles")
print(f"\nUnique people: {cur.fetchone()[0]}")

cur.execute("SELECT COUNT(DISTINCT last_name) FROM person_roles WHERE last_name IS NOT NULL")
print(f"Unique family names: {cur.fetchone()[0]}")

cur.close()
conn.close()
print(f"\nDone! Try: SELECT * FROM captain_careers LIMIT 10;")
