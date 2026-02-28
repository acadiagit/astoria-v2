"""
Astoria v2 — Natural Language to SQL service.

Converts user questions into safe SQL queries against the maritime database.
Uses Gemini Flash for speed. Validates generated SQL before execution.
"""

import re
import structlog
import psycopg

from app.core.config import get_settings
from app.services.llm_router import call_gemini

logger = structlog.get_logger()

# Schema description for the LLM — tells it what tables/columns exist
SCHEMA_DESCRIPTION = """
You have access to a PostgreSQL database with the following schema:

TABLE: documents
  - id (UUID, primary key)
  - title (TEXT) — document title, often a ship name or record description
  - source_url (TEXT, nullable) — URL of the original source
  - archive_name (TEXT, nullable) — name of the archive collection
  - content_type (TEXT) — 'text', 'pdf', 'html', 'csv'
  - metadata (JSONB) — flexible metadata, commonly contains:
      - type: 'ship' | 'voyage' | 'port' | 'crew' | 'cargo'
      - ship_name (text)
      - ship_type (text) — e.g. 'clipper', 'bark', 'schooner', 'steamer'
      - tonnage (numeric)
      - year_built (integer)
      - port_of_registry (text)
      - departure_port (text)
      - arrival_port (text)
      - departure_date (text, ISO format)
      - arrival_date (text, ISO format)
      - cargo (text)
      - crew_count (integer)
      - captain (text)
  - ingested_at (TIMESTAMPTZ)

TABLE: document_chunks
  - id (UUID, primary key)
  - document_id (UUID, references documents)
  - chunk_index (INTEGER)
  - content (TEXT) — chunk text
  - metadata (JSONB) — chunk-level metadata
  - token_count (INTEGER)

TABLE: query_log
  - id, user_id, question, complexity, model_used, sql_generated, answer, processing_ms, created_at

TABLE: user_profiles
  - id (UUID, references auth.users)
  - display_name, institution, role ('researcher'|'admin'), query_count

JSONB access syntax: metadata->>'key' for text, (metadata->>'key')::int for integers.
"""

SQL_SYSTEM_PROMPT = f"""You are a SQL expert for a maritime history database.
Given a natural language question, generate a single PostgreSQL SELECT query.

{SCHEMA_DESCRIPTION}

Rules:
1. ONLY generate SELECT statements. Never INSERT, UPDATE, DELETE, DROP, ALTER, or TRUNCATE.
2. Use JSONB operators (->>, ->) to access metadata fields.
3. Cast numeric JSONB values: (metadata->>'tonnage')::numeric
4. Always LIMIT results to at most 50 rows unless the user asks for a count.
5. Use ILIKE for case-insensitive text matching.
6. Return ONLY the SQL query, no explanation, no markdown fences."""


# Dangerous SQL patterns
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
    """
    settings = get_settings()

    # Build postgres connection string from Supabase URL
    # Supabase URL: https://PROJECT.supabase.co
    # Postgres:     postgresql://postgres:PASSWORD@db.PROJECT.supabase.co:5432/postgres
    project_ref = settings.supabase_url.replace("https://", "").replace(".supabase.co", "")
    conn_string = (
        f"postgresql://postgres.{project_ref}:{settings.supabase_service_role_key}"
        f"@aws-0-us-east-1.pooler.supabase.com:6543/postgres"
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
