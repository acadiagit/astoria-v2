-- Astoria v2 — Phase 3: Vessel Events Table
--
-- Creates a structured events table that decomposes each vessel's
-- registration history into individual queryable events.
--
-- Each event represents one enrollment or registration action:
--   - event_type: 'enrolled' (domestic trade) vs 'registered' (foreign trade)
--   - event_port: where the document was issued (vessel present)
--   - previous_port: where it came from (enables voyage reconstruction)
--   - master: captain at that time
--   - owners_text: full ownership string for text search
--
-- Run in Supabase SQL Editor.

-- ============================================================
-- 1. Vessel Events Table
-- ============================================================

CREATE TABLE IF NOT EXISTS vessel_events (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id     UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    vessel_name     TEXT NOT NULL,
    event_type      TEXT NOT NULL,       -- 'enrolled', 'registered', 'enrolled_temporary', 'registered_temporary'
    event_date      DATE,
    event_port      TEXT,                -- port where document was issued
    previous_port   TEXT,                -- "Previously enrolled at X" → departure port
    doc_number      TEXT,                -- "No. 55"
    master          TEXT,                -- captain name at this event
    owners_text     TEXT,                -- full owners string (for text search)
    owner_shares    JSONB DEFAULT '[]',  -- parsed [{name, share, residence}]
    notes           TEXT,                -- surrendered, tonnage amended, change of master, etc.
    event_index     INTEGER,             -- sequential position within vessel record (0-based)
    metadata        JSONB DEFAULT '{}',
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 2. Indexes for fast queries
-- ============================================================

-- Find all events for a vessel
CREATE INDEX idx_vessel_events_name ON vessel_events(vessel_name);
CREATE INDEX idx_vessel_events_name_lower ON vessel_events(LOWER(vessel_name));

-- Find events by port (where did vessels go?)
CREATE INDEX idx_vessel_events_port ON vessel_events(event_port);

-- Find events by master/captain
CREATE INDEX idx_vessel_events_master ON vessel_events(master);

-- Chronological queries
CREATE INDEX idx_vessel_events_date ON vessel_events(event_date);

-- Find events by type (enrolled vs registered)
CREATE INDEX idx_vessel_events_type ON vessel_events(event_type);

-- Link back to parent document
CREATE INDEX idx_vessel_events_doc ON vessel_events(document_id);

-- Full text search on owners
CREATE INDEX idx_vessel_events_owners_trgm ON vessel_events USING GIN(owners_text gin_trgm_ops);

-- JSONB metadata
CREATE INDEX idx_vessel_events_metadata ON vessel_events USING GIN(metadata);

-- ============================================================
-- 3. Row-Level Security
-- ============================================================

ALTER TABLE vessel_events ENABLE ROW LEVEL SECURITY;

-- Everyone can read vessel events
CREATE POLICY "vessel_events_read_all" ON vessel_events
    FOR SELECT USING (true);

-- Only service role can write (via scripts)
CREATE POLICY "vessel_events_service_write" ON vessel_events
    FOR ALL TO service_role
    USING (true);

-- ============================================================
-- 4. Enhanced Search: match_chunks_filtered()
-- ============================================================
--
-- Like match_chunks() but supports optional JSONB metadata filtering.
-- When a user asks about a specific vessel, filter to that vessel's
-- chunks first, then rank by similarity.

CREATE OR REPLACE FUNCTION match_chunks_filtered(
    query_embedding vector(1024),
    filter_metadata JSONB DEFAULT NULL,
    match_threshold float DEFAULT 0.5,
    match_count int DEFAULT 20
)
RETURNS TABLE (
    id UUID,
    document_id UUID,
    content TEXT,
    metadata JSONB,
    similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF filter_metadata IS NOT NULL THEN
        -- Filtered search: match chunks whose metadata contains the filter keys
        RETURN QUERY
        SELECT
            dc.id,
            dc.document_id,
            dc.content,
            dc.metadata,
            1 - (dc.embedding <=> query_embedding) AS similarity
        FROM document_chunks dc
        WHERE dc.metadata @> filter_metadata
          AND 1 - (dc.embedding <=> query_embedding) > match_threshold
        ORDER BY dc.embedding <=> query_embedding
        LIMIT match_count;
    ELSE
        -- Unfiltered search: standard semantic search (same as match_chunks)
        RETURN QUERY
        SELECT
            dc.id,
            dc.document_id,
            dc.content,
            dc.metadata,
            1 - (dc.embedding <=> query_embedding) AS similarity
        FROM document_chunks dc
        WHERE 1 - (dc.embedding <=> query_embedding) > match_threshold
        ORDER BY dc.embedding <=> query_embedding
        LIMIT match_count;
    END IF;
END;
$$;

-- ============================================================
-- 5. Voyage Reconstruction View
-- ============================================================
--
-- A convenience view that pairs each event with its "previously at"
-- port to show voyage legs: departed_from → arrived_at

CREATE OR REPLACE VIEW vessel_voyages AS
SELECT
    ve.vessel_name,
    ve.previous_port AS departed_from,
    ve.event_port AS arrived_at,
    ve.event_date,
    ve.event_type,
    ve.master,
    ve.doc_number,
    ve.document_id
FROM vessel_events ve
WHERE ve.previous_port IS NOT NULL
ORDER BY ve.vessel_name, ve.event_date;
