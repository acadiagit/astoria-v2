"""
Astoria v2 — Query endpoints.

Main entry point for natural language queries against the maritime database.
Full RAG pipeline: classify → embed → retrieve → (optional SQL) → synthesize.
"""

import time
import structlog

from fastapi import APIRouter, Depends, HTTPException, status
from app.middleware.auth import AuthUser, get_current_user
from app.models.schemas import (
    QueryRequest,
    QueryResponse,
    QueryComplexity,
    SourceCitation,
)
from app.services.llm_router import classify_query, generate_answer
from app.services.retrieval import search_chunks
from app.services.nl2sql import generate_sql, execute_sql
from app.services.embedding import is_loaded as embedding_loaded
from app.core.supabase import get_supabase_admin

logger = structlog.get_logger()

router = APIRouter(prefix="/query", tags=["query"])


# ── Prompt Templates ──────────────────────────────────────────

SYNTHESIS_SYSTEM = """You are Astoria, a maritime history research assistant
specializing in New England maritime records, particularly the Machias Customs
District of Maine (1780-1930).

You answer questions about historical ships, voyages, ports, crew, cargo, and
shipbuilding using the provided context from a curated maritime database.

Rules:
1. Base your answer ONLY on the provided context. If the context doesn't
   contain enough information, say so honestly.
2. Cite your sources by referencing document titles in [brackets].
3. Be precise with dates, numbers, and proper nouns.
4. Use **Markdown formatting** to make your response readable and engaging:
   - Use **bold** for vessel names, place names, and key figures
   - Use tables (Markdown pipe syntax) when presenting structured data like
     lists of vessels, tonnage comparisons, or builder rankings
   - Use numbered or bulleted lists when enumerating items
   - Use headings (##) to organize longer responses into sections
5. If SQL results are provided, present them in a clean Markdown table when
   there are multiple rows, and incorporate narrative context around the table.
6. CRITICAL FORMATTING RULE — You MUST structure every response in two parts:
   PART 1: A concise 2-3 sentence summary that directly answers the question.
   Then you MUST output a line containing only "---" (three hyphens, nothing else).
   PART 2: The detailed analysis with tables, lists, and citations.
   Example structure:
   The Machias district produced 45 schooners between 1800 and 1850. **Addison** was the most prolific port with 18 vessels.
   ---
   ## Detailed Breakdown
   | Port | Vessels | Avg Tonnage |
   ...
7. If asked about topics outside New England maritime history, politely note
   that your expertise is focused on New England maritime records and redirect
   to what you can help with.

Maritime Domain Knowledge:
- "Enrolled" means the vessel was documented for domestic/coastal trade (cabotage).
  "Registered" means documented for foreign/international voyages.
- When "Structured Events" data is provided, build a CHRONOLOGICAL TIMELINE showing
  the vessel's history. Present events as a table with Date, Event Type, Port, and Master.
- When "previous_port" data exists, this means the vessel DEPARTED from that port and
  ARRIVED at the event_port. Describe these as voyage legs: "sailed from [previous_port]
  to [event_port]".
- When you see ownership data, look for FAMILY NETWORKS: owners sharing last names
  often indicate family business connections. Note these patterns explicitly.
- When you see "master" (captain) data across multiple vessels, this traces a CAREER —
  note which vessels a captain commanded and when they moved between ships.
- Fractional ownership (e.g., "4/64 shares") represents the vessel ownership system
  where ships were divided into shares (commonly 1/16, 1/32, or 1/64 divisions).
- "(same as previous)" for master or owners means the same person/group continued
  from the prior enrollment — do not list these as separate entries, just note continuity.
- When "Career Profile" data is provided, build a comprehensive BIOGRAPHY of the person:
  present their roles chronologically, note which vessels they captained/owned/built,
  identify family connections, and describe their career arc across the maritime industry.
- For FAMILY QUERIES (same last name), highlight the network: who was captain, who was
  owner, who was builder, which vessels they shared, and what time period they were active.
- When presenting person data, always use a table format for clarity."""

SYNTHESIS_USER = """Question: {question}

{context_section}

{sql_section}

Please provide a well-sourced answer to the question above."""


def _build_context_section(sources: list[SourceCitation]) -> str:
    """Format retrieved chunks into a context block for the LLM."""
    if not sources:
        return "Retrieved Context: No relevant documents found."

    parts = ["Retrieved Context:"]
    for i, src in enumerate(sources, 1):
        parts.append(
            f"\n[{i}] Document: {src.document_title} "
            f"(relevance: {src.relevance_score:.2f})\n"
            f"{src.chunk_text}"
        )
    return "\n".join(parts)


def _build_sql_section(sql: str | None, rows: list[dict] | None) -> str:
    """Format SQL results into a data block for the LLM."""
    if not sql or not rows:
        return "SQL Data: No SQL query was generated."

    display_rows = rows[:20]
    if not display_rows:
        return f"SQL Query: {sql}\nSQL Data: Query returned no results."

    header = " | ".join(display_rows[0].keys())
    lines = [f"SQL Query: {sql}", f"SQL Results ({len(rows)} rows):", header]
    lines.append("-" * len(header))
    for row in display_rows:
        lines.append(" | ".join(str(v) for v in row.values()))
    if len(rows) > 20:
        lines.append(f"... and {len(rows) - 20} more rows")

    return "\n".join(lines)


def _log_query(
    user: AuthUser,
    question: str,
    complexity: QueryComplexity,
    model_used: str,
    sql: str | None,
    answer: str,
    sources: list[SourceCitation],
    processing_ms: int,
) -> None:
    """Log the query to the query_log table for analytics."""
    try:
        supabase = get_supabase_admin()
        supabase.table("query_log").insert({
            "user_id": user.id,
            "question": question,
            "complexity": complexity.value,
            "model_used": model_used,
            "sql_generated": sql,
            "answer": answer[:5000],
            "sources_used": [s.document_id for s in sources],
            "processing_ms": processing_ms,
        }).execute()
    except Exception as e:
        logger.warning("query_log_failed", error=str(e))


@router.post("", response_model=QueryResponse)
async def submit_query(
    request: QueryRequest,
    user: AuthUser = Depends(get_current_user),
):
    """Submit a natural language query about maritime history.

    Pipeline:
    1. Classify query complexity (SIMPLE / COMPLEX / RESEARCH)
    2. Retrieve relevant document chunks via semantic search
    3. Generate + execute SQL if applicable (SIMPLE queries)
    4. Synthesize narrative answer via routed LLM
    5. Return answer with sources and metadata
    """
    start = time.time()

    if not embedding_loaded():
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Embedding model is still loading. Please try again in a moment.",
        )

    # 1. Classify complexity
    complexity = classify_query(request.question)
    logger.info("query_classified", question=request.question[:80], complexity=complexity.value)

    # 2. Semantic search — retrieve relevant chunks
    sources = search_chunks(request.question, threshold=0.5, limit=8)

    # 3. Optional SQL generation + execution (for SIMPLE queries)
    sql_query = None
    sql_rows = None
    if complexity in (QueryComplexity.SIMPLE, QueryComplexity.COMPLEX) or request.include_sql:
        sql_query = generate_sql(request.question)
        if sql_query:
            try:
                sql_rows, _ = execute_sql(sql_query)
            except Exception as e:
                logger.warning("sql_exec_failed", error=str(e))
                sql_rows = None

    # 4. Build prompt and synthesize answer
    context_section = _build_context_section(sources)
    sql_section = _build_sql_section(sql_query, sql_rows)

    user_prompt = SYNTHESIS_USER.format(
        question=request.question,
        context_section=context_section,
        sql_section=sql_section,
    )

    answer, model_used = generate_answer(complexity, SYNTHESIS_SYSTEM, user_prompt)

    # 5. Build response
    elapsed_ms = int((time.time() - start) * 1000)

    response = QueryResponse(
        answer=answer,
        sql_generated=sql_query if request.include_sql else None,
        data_preview=sql_rows[:10] if sql_rows else None,
        sources=sources if request.include_sources else [],
        complexity=complexity,
        model_used=model_used,
        processing_time_ms=elapsed_ms,
    )

    # 6. Log for analytics (non-blocking)
    _log_query(
        user=user,
        question=request.question,
        complexity=complexity,
        model_used=model_used,
        sql=sql_query,
        answer=answer,
        sources=sources,
        processing_ms=elapsed_ms,
    )

    logger.info(
        "query_completed",
        complexity=complexity.value,
        model=model_used,
        sources=len(sources),
        has_sql=sql_query is not None,
        elapsed_ms=elapsed_ms,
    )

    return response


# ── Demo / Test endpoint (no auth) ────────────────────────────

@router.post("/test", response_model=QueryResponse)
async def test_query(request: QueryRequest):
    """Unauthenticated test endpoint for demo purposes.

    Same pipeline as the main query endpoint, but no JWT required.
    Remove this endpoint before production launch.
    """
    start = time.time()

    if not embedding_loaded():
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Embedding model is still loading. Please try again in a moment.",
        )

    complexity = classify_query(request.question)
    logger.info("test_query", question=request.question[:80], complexity=complexity.value)

    sources = search_chunks(request.question, threshold=0.4, limit=8)

    sql_query = None
    sql_rows = None
    if complexity in (QueryComplexity.SIMPLE, QueryComplexity.COMPLEX) or request.include_sql:
        sql_query = generate_sql(request.question)
        if sql_query:
            try:
                sql_rows, _ = execute_sql(sql_query)
            except Exception as e:
                logger.warning("sql_exec_failed", error=str(e))

    context_section = _build_context_section(sources)
    sql_section = _build_sql_section(sql_query, sql_rows)

    user_prompt = SYNTHESIS_USER.format(
        question=request.question,
        context_section=context_section,
        sql_section=sql_section,
    )

    answer, model_used = generate_answer(complexity, SYNTHESIS_SYSTEM, user_prompt)

    elapsed_ms = int((time.time() - start) * 1000)

    return QueryResponse(
        answer=answer,
        sql_generated=sql_query if request.include_sql else None,
        data_preview=sql_rows[:10] if sql_rows else None,
        sources=sources if request.include_sources else [],
        complexity=complexity,
        model_used=model_used,
        processing_time_ms=elapsed_ms,
    )
