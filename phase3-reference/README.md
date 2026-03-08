# Astoria v2 — Phase 3 Reference Materials

**Structured Event Extraction from the Machias Ship Registers, 1780–1930**

This folder preserves the complete extraction pipeline and outputs from Phase 3
of the Astoria v2 maritime history project. These materials document how 2,155
structured vessel events were parsed from 911 ship registry entries covering
Part I (A–K) of *Ship Registers and Enrollments of Machias, Maine, 1780–1930*
(National Archives, digitized by Google Books).

---

## Data Files

### `vessels_extracted.json` (911 records, 2.3 MB)
Structured vessel records parsed from the PDF. Each record contains:
- `vessel_name` — Title Case (e.g., "A. B. Perry", "Alaska")
- `vessel_type` — schooner, brig, bark, sloop, ship, gas screw, steamer
- `hailing_port` — home port of registration
- `official_number` — federal registration number
- `place_built`, `year_built`, `builder` — construction details
- `tonnage` — in decimal tons (converted from historical 95ths system)
- `length_ft`, `beam_ft`, `depth_ft` — vessel dimensions
- `decks`, `masts`, `stern_type`, `head_type` — physical characteristics
- `raw_content` — the full original text of the registry entry

### `vessel_events.json` (2,155 events, 868 KB)
Individual enrollment and registration events extracted from vessel records:
- `vessel_name` — which vessel
- `event_type` — `enrolled` (domestic/coastal), `registered` (foreign trade),
  `enrolled_temporary`, `registered_temporary`
- `event_date` — ISO date (YYYY-MM-DD)
- `event_port` — where the document was issued (vessel physically present)
- `previous_port` — where vessel arrived from (enables voyage reconstruction)
- `master` — captain at time of event
- `owners_text` — ownership record (names and fractional shares)
- `doc_number` — enrollment/registration document number
- `notes` — surrendered, tonnage amended, trade changed, etc.

**Coverage**: 575 vessels with events, 796 voyage legs (with departure port).

---

## Extraction Scripts

### `extract_vessels.py`
Parses `pdftotext` output from the Machias Ship Registers PDF into structured
vessel records. Handles OCR artifacts including spaced initials, garbled port
names, and the historical 95ths tonnage system (e.g., "274 30/95 tons" → 274.32).

### `extract_events.py`
Parses each vessel's `raw_content` to extract individual enrollment/registration
events. Includes OCR port normalization (dozens of garbled "Machias" variants →
"Machias") and master name reconstruction from spaced OCR initials.

### `seed_vessels.py`
Inserts vessel records into the Supabase `documents` table with proper metadata
schema (archive_name, content_type, raw_content, checksum, metadata JSONB).

### `seed_events.py`
Populates the `vessel_events` table in Supabase by mapping extracted events to
their parent document IDs.

---

## Database Migration

### `004_vessel_events.sql`
PostgreSQL migration that creates:
- `vessel_events` table with indexes on vessel_name, event_port, master,
  event_date, event_type, and trigram index on owners_text
- `match_chunks_filtered()` function — like `match_chunks()` but supports
  JSONB metadata filtering for vessel-specific retrieval
- `vessel_voyages` view — pairs previous_port → event_port for voyage
  reconstruction

---

## Key Domain Notes

- **Enrolled** = documented for domestic/coastal trade (cabotage)
- **Registered** = documented for foreign/international voyages
- **Previous port** indicates where the vessel departed from; the event port
  is where it arrived. Together they form a voyage leg.
- **Fractional ownership**: vessels were divided into shares (1/16, 1/32, or
  1/64 divisions). Multiple owners held fractional interests.
- **Family networks** can be traced through shared surnames among owners.
- **Captain careers** can be reconstructed by tracking a master across
  multiple vessels and dates.
- Only **Part I (A–K)** of the registers was available for extraction.
  Part II (L–Z) remains to be located and processed.

---

## Statistics

| Metric | Count |
|--------|-------|
| Vessel records extracted | 911 |
| Vessels with events | 575 |
| Total events | 2,155 |
| Enrolled events | 998 |
| Registered events | 986 |
| Temporary events | 171 |
| Voyage legs (with previous port) | 796 |
| Event date coverage | 98% |
| Event port coverage | 100% |
| Master/captain coverage | 93% |
| Owners coverage | 87% |

---

*Extraction performed March 2026 using Claude (Anthropic) in collaboration
with Hugo Diaz, University of Maine. Part of the Astoria v2 open-source
maritime history RAG application: https://maritimehistory.live*
