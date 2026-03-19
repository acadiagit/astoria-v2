"""
# File: backend/app/services/loader_agent.py
# Astoria v2 — Document loader agent.
# Orchestrates parse -> chunk -> embed -> store pipeline.
# All config sourced from app.core.config (get_settings).
"""

import uuid
import structlog
from app.core.config import get_settings
from app.services.document_parser import parse_document
from app.services.embedding import embed_passages
from supabase import create_client

logger = structlog.get_logger()

CHUNK_SIZE = 500      # words per chunk
CHUNK_OVERLAP = 50    # word overlap between chunks


def _chunk_text(text: str) -> list[str]:
    """Split text into overlapping word-based chunks."""
    words = text.split()
    chunks = []
    start = 0
    while start < len(words):
        end = min(start + CHUNK_SIZE, len(words))
        chunk = " ".join(words[start:end])
        if chunk.strip():
            chunks.append(chunk)
        start += CHUNK_SIZE - CHUNK_OVERLAP
    return chunks


def _get_supabase():
    """Get Supabase client using settings."""
    settings = get_settings()
    return create_client(settings.supabase_url, settings.supabase_service_role_key)


def load_document(
    source: str,
    town: str = None,
    archive_name: str = None,
    loaded_by: str = None,
) -> dict:
    """
    Full pipeline: parse -> chunk -> embed -> store.

    Args:
        source:       file path or URL
        town:         Blue Hill | Sullivan | Milbridge | Machias
        archive_name: e.g. 'Maine Memory Network'
        loaded_by:    admin user UUID

    Returns:
        dict with document_id, chunks_created, status
    """
    settings = get_settings()
    schema = settings.db_schema
    supabase = _get_supabase()

    # --- Step 1: Parse ---
    logger.info("loader_parsing", source=source)
    parsed = parse_document(source)
    content = parsed["content"]

    if not content.strip():
        return {"status": "error", "message": "No content extracted"}

    # --- Step 2: Deduplication check ---
    existing = supabase.schema(schema).table("documents") \
        .select("id") \
        .eq("checksum", parsed["checksum"]) \
        .execute()

    if existing.data:
        doc_id = existing.data[0]["id"]
        logger.info("loader_duplicate_skipped", doc_id=doc_id)
        return {"status": "duplicate", "document_id": doc_id, "chunks_created": 0}

    # --- Step 3: Store document metadata ---
    doc_record = {
        "id": str(uuid.uuid4()),
        "title": parsed["title"],
        "source_url": parsed.get("source_url"),
        "archive_name": archive_name,
        "content_type": parsed["content_type"],
        "raw_content": content,
        "checksum": parsed["checksum"],
        "metadata": {"town": town} if town else {},
        "ingested_by": loaded_by,
    }

    result = supabase.schema(schema).table("documents").insert(doc_record).execute()
    doc_id = result.data[0]["id"]
    logger.info("loader_document_stored", doc_id=doc_id, title=parsed["title"])

    # --- Step 4: Chunk ---
    chunks = _chunk_text(content)
    logger.info("loader_chunked", doc_id=doc_id, chunk_count=len(chunks))

    # --- Step 5: Embed ---
    embeddings = embed_passages(chunks)

    # --- Step 6: Store chunks ---
    chunk_records = [
        {
            "document_id": doc_id,
            "chunk_index": i,
            "content": chunk,
            "embedding": embedding,
            "metadata": {"town": town} if town else {},
            "token_count": len(chunk.split()),
        }
        for i, (chunk, embedding) in enumerate(zip(chunks, embeddings))
    ]

    supabase.schema(schema).table("document_chunks").insert(chunk_records).execute()
    logger.info("loader_complete", doc_id=doc_id, chunks_created=len(chunks))

    return {
        "status": "success",
        "document_id": doc_id,
        "title": parsed["title"],
        "chunks_created": len(chunks),
    }
# end loader_agent.py
