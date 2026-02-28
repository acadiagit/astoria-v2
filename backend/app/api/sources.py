"""
Astoria v2 — Source document endpoints.

Browse ingested documents and their provenance.
"""

from fastapi import APIRouter, Depends, Query, HTTPException
from app.middleware.auth import AuthUser, get_current_user
from app.models.schemas import DocumentMeta
from app.core.supabase import get_supabase_admin

router = APIRouter(prefix="/sources", tags=["sources"])


@router.get("", response_model=list[DocumentMeta])
async def list_sources(
    archive: str | None = Query(None, description="Filter by archive name"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    user: AuthUser = Depends(get_current_user),
):
    """List all ingested source documents."""
    supabase = get_supabase_admin()

    query_builder = (
        supabase.table("documents")
        .select("id, title, source_url, archive_name, ingested_at, checksum")
        .order("ingested_at", desc=True)
        .range(offset, offset + limit - 1)
    )

    if archive:
        query_builder = query_builder.eq("archive_name", archive)

    result = query_builder.execute()

    sources = []
    for doc in (result.data or []):
        # Get chunk count for this document
        chunk_result = (
            supabase.table("document_chunks")
            .select("id", count="exact")
            .eq("document_id", doc["id"])
            .execute()
        )
        chunk_count = chunk_result.count if chunk_result.count is not None else 0

        sources.append(DocumentMeta(
            id=doc["id"],
            title=doc["title"],
            source_url=doc.get("source_url"),
            archive_name=doc.get("archive_name"),
            ingested_at=doc["ingested_at"],
            chunk_count=chunk_count,
            checksum=doc["checksum"],
        ))

    return sources


@router.get("/{document_id}")
async def get_source(
    document_id: str,
    user: AuthUser = Depends(get_current_user),
):
    """Get detailed information about a source document, including its chunks."""
    supabase = get_supabase_admin()

    # Get document
    doc_result = (
        supabase.table("documents")
        .select("*")
        .eq("id", document_id)
        .single()
        .execute()
    )

    if not doc_result.data:
        raise HTTPException(status_code=404, detail="Document not found")

    # Get chunks (without embeddings — they're too large to return)
    chunks_result = (
        supabase.table("document_chunks")
        .select("id, chunk_index, content, metadata, token_count, created_at")
        .eq("document_id", document_id)
        .order("chunk_index")
        .execute()
    )

    return {
        **doc_result.data,
        "chunks": chunks_result.data or [],
    }
