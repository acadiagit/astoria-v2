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


def _detect_person_query(question: str, supabase) -> str | None:
    """Check if the question is about a specific person (captain, owner, builder).

    Returns the matched person_name_normalized or None.
    """
    # Look for person-query patterns
    person_patterns = [
        r'(?:captain|master|capt\.?)\s+([A-Z][\w\.\s]+)',
        r'(?:builder|shipbuilder|carpenter)\s+([A-Z][\w\.\s]+)',
        r'(?:owner)\s+([A-Z][\w\.\s]+)',
        r'"([^"]+)"',
        r"'([^']+)'",
        # "all voyages of X", "career of X", "vessels of X"
        r'(?:voyages?|career|vessels?|ships?)\s+(?:of|for|by)\s+([A-Z][\w\.\s]+)',
    ]

    candidates = []
    for pat in person_patterns:
        matches = re.findall(pat, question, re.IGNORECASE)
        candidates.extend([m.strip().rstrip('.,;:?') for m in matches if len(m.strip()) > 3])

    if not candidates:
        return None

    # Check each candidate against person_roles
    for candidate in candidates:
        try:
            result = (
                supabase.table("person_roles")
                .select("person_name, person_name_normalized")
                .ilike("person_name_normalized", f"%{candidate.lower()}%")
                .limit(1)
                .execute()
            )
            if result.data:
                matched = result.data[0]["person_name_normalized"]
                logger.info("person_detected", candidate=candidate, matched=matched)
                return matched
        except Exception:
            pass

    return None


def _get_person_roles(person_name_norm: str, supabase) -> list[dict]:
    """Fetch all roles for a person from person_roles table."""
    try:
        result = (
            supabase.table("person_roles")
            .select("*")
            .ilike("person_name_normalized", f"%{person_name_norm}%")
            .order("first_date")
            .execute()
        )
        return result.data or []
    except Exception as e:
        logger.warning("person_roles_query_failed", error=str(e))
        return []


def _get_person_events(person_name_norm: str, supabase) -> list[dict]:
    """Fetch all vessel_events where this person was master."""
    try:
        result = (
            supabase.table("vessel_events")
            .select("*")
            .ilike("master", f"%{person_name_norm}%")
            .order("event_date")
            .execute()
        )
        return result.data or []
    except Exception as e:
        logger.warning("person_events_query_failed", error=str(e))
        return []


def _get_family_connections(last_name: str, supabase) -> list[dict]:
    """Fetch all person_roles sharing a last name (family network)."""
    try:
        result = (
            supabase.table("person_roles")
            .select("*")
            .eq("last_name", last_name)
            .order("first_date")
            .execute()
        )
        return result.data or []
    except Exception as e:
        logger.warning("family_query_failed", error=str(e))
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

    # 2. Check if the query references a specific person or vessel
    person_name = _detect_person_query(question, supabase)
    person_roles = []
    person_events = []

    if person_name:
        # Person-specific query: fetch their roles and events
        logger.info("person_search", person=person_name)
        person_roles = _get_person_roles(person_name, supabase)
        person_events = _get_person_events(person_name, supabase)

        # Also check for family connections
        family_members = []
        if person_roles:
            last_name = person_roles[0].get("last_name")
            if last_name:
                family_members = _get_family_connections(last_name, supabase)

        # Get chunks for all vessels this person was associated with
        vessel_names = list(set(r["vessel_name"] for r in person_roles))
        result_data = []
        for vn in vessel_names[:10]:  # limit to avoid too many queries
            try:
                vr = supabase.rpc(
                    "match_chunks_filtered",
                    {
                        "query_embedding": query_vector,
                        "filter_metadata": {"ship_name": vn},
                        "match_threshold": 0.2,
                        "match_count": 5,
                    },
                ).execute()
                if vr.data:
                    result_data.extend(vr.data)
            except Exception:
                pass

        # Deduplicate and sort
        seen_ids = set()
        unique_data = []
        for chunk in result_data:
            if chunk["id"] not in seen_ids:
                seen_ids.add(chunk["id"])
                unique_data.append(chunk)
        result_data = sorted(unique_data, key=lambda c: c["similarity"], reverse=True)[:20]
        events = []  # person queries use person_roles/events, not vessel_events directly

    vessel_name = None if person_name else _detect_vessel_name(question, supabase)

    if vessel_name:
        # Vessel-specific search: ONLY get chunks for this vessel (no generic search)
        # This prevents unrelated vessels from polluting results
        logger.info("filtered_search", vessel=vessel_name, limit=limit)

        # Get vessel-specific chunks
        filtered_result = supabase.rpc(
            "match_chunks_filtered",
            {
                "query_embedding": query_vector,
                "filter_metadata": {"ship_name": vessel_name},
                "match_threshold": 0.2,   # low threshold — we want ALL chunks for this vessel
                "match_count": 20,         # capture full history
            },
        ).execute()

        result_data = filtered_result.data or []

        # Sort by similarity
        result_data.sort(key=lambda c: c["similarity"], reverse=True)

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

    if not result_data and not events and not person_roles:
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
        # Resolve "(same as previous)" for master to show actual names
        last_master = None
        resolved_events = []
        for ev in events:
            master = ev.get('master')
            if master and master != '(same as previous)':
                last_master = master
            elif master == '(same as previous)' and last_master:
                master = last_master
            resolved_events.append({**ev, 'master': master})

        event_lines = [
            f"=== Chronological Event History for {vessel_name} ===",
            f"Total events: {len(resolved_events)}",
            "",
            "Date | Type | Port | From | Master",
            "--- | --- | --- | --- | ---",
        ]
        for ev in resolved_events:
            date = ev.get('event_date', '?') or '?'
            etype = ev.get('event_type', '?')
            port = ev.get('event_port', '?')
            prev = ev.get('previous_port') or ''
            master = ev.get('master') or ''
            event_lines.append(f"{date} | {etype} | {port} | {prev} | {master}")

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

    # 6. If this is a person query, build a person career citation
    if person_roles:
        display_name = person_roles[0]["person_name"]
        last_name = person_roles[0].get("last_name")

        # Group by role
        by_role = {}
        for pr in person_roles:
            role = pr["role"]
            if role not in by_role:
                by_role[role] = []
            by_role[role].append(pr)

        lines = [
            f"=== Career Profile: {display_name} ===",
            "",
        ]

        if "master" in by_role:
            lines.append(f"**Captain/Master** — commanded {len(by_role['master'])} vessel(s):")
            lines.append("Vessel | First Date | Last Date | Events")
            lines.append("--- | --- | --- | ---")
            for r in sorted(by_role["master"], key=lambda x: x.get("first_date") or ""):
                lines.append(f"{r['vessel_name']} | {r.get('first_date', '?')} | {r.get('last_date', '?')} | {r.get('event_count', 1)}")
            lines.append("")

        if "owner" in by_role:
            lines.append(f"**Owner** — held shares in {len(by_role['owner'])} vessel(s):")
            lines.append("Vessel | Share | Residence | First Date")
            lines.append("--- | --- | --- | ---")
            for r in sorted(by_role["owner"], key=lambda x: x.get("first_date") or ""):
                share = r.get("ownership_share") or "?"
                res = r.get("residence") or ""
                lines.append(f"{r['vessel_name']} | {share} | {res} | {r.get('first_date', '?')}")
            lines.append("")

        if "builder" in by_role:
            lines.append(f"**Builder** — constructed {len(by_role['builder'])} vessel(s):")
            for r in sorted(by_role["builder"], key=lambda x: x.get("first_date") or ""):
                res = r.get("residence") or ""
                lines.append(f"  - {r['vessel_name']} ({r.get('first_date', '?')[:4] if r.get('first_date') else '?'}) {res}")
            lines.append("")

        # Add family connections if applicable
        if family_members and len(family_members) > len(person_roles):
            other_family = [fm for fm in family_members
                          if fm["person_name_normalized"] != person_name]
            if other_family:
                family_names = set(fm["person_name"] for fm in other_family)
                lines.append(f"**{last_name} Family Network** — {len(family_names)} other family members in records:")
                for fname in sorted(family_names)[:15]:
                    member_roles = [fm for fm in other_family if fm["person_name"] == fname]
                    roles_str = ", ".join(set(fm["role"] for fm in member_roles))
                    vessels_str = ", ".join(set(fm["vessel_name"] for fm in member_roles))[:80]
                    lines.append(f"  - {fname} ({roles_str}): {vessels_str}")

        # Add captain's events timeline if they were a master
        if person_events:
            lines.append("")
            lines.append(f"**Voyage Timeline** ({len(person_events)} events):")
            lines.append("Date | Vessel | Type | Port | From")
            lines.append("--- | --- | --- | --- | ---")
            for ev in person_events:
                date = ev.get('event_date', '?') or '?'
                vessel = ev.get('vessel_name', '?')
                etype = ev.get('event_type', '?')
                port = ev.get('event_port', '?')
                prev = ev.get('previous_port') or ''
                lines.append(f"{date} | {vessel} | {etype} | {port} | {prev}")

        person_text = "\n".join(lines)
        citations.insert(0, SourceCitation(
            document_id=person_roles[0].get("document_id", ""),
            document_title=f"Career Profile: {display_name}",
            source_url=None,
            archive_name="Machias Ship Registers 1780-1930",
            chunk_text=person_text,
            relevance_score=0.99,
        ))

    logger.info(
        "chunks_retrieved",
        question=question[:80],
        count=len(citations),
        vessel_filter=vessel_name,
        person_filter=person_name,
        events_count=len(events),
        top_score=citations[0].relevance_score if citations else 0,
    )
    return citations
