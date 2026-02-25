"""
Astoria v2 — Source document endpoints.

Browse ingested documents and their provenance.
"""

from fastapi import APIRouter, Depends, Query
from app.middleware.auth import AuthUser, get_current_user
from app.models.schemas import DocumentMeta

router = APIRouter(prefix="/sources", tags=["sources"])


@router.get("", response_model=list[DocumentMeta])
async def list_sources(
    archive: str | None = Query(None, description="Filter by archive name"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    user: AuthUser = Depends(get_current_user),
):
    """List all ingested source documents."""
    return []


@router.get("/{document_id}")
async def get_source(
    document_id: str,
    user: AuthUser = Depends(get_current_user),
):
    """Get detailed information about a source document, including its chunks."""
    return {"id": document_id, "message": "Phase 1 placeholder"}
