"""
Astoria v2 — Vector retrieval service.

Performs semantic search using the Supabase match_chunks() function
and the E5-large-v2 embedding model.
"""

import structlog

from app.core.supabase import get_supabase_admin
from app.services.embedding import embed_query
from app.models.schemas import SourceCitation

logger = structlog.get_logger()


def search_chunks(
    question: str,
    threshold: float = 0.5,
    limit: int = 10,
) -> list[SourceCitation]:
    """Semantic search: embed the question, call match_chunks(), return citations.

    Args:
        question: The user's natural language query.
        threshold: Minimum cosine similarity (0-1). Lower = more results.
        limit: Maximum number of chunks to return.

    Returns:
        List of SourceCitation objects with relevance scores.
    """
    # 1. Embed the question
    query_vector = embed_query(question)

    # 2. Call match_chunks() via Supabase RPC
    supabase = get_supabase_admin()

    result = supabase.rpc(
        "match_chunks",
        {
            "query_embedding": query_vector,
            "match_threshold": threshold,
            "match_count": limit,
        },
    ).execute()

    if not result.data:
        logger.info("no_chunks_found", question=question[:80], threshold=threshold)
        return []

    # 3. Fetch document metadata for each unique document_id
    doc_ids = list({chunk["document_id"] for chunk in result.data})
    docs_result = (
        supabase.table("documents")
        .select("id, title, source_url, archive_name")
        .in_("id", doc_ids)
        .execute()
    )
    doc_map = {doc["id"]: doc for doc in (docs_result.data or [])}

    # 4. Build SourceCitation objects
    citations = []
    for chunk in result.data:
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

    logger.info(
        "chunks_retrieved",
        question=question[:80],
        count=len(citations),
        top_score=citations[0].relevance_score if citations else 0,
    )
    return citations
