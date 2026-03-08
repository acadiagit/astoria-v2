-- ============================================================
-- Astoria v2 — Migration 005: Person Roles (People Index)
-- ============================================================
-- Maps every person to every vessel they were associated with,
-- enabling queries like:
--   "All voyages of Captain John B. Chandler"
--   "All vessels owned by the Crowley family"
--   "Career of builder William A. Nash"
-- ============================================================

-- 1. Create the person_roles table
CREATE TABLE IF NOT EXISTS person_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    person_name TEXT NOT NULL,           -- normalized name, e.g. 'John B. Chandler'
    person_name_normalized TEXT NOT NULL, -- lowercase for matching, e.g. 'john b. chandler'
    last_name TEXT,                       -- extracted surname for family queries
    vessel_name TEXT NOT NULL,            -- vessel name (Title Case)
    role TEXT NOT NULL,                   -- 'master', 'owner', 'builder'
    ownership_share TEXT,                 -- e.g. '4/64' (owners only)
    residence TEXT,                       -- town of residence (when available)
    first_date DATE,                     -- earliest date in this role for this vessel
    last_date DATE,                      -- latest date in this role for this vessel
    event_count INTEGER DEFAULT 1,       -- how many events with this person+vessel+role
    document_id UUID REFERENCES documents(id),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_person_roles_name
    ON person_roles (person_name_normalized);

CREATE INDEX IF NOT EXISTS idx_person_roles_last_name
    ON person_roles (last_name);

CREATE INDEX IF NOT EXISTS idx_person_roles_vessel
    ON person_roles (vessel_name);

CREATE INDEX IF NOT EXISTS idx_person_roles_role
    ON person_roles (role);

CREATE INDEX IF NOT EXISTS idx_person_roles_document
    ON person_roles (document_id);

-- Trigram index for fuzzy name matching (handles OCR variations)
CREATE INDEX IF NOT EXISTS idx_person_roles_name_trgm
    ON person_roles USING gin (person_name_normalized gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_person_roles_last_name_trgm
    ON person_roles USING gin (last_name gin_trgm_ops);

-- Composite indexes for common joins
CREATE INDEX IF NOT EXISTS idx_person_roles_name_role
    ON person_roles (person_name_normalized, role);

CREATE INDEX IF NOT EXISTS idx_person_roles_last_name_role
    ON person_roles (last_name, role);

-- 3. Row Level Security
ALTER TABLE person_roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "person_roles_read_all"
    ON person_roles FOR SELECT
    USING (true);

CREATE POLICY "person_roles_write_service"
    ON person_roles FOR ALL
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- 4. Convenience views

-- All roles for a person across all vessels
CREATE OR REPLACE VIEW person_career AS
SELECT
    person_name,
    last_name,
    role,
    vessel_name,
    first_date,
    last_date,
    event_count,
    ownership_share,
    residence,
    document_id
FROM person_roles
ORDER BY person_name_normalized, first_date;

-- Family connections: people sharing a last name who appear on the same vessel
CREATE OR REPLACE VIEW family_vessel_connections AS
SELECT
    a.last_name AS family_name,
    a.person_name AS person_a,
    a.role AS role_a,
    b.person_name AS person_b,
    b.role AS role_b,
    a.vessel_name,
    a.first_date
FROM person_roles a
JOIN person_roles b
    ON a.last_name = b.last_name
    AND a.vessel_name = b.vessel_name
    AND a.person_name < b.person_name  -- avoid duplicates/self-joins
WHERE a.last_name IS NOT NULL
ORDER BY a.last_name, a.vessel_name;

-- Captain career summary
CREATE OR REPLACE VIEW captain_careers AS
SELECT
    person_name,
    last_name,
    COUNT(DISTINCT vessel_name) AS vessels_commanded,
    MIN(first_date) AS career_start,
    MAX(last_date) AS career_end,
    ARRAY_AGG(DISTINCT vessel_name ORDER BY vessel_name) AS vessel_list
FROM person_roles
WHERE role = 'master'
GROUP BY person_name, last_name, person_name_normalized
ORDER BY vessels_commanded DESC;

-- Builder portfolio
CREATE OR REPLACE VIEW builder_portfolios AS
SELECT
    pr.person_name AS builder,
    pr.last_name,
    COUNT(DISTINCT pr.vessel_name) AS vessels_built,
    ARRAY_AGG(DISTINCT pr.vessel_name ORDER BY pr.vessel_name) AS vessel_list,
    MIN(pr.first_date) AS first_build,
    MAX(pr.last_date) AS last_build
FROM person_roles pr
WHERE pr.role = 'builder'
GROUP BY pr.person_name, pr.last_name, pr.person_name_normalized
ORDER BY vessels_built DESC;

COMMENT ON TABLE person_roles IS 'Maps people to vessels and roles (master, owner, builder) for relationship queries';
COMMENT ON VIEW person_career IS 'Chronological career view for any person across all vessels';
COMMENT ON VIEW family_vessel_connections IS 'People sharing last names on the same vessel (family networks)';
COMMENT ON VIEW captain_careers IS 'Summary of each captain''s career: vessels commanded, date range';
COMMENT ON VIEW builder_portfolios IS 'Summary of each builder''s portfolio: vessels constructed';
