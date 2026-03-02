"""
Astoria v2 — Natural Language to SQL service.

Converts user questions into safe SQL queries against the maritime database.
Uses Gemini Flash for speed. Validates generated SQL before execution.

Schema is defined here as the single source of truth for SQL generation.
"""

import re
import structlog
import psycopg

from app.core.config import get_settings
from app.services.llm_router import call_gemini

logger = structlog.get_logger()

# ── Schema Description (Single Source of Truth) ──────────────

SCHEMA_DESCRIPTION = """
You have access to a PostgreSQL database containing maritime ship registers
from the Machias Customs District, Maine, 1780-1930. The database documents
nearly 2,000 vessels including their construction, ownership, voyages, and
enrollment histories.

TABLE: documents
  - id (UUID, primary key)
  - title (TEXT) — document title, e.g. 'Ship Registry: A. B. Perry'
  - archive_name (TEXT) — collection name, e.g. 'Machias Ship Registers 1780-1930'
  - content_type (TEXT) — always 'text'
  - raw_content (TEXT) — full text of the ship registry entry including all
    enrollment records, ownership changes, voyages, and re-registrations
  - checksum (TEXT, unique) — deduplication hash
  - metadata (JSONB) — structured data with these keys:
      * type (text): 'ship' | 'port_profile' | 'historical_context' |
                     'ship_construction' | 'maritime_geography'
      * vessel_name (text) — e.g. 'ACARA', 'A. B. PERRY'
      * vessel_type (text) — 'schooner', 'brig', 'bark', 'sloop', 'ship',
                              'steam screw', 'gas screw'
      * hailing_port (text) — home port, e.g. 'Addison', 'Machias', 'Jonesport'
      * official_number (text) — federal registration number
      * tonnage (numeric) — vessel tonnage (gross or old measurement)
      * tonnage_net (numeric) — net tonnage (when available)
      * dimensions (text) — e.g. '91.5 ft. x 27.3 ft. x 8.2 ft.'
      * year_built (integer) — construction year
      * place_built (text) — where built, e.g. 'Addison', 'East Machias', 'Bath'
      * builder (text) — master carpenter, e.g. 'William A. Nash', 'Eli Foster'
      * decks (integer) — number of decks
      * masts (integer) — number of masts
      * stern_type (text) — 'square', 'elliptic', 'round'
      * head_type (text) — 'billethead', 'figurehead', 'scroll head'
      * owners_first_enrollment (text) — initial owners and shares
      * master_first_enrollment (text) — initial ship master/captain
      For port/history docs: topic, region, time_period, keywords (array)
  - ingested_at (TIMESTAMPTZ)

TABLE: document_chunks
  - id (UUID, primary key)
  - document_id (UUID, FK → documents.id)
  - chunk_index (INTEGER) — position within the document
  - content (TEXT) — chunk text (contains enrollment records, voyages, etc.)
  - metadata (JSONB) — chunk-level metadata
  - token_count (INTEGER)
  - embedding (vector(1024)) — E5-large-v2 embedding

IMPORTANT NOTES about the data:
- The raw_content field contains the FULL enrollment history — every time the
  vessel was enrolled, registered, or changed owners/masters, that record
  appears in raw_content. This is where voyage and ownership change data lives.
- Ownership was fractional: shares in 1/16, 1/32, or 1/64 divisions.
- The 'master' was the ship's captain.
- Enrollment records contain dates and ports showing vessel movements.
- Use raw_content with ILIKE for full-text searches of enrollment histories.
- Use metadata JSONB for structured queries (tonnage, year_built, etc.).

JSONB access: metadata->>'key' for text, (metadata->>'key')::numeric for numbers.
"""

# ── Few-shot SQL Examples ────────────────────────────────────

SQL_EXAMPLES = """
Example queries:

Q: How many schooners were built in Addison?
A: SELECT COUNT(*) AS schooner_count
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND metadata->>'vessel_type' ILIKE '%schooner%'
     AND metadata->>'place_built' ILIKE '%Addison%'

Q: List all vessels built before 1820 with their tonnage
A: SELECT metadata->>'vessel_name' AS vessel,
          metadata->>'vessel_type' AS type,
          (metadata->>'year_built')::int AS year,
          (metadata->>'tonnage')::numeric AS tons,
          metadata->>'place_built' AS built_at
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND (metadata->>'year_built')::int < 1820
   ORDER BY (metadata->>'year_built')::int

Q: Which builders constructed the most vessels?
A: SELECT metadata->>'builder' AS builder,
          COUNT(*) AS vessels_built
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND metadata->>'builder' IS NOT NULL
     AND metadata->>'builder' != 'null'
   GROUP BY metadata->>'builder'
   ORDER BY vessels_built DESC
   LIMIT 20

Q: What is the largest vessel by tonnage?
A: SELECT metadata->>'vessel_name' AS vessel,
          metadata->>'vessel_type' AS type,
          (metadata->>'tonnage')::numeric AS tons,
          metadata->>'place_built' AS built_at,
          (metadata->>'year_built')::int AS year
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND metadata->>'tonnage' IS NOT NULL
   ORDER BY (metadata->>'tonnage')::numeric DESC
   LIMIT 10

Q: Show me the enrollment history for the ship ACARA
A: SELECT title,
          metadata->>'vessel_name' AS vessel,
          metadata->>'hailing_port' AS port,
          raw_content
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND metadata->>'vessel_name' ILIKE '%ACARA%'

Q: Compare the average tonnage of schooners vs brigs
A: SELECT metadata->>'vessel_type' AS type,
          COUNT(*) AS count,
          ROUND(AVG((metadata->>'tonnage')::numeric), 1) AS avg_tonnage,
          ROUND(MIN((metadata->>'tonnage')::numeric), 1) AS min_tonnage,
          ROUND(MAX((metadata->>'tonnage')::numeric), 1) AS max_tonnage
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND metadata->>'tonnage' IS NOT NULL
     AND metadata->>'vessel_type' IN ('schooner', 'brig')
   GROUP BY metadata->>'vessel_type'

Q: What vessels were associated with the port of Jonesport?
A: SELECT metadata->>'vessel_name' AS vessel,
          metadata->>'vessel_type' AS type,
          metadata->>'hailing_port' AS home_port,
          (metadata->>'tonnage')::numeric AS tons,
          (metadata->>'year_built')::int AS year
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND (metadata->>'hailing_port' ILIKE '%Jonesport%'
          OR metadata->>'place_built' ILIKE '%Jonesport%')
   ORDER BY (metadata->>'year_built')::int

Q: Find all enrollment records mentioning a specific captain
A: SELECT metadata->>'vessel_name' AS vessel,
          metadata->>'vessel_type' AS type,
          metadata->>'hailing_port' AS port,
          raw_content
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND raw_content ILIKE '%Master: George K. Merritt%'

Q: How many vessels were built per decade?
A: SELECT (((metadata->>'year_built')::int / 10) * 10)::text || 's' AS decade,
          COUNT(*) AS vessels_built
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND metadata->>'year_built' IS NOT NULL
   GROUP BY ((metadata->>'year_built')::int / 10) * 10
   ORDER BY ((metadata->>'year_built')::int / 10) * 10

Q: Which ports produced the most vessels?
A: SELECT metadata->>'place_built' AS port,
          COUNT(*) AS vessels_built,
          ROUND(AVG((metadata->>'tonnage')::numeric), 1) AS avg_tonnage
   FROM documents
   WHERE metadata->>'type' = 'ship'
     AND metadata->>'place_built' IS NOT NULL
     AND metadata->>'place_built' != 'null'
   GROUP BY metadata->>'place_built'
   ORDER BY vessels_built DESC
   LIMIT 20
"""

# ── System Prompt ────────────────────────────────────────────

SQL_SYSTEM_PROMPT = f"""You are a SQL expert for a maritime history database
covering the Machias Customs District, Maine, 1780-1930.

Given a natural language question, generate a single PostgreSQL SELECT query.

{SCHEMA_DESCRIPTION}

{SQL_EXAMPLES}

Rules:
1. ONLY generate SELECT statements. Never INSERT, UPDATE, DELETE, DROP, ALTER, or TRUNCATE.
2. Use JSONB operators (->>, ->) to access metadata fields.
3. Cast numeric JSONB values: (metadata->>'tonnage')::numeric
4. Always LIMIT results to at most 50 rows unless the user asks for a count or aggregate.
5. Use ILIKE for case-insensitive text matching.
6. When looking for captain/master information, search raw_content with ILIKE '%Master: name%'.
7. For enrollment history and voyages, return raw_content so the full record is available.
8. Always filter by metadata->>'type' = 'ship' when querying vessel data.
9. For aggregate queries (counts, averages), exclude NULL values with IS NOT NULL.
10. Return ONLY the SQL query, no explanation, no markdown fences."""


# ── Dangerous SQL patterns ───────────────────────────────────

_FORBIDDEN_PATTERNS = re.compile(
    r"\b(INSERT|UPDATE|DELETE|DROP|ALTER|TRUNCATE|CREATE|GRANT|REVOKE|EXEC|EXECUTE)\b",
    re.IGNORECASE,
)


def generate_sql(question: str) -> str | None:
    """Generate a SQL query from a natural language question.

    Returns the SQL string, or None if generation fails.
    """
    try:
        raw = call_gemini(SQL_SYSTEM_PROMPT, question)
        sql = _clean_sql(raw)

        if not _validate_sql(sql):
            logger.warning("sql_validation_failed", sql=sql)
            return None

        return sql
    except Exception as e:
        logger.error("sql_generation_failed", error=str(e))
        return None


def _clean_sql(raw: str) -> str:
    """Strip markdown fences and whitespace from LLM output."""
    sql = raw.strip()
    # Remove ```sql ... ``` fences
    if sql.startswith("```"):
        lines = sql.split("\n")
        lines = [l for l in lines if not l.strip().startswith("```")]
        sql = "\n".join(lines).strip()
    # Remove trailing semicolons (we add our own)
    sql = sql.rstrip(";").strip()
    return sql


def _validate_sql(sql: str) -> bool:
    """Basic safety validation of generated SQL."""
    if not sql:
        return False

    # Must start with SELECT (or WITH for CTEs)
    upper = sql.strip().upper()
    if not (upper.startswith("SELECT") or upper.startswith("WITH")):
        return False

    # Check for forbidden operations
    if _FORBIDDEN_PATTERNS.search(sql):
        return False

    return True


def execute_sql(sql: str) -> tuple[list[dict], list[str]]:
    """Execute a validated SQL query against Supabase's Postgres.

    Returns (rows_as_dicts, column_names).
    Uses direct connection (not pooler) for reliable access.
    """
    settings = get_settings()

    # Use DATABASE_URL from env if available, otherwise build direct connection
    if settings.database_url:
        conn_string = settings.database_url
    else:
        # Fallback: build direct connection from Supabase URL
        project_ref = settings.supabase_url.replace("https://", "").replace(".supabase.co", "")
        conn_string = (
            f"postgresql://postgres:{settings.supabase_service_role_key}"
            f"@db.{project_ref}.supabase.co:5432/postgres"
        )

    try:
        with psycopg.connect(conn_string, autocommit=True) as conn:
            with conn.cursor() as cur:
                cur.execute(sql)
                columns = [desc[0] for desc in cur.description] if cur.description else []
                rows = cur.fetchall()

                # Convert to list of dicts
                result = [dict(zip(columns, row)) for row in rows]
                return result, columns

    except Exception as e:
        logger.error("sql_execution_failed", error=str(e), sql=sql)
        raise
