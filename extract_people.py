#!/usr/bin/env python3
"""
Astoria v2 — Phase 3: Extract people (masters, owners, builders) from vessel data.

Parses three data sources:
  1. vessel_events.json → master names per event
  2. vessel_events.json → owners_text → individual owner names + shares
  3. vessels_extracted.json → builder per vessel

Outputs person_roles.json with one record per person+vessel+role combination.
"""

import json
import re
import sys
from collections import defaultdict


def clean_name(name):
    """Clean and normalize a person's name."""
    if not name:
        return None
    # Fix OCR-spaced initials: "A . L ." → "A. L."
    name = re.sub(r'(\w)\s+\.', r'\1.', name)
    # Fix missing space after period: "A.L." → "A. L."
    name = re.sub(r'\.([A-Z])', r'. \1', name)
    # Remove multiple spaces
    name = re.sub(r'\s+', ' ', name).strip()
    # Remove trailing periods and junk
    name = name.rstrip(' .,;:')
    # Remove leading junk characters
    name = re.sub(r'^[^A-Za-z]+', '', name)
    # Skip if too short or clearly not a name
    if not name or len(name) < 3:
        return None
    # Skip if it's all lowercase (probably a word, not a name)
    if name == name.lower():
        return None
    # Skip common non-name strings
    skip_words = {'same', 'sane', 'samo', 'none', 'copartners', 'agent', 'and',
                  'with', 'exception', 'lieu', 'Abstracts', 'Registers', 'Enrollments',
                  'Master', 'Owners', 'Previously', 'Registered', 'Enrolled',
                  'Square', 'Elliptic', 'Round', 'stern', 'Haster', 'Oumers',
                  'Ormers', 'Overs', 'Ovmers', 'Moster', 'Change', 'Surrendered'}
    # Also skip known town/place names that get captured as person names
    town_names = {
        'new york city', 'east machias', 'columbia falls', 'jonesport',
        'machias', 'addison', 'harrington', 'cherryfield', 'boston',
        'portland', 'millbridge', 'steuben', 'cutler', 'lubec',
        'calais', 'eastport', 'pembroke', 'dennysville', 'columbia',
        'new bedford', 'philadelphia', 'baltimore', 'new york',
        'bangor', 'rockland', 'bath', 'ellsworth', 'bucksport',
        'tremont', 'augusta', 'norfolk', 'mobile', 'savannah',
        'fernandina', 'new haven', 'bridgeport', 'charleston',
        'new orleans', 'st george', 'whiting', 'machiasport',
        'marshfield', 'roque bluffs', 'bucks harbor', 'centerville',
        'south addison', 'west jonesport', 'indian river', 'perry',
    }
    if name.lower() in town_names:
        return None
    if name.split()[0] in skip_words:
        return None
    return name


def extract_last_name(name):
    """Extract the likely surname from a full name."""
    if not name:
        return None
    parts = name.split()
    if not parts:
        return None
    # Last word that's not a suffix (Jr., Sr., etc.)
    for p in reversed(parts):
        if p.rstrip('.') not in ('Jr', 'Sr', 'III', 'II', 'IV'):
            return p.rstrip('.')
    return parts[-1].rstrip('.')


def parse_owners_text(owners_text, vessel_name, event_date):
    """Parse owners_text into individual owner records.

    Format patterns:
      "John B. Chandler, 4/64, Abraham K. McKenzie, 2/64, ... Harrington"
      "Jesse L. Nash, 3/4, Columbia ; Alexander H. Wass, 1/4, Boston, Mass"
      "same, with exception of X, 2/64, in lieu of Y, 2/64"
    """
    if not owners_text:
        return []

    # Skip "same" variants
    text = owners_text.strip()
    if text.lower().startswith('same') and 'exception' not in text.lower():
        return []

    owners = []

    # Handle "with exception of X in lieu of Y" — extract just the new owner
    exception_match = re.search(
        r'exception\s+of\s+(.+?)(?:,\s*\d+\s*/\s*\d+)?(?:,\s*(?:agent\s*,?\s*)?(\w[\w\s]*?))?(?:\s*,?\s*in\s+lieu)',
        text, re.IGNORECASE
    )
    if exception_match:
        name = clean_name(exception_match.group(1))
        if name:
            owners.append({
                'person_name': name,
                'ownership_share': None,
                'residence': None,
            })
        return owners

    # Main parsing: split on semicolons first (separate town groups)
    # Then within each group, find "Name, share" patterns

    # Pattern: Name (with initials), optional share (N/N)
    # Names are typically: "FirstName MiddleInitial. LastName" or "F. M. LastName"
    owner_pattern = re.compile(
        r'([A-Z][a-zA-Z]*(?:\s*\.?\s+[A-Z][\.\w]*)*(?:\s+[A-Z][a-zA-Z]+)+)'  # name
        r'\s*,?\s*'
        r'(\d+\s*/\s*\d+)?'  # optional share
    )

    # Find all name-like patterns
    for m in owner_pattern.finditer(text):
        raw_name = m.group(1).strip()
        share = m.group(2)

        name = clean_name(raw_name)
        if not name:
            continue

        # Clean up share formatting
        if share:
            share = re.sub(r'\s+', '', share)  # "4 / 64" → "4/64"

        # Try to extract residence (town name after the share, before semicolon)
        residence = None
        after_match = text[m.end():]
        res_match = re.match(r'\s*,?\s*([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*(?:\s*,\s*[A-Z][a-z]+\.?)?)\s*[;\.]',
                            after_match)
        if res_match:
            res = res_match.group(1).strip()
            # Only accept if it looks like a place name (not another person)
            if len(res.split()) <= 4 and not re.search(r'\d+\s*/\s*\d+', after_match[:len(res)+5]):
                residence = res

        # Skip entries without a share that look like place names
        # (place names appear after the last owner in a group, before semicolon)
        if not share:
            words = name.split()
            has_initial = any(w.endswith('.') and len(w) <= 3 for w in words)
            if not has_initial and len(words) <= 3:
                # Likely a town name unless it matches "Firstname Lastname" with common first names
                continue

        owners.append({
            'person_name': name,
            'ownership_share': share,
            'residence': residence,
        })

    return owners


def main():
    # Load data
    with open('/sessions/ecstatic-practical-pasteur/mnt/coworker/astoria-v2/vessel_events.json') as f:
        events = json.load(f)
    print(f"Loaded {len(events)} vessel events")

    with open('/sessions/ecstatic-practical-pasteur/mnt/coworker/astoria-v2/vessels_extracted.json') as f:
        vessels = json.load(f)
    print(f"Loaded {len(vessels)} vessel records")

    # Aggregate: (person_name_normalized, vessel_name, role) → record
    people = {}  # key: (name_norm, vessel, role) → aggregated data

    # ── 1. Extract MASTERS from vessel_events ──
    last_master = {}  # per vessel, track last known master
    master_count = 0
    for ev in events:
        vessel = ev['vessel_name']
        master = ev.get('master')

        if master and master != '(same as previous)':
            last_master[vessel] = master
        elif master == '(same as previous)':
            master = last_master.get(vessel)

        if not master or master == '(same as previous)':
            continue

        name = clean_name(master)
        if not name:
            continue

        key = (name.lower(), vessel, 'master')
        date = ev.get('event_date')

        if key not in people:
            people[key] = {
                'person_name': name,
                'person_name_normalized': name.lower(),
                'last_name': extract_last_name(name),
                'vessel_name': vessel,
                'role': 'master',
                'ownership_share': None,
                'residence': None,
                'first_date': date,
                'last_date': date,
                'event_count': 1,
            }
            master_count += 1
        else:
            rec = people[key]
            rec['event_count'] += 1
            if date:
                if not rec['first_date'] or date < rec['first_date']:
                    rec['first_date'] = date
                if not rec['last_date'] or date > rec['last_date']:
                    rec['last_date'] = date

    print(f"Masters extracted: {master_count} unique person-vessel pairs")

    # ── 2. Extract OWNERS from owners_text ──
    owner_count = 0
    for ev in events:
        vessel = ev['vessel_name']
        owners_text = ev.get('owners_text')
        date = ev.get('event_date')

        if not owners_text or owners_text == '(same as previous)':
            continue

        parsed = parse_owners_text(owners_text, vessel, date)
        for owner in parsed:
            name = owner['person_name']
            key = (name.lower(), vessel, 'owner')

            if key not in people:
                people[key] = {
                    'person_name': name,
                    'person_name_normalized': name.lower(),
                    'last_name': extract_last_name(name),
                    'vessel_name': vessel,
                    'role': 'owner',
                    'ownership_share': owner.get('ownership_share'),
                    'residence': owner.get('residence'),
                    'first_date': date,
                    'last_date': date,
                    'event_count': 1,
                }
                owner_count += 1
            else:
                rec = people[key]
                rec['event_count'] += 1
                if owner.get('ownership_share') and not rec['ownership_share']:
                    rec['ownership_share'] = owner['ownership_share']
                if owner.get('residence') and not rec['residence']:
                    rec['residence'] = owner['residence']
                if date:
                    if not rec['first_date'] or date < rec['first_date']:
                        rec['first_date'] = date
                    if not rec['last_date'] or date > rec['last_date']:
                        rec['last_date'] = date

    print(f"Owners extracted: {owner_count} unique person-vessel pairs")

    # ── 3. Extract BUILDERS from vessels_extracted.json ──
    builder_count = 0
    for v in vessels:
        builder = v.get('builder')
        if not builder:
            continue

        name = clean_name(builder)
        if not name:
            continue

        vessel = v['vessel_name']
        year = v.get('year_built')
        date = f"{year}-01-01" if year else None

        key = (name.lower(), vessel, 'builder')
        if key not in people:
            people[key] = {
                'person_name': name,
                'person_name_normalized': name.lower(),
                'last_name': extract_last_name(name),
                'vessel_name': vessel,
                'role': 'builder',
                'ownership_share': None,
                'residence': v.get('place_built'),
                'first_date': date,
                'last_date': date,
                'event_count': 1,
            }
            builder_count += 1

    print(f"Builders extracted: {builder_count} unique person-vessel pairs")

    # ── Convert to list and sort ──
    all_people = sorted(people.values(), key=lambda p: (p['person_name_normalized'], p['vessel_name']))

    # ── Statistics ──
    unique_names = len(set(p['person_name_normalized'] for p in all_people))
    unique_last_names = len(set(p['last_name'] for p in all_people if p['last_name']))

    roles = defaultdict(int)
    for p in all_people:
        roles[p['role']] += 1

    # Top people by vessel count
    person_vessels = defaultdict(set)
    for p in all_people:
        person_vessels[(p['person_name_normalized'], p['role'])].add(p['vessel_name'])

    top_masters = sorted(
        [(name, role, len(vess)) for (name, role), vess in person_vessels.items() if role == 'master'],
        key=lambda x: -x[2]
    )[:15]

    top_owners = sorted(
        [(name, role, len(vess)) for (name, role), vess in person_vessels.items() if role == 'owner'],
        key=lambda x: -x[2]
    )[:15]

    top_builders = sorted(
        [(name, role, len(vess)) for (name, role), vess in person_vessels.items() if role == 'builder'],
        key=lambda x: -x[2]
    )[:15]

    # Family analysis: last names appearing across multiple vessels
    family_vessels = defaultdict(set)
    for p in all_people:
        if p['last_name']:
            family_vessels[p['last_name']].add(p['vessel_name'])
    top_families = sorted(
        [(name, len(vess)) for name, vess in family_vessels.items()],
        key=lambda x: -x[1]
    )[:15]

    print(f"\n{'='*60}")
    print(f"PEOPLE EXTRACTION SUMMARY")
    print(f"{'='*60}")
    print(f"Total person-vessel-role records: {len(all_people)}")
    print(f"Unique person names: {unique_names}")
    print(f"Unique last names: {unique_last_names}")
    print(f"\nBy role:")
    for role, count in sorted(roles.items()):
        print(f"  {role}: {count}")

    print(f"\nTop 15 captains (by vessels commanded):")
    for name, role, count in top_masters:
        print(f"  {name}: {count} vessels")

    print(f"\nTop 15 owners (by vessels owned):")
    for name, role, count in top_owners:
        print(f"  {name}: {count} vessels")

    print(f"\nTop 15 builders (by vessels built):")
    for name, role, count in top_builders:
        print(f"  {name}: {count} vessels")

    print(f"\nTop 15 maritime families (by vessel involvement):")
    for name, count in top_families:
        print(f"  {name}: {count} vessels")

    # Save
    output_path = '/sessions/ecstatic-practical-pasteur/mnt/coworker/astoria-v2/person_roles.json'
    with open(output_path, 'w') as f:
        json.dump(all_people, f, indent=2)
    print(f"\nSaved {len(all_people)} records to {output_path}")


if __name__ == '__main__':
    main()
