"""
Astoria v2 — Vector retrieval service.

Performs semantic search using the Supabase match_chunks() and
match_chunks_filtered() functions with E5-large-v2 embeddings.

When a query references a specific vessel, uses metadata-filtered
search to retrieve ALL relevant chunks for that vessel, then
supplements with structured event data from vessel_events.
"""

import re
import structlog

from app.core.supabase import get_supabase_admin
from app.services.embedding import embed_query
from app.models.schemas import SourceCitation

logger = structlog.get_logger()


def _detect_vessel_name(question: str, supabase) -> str | None:
    """Check if the question references a specific vessel by name.

    Queries the documents table for ship_name metadata matches.
    Returns the matched vessel name or None.
    """
    # Extract potential vessel names — look for quoted names or capitalized multi-word names
    # Also check for patterns like "the schooner X" or "vessel X"
    patterns = [
        r'"([^"]+)"',                          # "Alaska"
        r"'([^']+)'",                           # 'Alaska'
        r'(?:schooner|brig|bark|sloop|ship|vessel|steamer)\s+([A-Z][\w\s\.\-]+)',  # schooner Alaska
    ]

    candidates = []
    for pat in patterns:
        matches = re.findall(pat, question, re.IGNORECASE)
        candidates.extend([m.strip() for m in matches if len(m.strip()) > 2])

    # Also try the whole question minus common words as a vessel search
    # (for queries like "Tell me about A. B. Perry")
    stop_words = {'what', 'which', 'where', 'when', 'who', 'how', 'show', 'tell',
                  'me', 'about', 'the', 'all', 'ports', 'did', 'visit', 'sailed',
                  'captain', 'master', 'owner', 'history', 'voyage', 'vessels',
                  'ships', 'of', 'and', 'in', 'to', 'from', 'a', 'an', 'for',
                  'was', 'were', 'is', 'are', 'has', 'had', 'do', 'does'}

    # Look for capitalized multi-word sequences that could be vessel names
    cap_pattern = re.findall(r'[A-Z][a-z]*(?:\.\s*)?(?:\s+[A-Z][a-z]*(?:\.\s*)?)*', question)
    for cp in cap_pattern:
        cp = cp.strip()
        if len(cp) > 2 and cp.lower() not in stop_words:
            candidates.append(cp)

    if not candidates:
        return None

    # Check each candidate against the database
    for candidate in candidates:
        result = (
            supabase.table("documents")
            .select("metadata->ship_name")
            .ilike("metadata->>ship_name", f"%{candidate}%")
            .limit(1)
            .execute()
        )
        if result.data:
            ship_name = result.data[0].get("ship_name")
            if ship_name:
                logger.info("vessel_detected", candidate=candidate, matched=ship_name)
                return ship_name

    return None


def _get_vessel_events(vessel_name: str, supabase) -> list[dict]:
    """Fetch structured events for a vessel from the vessel_events table."""
    try:
        result = (
            supabase.table("vessel_events")
            .select("*")
            .ilike("vessel_name", f"%{vessel_name}%")
            .order("event_date")
            .execute()
        )
        return result.data or []
    except Exception as e:
        logger.warning("vessel_events_query_failed", error=str(e))
        return []


def search_chunks(
    question: str,
    threshold: float = 0.5,
    limit: int = 10,
) -> list[SourceCitation]:
    """Semantic search with optional vessel-aware filtering.

    If the query references a specific vessel:
      1. Uses match_chunks_filtered() to get chunks for that vessel
      2. Also fetches structured events from vessel_events table
      3. Appends event timeline as an extra citation

    Otherwise: standard semantic search via match_chunks().

    Args:
        question: The user's natural language query.
        threshold: Minimum cosine similarity (0-1). Lower = more results.
        limit: Maximum number of chunks to return.

    Returns:
        List of SourceCitation objects with relevance scores.
    """
    supabase = get_supabase_admin()

    # 1. Embed the question
    query_vector = embed_query(question)

    # 2. Check if the query references a specific vessel
    vessel_name = _detect_vessel_name(question, supabase)

    if vessel_name:
        # Filtered search: get ALL chunks for this vessel + standard search
        logger.info("filtered_search", vessel=vessel_name, limit=limit)

        # Get vessel-specific chunks (higher limit to capture full history)
        filtered_result = supabase.rpc(
            "match_chunks_filtered",
            {
                "query_embedding": query_vector,
                "filter_metadata": {"ship_name": vessel_name},
                "match_threshold": 0.3,   # lower threshold for vessel-specific
                "match_count": 20,         # more chunks for full history
            },
        ).execute()

        # Also get standard semantic results (may include related vessels)
        standard_result = supabase.rpc(
            "match_chunks",
            {
                "query_embedding": query_vector,
                "match_threshold": threshold,
                "match_count": limit,
            },
        ).execute()

        # Merge results, deduplicating by chunk ID
        seen_ids = set()
        all_chunks = []
        for chunk in (filtered_result.data or []):
            if chunk["id"] not in seen_ids:
                seen_ids.add(chunk["id"])
                all_chunks.append(chunk)
        for chunk in (standard_result.data or []):
            if chunk["id"] not in seen_ids:
                seen_ids.add(chunk["id"])
                all_chunks.append(chunk)

        # Sort by similarity
        all_chunks.sort(key=lambda c: c["similarity"], reverse=True)
        result_data = all_chunks

        # Fetch structured events
        events = _get_vessel_events(vessel_name, supabase)
    else:
        # Standard semantic search
        result = supabase.rpc(
            "match_chunks",
            {
                "query_embedding": query_vector,
                "match_threshold": threshold,
                "match_count": limit,
            },
        ).execute()
        result_data = result.data or []
        events = []

    if not result_data and not events:
        logger.info("no_chunks_found", question=question[:80], threshold=threshold)
        return []

    # 3. Fetch document metadata for each unique document_id
    doc_ids = list({chunk["document_id"] for chunk in result_data})
    if doc_ids:
        docs_result = (
            supabase.table("documents")
            .select("id, title, source_url, archive_name")
            .in_("id", doc_ids)
            .execute()
        )
        doc_map = {doc["id"]: doc for doc in (docs_result.data or [])}
    else:
        doc_map = {}

    # 4. Build SourceCitation objects
    citations = []
    for chunk in result_data:
        doc = doc_map.get(chunk["document_id"], {})
        citations.append(
            SourceCitation(
                document_id=chunk["document_id"],
                document_title=doc.get("title", "Unknown"),
                source_url=doc.get("source_url"),
                archive_name=doc.get("archive_name"),
                chunk_text=chunk["content"],
                relevance_score=round(chunk["similarity"], 4),
            )
        )

    # 5. If we have structured events, append them as a synthetic citation
    if events:
        event_lines = [f"=== Structured Events for {vessel_name} ==="]
        for ev in events:
            line = f"  {ev.get('event_date', '?')} | {ev['event_type']} at {ev.get('event_port', '?')}"
            if ev.get('previous_port'):
                line += f" (from {ev['previous_port']})"
            if ev.get('master') and ev['master'] != '(same as previous)':
                line += f" | Master: {ev['master']}"
            if ev.get('owners_text') and ev['owners_text'] != '(same as previous)':
                owners_short = ev['owners_text'][:100]
                line += f" | Owners: {owners_short}"
            if ev.get('notes'):
                line += f" | Notes: {ev['notes']}"
            event_lines.append(line)

        event_text = "\n".join(event_lines)

        # Add as a high-relevance synthetic citation
        citations.insert(0, SourceCitation(
            document_id=events[0].get("document_id", ""),
            document_title=f"Structured Events: {vessel_name}",
            source_url=None,
            archive_name="Machias Ship Registers 1780-1930",
            chunk_text=event_text,
            relevance_score=0.99,  # ensure it's at the top
        ))

    logger.info(
        "chunks_retrieved",
        question=question[:80],
        count=len(citations),
        vessel_filter=vessel_name,
        events_count=len(events),
        top_score=citations[0].relevance_score if citations else 0,
    )
    return citations
