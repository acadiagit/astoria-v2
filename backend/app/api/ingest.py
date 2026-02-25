"""
Astoria v2 — Data ingestion endpoints (admin only).

Trigger scraping, validation, and embedding of maritime data sources.
"""

from fastapi import APIRouter, Depends
from app.middleware.auth import AuthUser, require_admin
from app.models.schemas import IngestionTrigger, IngestionResult, IngestionStatus
from datetime import datetime, timezone

router = APIRouter(prefix="/ingest", tags=["ingest"])


@router.post("/trigger", response_model=IngestionResult)
async def trigger_ingestion(
    request: IngestionTrigger,
    user: AuthUser = Depends(require_admin),
):
    """Trigger a data ingestion run for a specific source.

    Admin only. Starts the scrape → validate → chunk → embed pipeline.
    """
    # Phase 1 placeholder — Phase 3 connects the actual pipeline
    return IngestionResult(
        run_id="placeholder-run-001",
        source_id=request.source_id,
        status=IngestionStatus.PENDING,
        started_at=datetime.now(timezone.utc),
    )


@router.get("/status/{run_id}", response_model=IngestionResult)
async def get_ingestion_status(
    run_id: str,
    user: AuthUser = Depends(require_admin),
):
    """Check the status of an ingestion run."""
    return IngestionResult(
        run_id=run_id,
        source_id="unknown",
        status=IngestionStatus.PENDING,
        started_at=datetime.now(timezone.utc),
    )


@router.get("/sources")
async def list_available_sources(
    user: AuthUser = Depends(require_admin),
):
    """List all configured data sources and their last ingestion status."""
    # Phase 3 will populate this from scraper configurations
    return {
        "sources": [
            {
                "id": "example-archive",
                "name": "Example Maritime Archive",
                "url": "https://example.com",
                "last_run": None,
                "status": "not_configured",
            }
        ]
    }
