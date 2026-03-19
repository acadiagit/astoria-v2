"""
# File: backend/app/api/ingest.py
# Astoria v2 — Data ingestion endpoints (admin only).
# Handles file upload, URL ingestion, and town web scraping.
# All config sourced from app.core.config (get_settings).
"""

import uuid
import tempfile
import os
from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException
from app.middleware.auth import AuthUser, require_admin
from app.models.schemas import IngestionResult, IngestionStatus
from app.services.loader_agent import load_document
from app.services.web_scraper import scrape_town, scrape_all_towns
from app.core.config import get_settings
from datetime import datetime, timezone
import structlog

logger = structlog.get_logger()
router = APIRouter(prefix="/ingest", tags=["ingest"])

ALLOWED_TOWNS = ["Blue Hill", "Sullivan", "Milbridge", "Machias"]
ALLOWED_EXTENSIONS = {".pdf", ".txt", ".docx"}


@router.post("/upload")
async def upload_document(
    file: UploadFile = File(...),
    town: str = Form(None),
    archive_name: str = Form(None),
    user: AuthUser = Depends(require_admin),
):
    """Upload a PDF, TXT, or DOCX file into the knowledge base."""
    suffix = os.path.splitext(file.filename)[1].lower()
    if suffix not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=400,
            detail=f"Unsupported file type: {suffix}. Allowed: {ALLOWED_EXTENSIONS}"
        )

    if town and town not in ALLOWED_TOWNS:
        raise HTTPException(
            status_code=400,
            detail=f"Unknown town: {town}. Allowed: {ALLOWED_TOWNS}"
        )

    # Write upload to temp file
    with tempfile.NamedTemporaryFile(
        suffix=suffix,
        delete=False
    ) as tmp:
        content = await file.read()
        tmp.write(content)
        tmp_path = tmp.name

    try:
        result = load_document(
            source=tmp_path,
            town=town,
            archive_name=archive_name or "Manual Upload",
            loaded_by=user.id,
        )
    finally:
        os.unlink(tmp_path)

    logger.info("upload_complete", filename=file.filename, result=result)
    return result


@router.post("/url")
async def ingest_url(
    url: str = Form(...),
    town: str = Form(None),
    archive_name: str = Form(None),
    user: AuthUser = Depends(require_admin),
):
    """Ingest content from a URL into the knowledge base."""
    if not url.startswith("http"):
        raise HTTPException(status_code=400, detail="Invalid URL")

    result = load_document(
        source=url,
        town=town,
        archive_name=archive_name or "Web",
        loaded_by=user.id,
    )
    logger.info("url_ingest_complete", url=url, result=result)
    return result


@router.post("/scrape/{town}")
async def scrape_town_endpoint(
    town: str,
    user: AuthUser = Depends(require_admin),
):
    """Scrape all known sources for a specific town."""
    if town not in ALLOWED_TOWNS:
        raise HTTPException(
            status_code=400,
            detail=f"Unknown town: {town}. Allowed: {ALLOWED_TOWNS}"
        )

    result = scrape_town(town, loaded_by=user.id)
    logger.info("town_scrape_complete", town=town, result=result)
    return result


@router.post("/scrape-all")
async def scrape_all_endpoint(
    user: AuthUser = Depends(require_admin),
):
    """Scrape all four Maine towns."""
    result = scrape_all_towns(loaded_by=user.id)
    logger.info("all_towns_scraped", result=result)
    return result


@router.get("/sources")
async def list_sources(
    user: AuthUser = Depends(require_admin),
):
    """List all ingested documents."""
    from supabase import create_client
    settings = get_settings()
    supabase = create_client(settings.supabase_url, settings.supabase_service_role_key)
    result = supabase.schema(settings.db_schema).table("documents") \
        .select("id, title, archive_name, content_type, ingested_at, metadata") \
        .order("ingested_at", desc=True) \
        .execute()
    return {"documents": result.data, "total": len(result.data)}
# end ingest.py
