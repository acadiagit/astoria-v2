#!/usr/bin/env python3
"""
# File: backend/scripts/seed_embeddings.py
# Astoria v2 — Seed Embeddings Script
#
# Reads all documents from Supabase, chunks their raw_content,
# generates embeddings using E5-large-v2, and inserts into document_chunks.
#
# KEY BEHAVIOR:
#   - ALWAYS skips documents that already have embeddings — safe to re-run anytime
#   - Processes documents in alphabetical order by title
#   - Reports skipped, processed, and errored counts at the end
#
# Usage:
#   From project root:
#     sudo docker compose exec backend python -m scripts.seed_embeddings
#
#   If interrupted, just re-run — already embedded docs are skipped automatically.
#
# Environment (from .env — single source of truth):
#   SUPABASE_URL              — Supabase project URL
#   SUPABASE_SERVICE_ROLE_KEY — Supabase service role key (admin access)
#   EMBEDDING_MODEL           — defaults to intfloat/e5-large-v2
#   DB_SCHEMA                 — defaults to public
#
# Architecture Decision:
#   Option A (chosen): Embeddings generated inside Docker container.
#   Reason: E5-large-v2 model already loaded at startup, no extra
#   infrastructure needed, consistent results, free to run.
#   Option B (future): Direct psycopg2 + pgvector outside Docker.
#   Consider when: embedding volume exceeds 100k chunks or GPU needed.
#
# end of header
"""

import os
import sys

# Add backend directory to path so we can import app modules
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dotenv import load_dotenv
load_dotenv()

from supabase import create_client
from sentence_transformers import SentenceTransformer

# ── Configuration from .env ────────────────────────────────────

EMBEDDING_MODEL = os.getenv("EMBEDDING_MODEL", "intfloat/e5-large-v2")
DB_SCHEMA       = os.getenv("DB_SCHEMA", "public")
CHUNK_SIZE      = 500   # target characters per chunk
CHUNK_OVERLAP   = 50    # overlap between consecutive chunks
SUPABASE_URL    = os.getenv("SUPABASE_URL")
SUPABASE_KEY    = os.getenv("SUPABASE_SERVICE_ROLE_KEY")


def get_supabase():
    """Create Supabase admin client using settings from .env."""
    if not SUPABASE_URL or not SUPABASE_KEY:
        print("ERROR: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set in .env")
        sys.exit(1)
    return create_client(SUPABASE_URL, SUPABASE_KEY)


def chunk_text(text: str, chunk_size: int = CHUNK_SIZE, overlap: int = CHUNK_OVERLAP) -> list[str]:
    """Split text into overlapping chunks at sentence boundaries.

    Tries to split at periods/newlines to keep sentences intact.
    Falls back to character splitting if sentences are too long.
    """
    if not text or len(text) <= chunk_size:
        return [text] if text else []

    chunks = []
    start = 0

    while start < len(text):
        end = start + chunk_size

        if end >= len(text):
            chunks.append(text[start:].strip())
            break

        best_break = -1
        for sep in ['. ', '.\n', '\n\n', '\n', '; ', ', ']:
            pos = text.rfind(sep, start + chunk_size // 2, end + 50)
            if pos > start:
                best_break = pos + len(sep)
                break

        if best_break > start:
            chunks.append(text[start:best_break].strip())
            start = best_break - overlap
        else:
            chunks.append(text[start:end].strip())
            start = end - overlap

    return [c for c in chunks if c]


def count_tokens_approx(text: str) -> int:
    """Rough token count (words * 1.3)."""
    return int(len(text.split()) * 1.3)


def main():
    print(f"=== Astoria v2 — Seed Embeddings ===")
    print(f"Model:  {EMBEDDING_MODEL}")
    print(f"Schema: {DB_SCHEMA}")
    print(f"Mode:   SKIP already embedded documents (safe to re-run)")
    print()

    # 1. Load embedding model
    print("Loading embedding model...")
    model = SentenceTransformer(EMBEDDING_MODEL)
    print(f"  Model loaded. Dimension: {model.get_embedding_dimension()}")

    # 2. Connect to Supabase
    supabase = get_supabase()
    print("Connected to Supabase.")

    # 3. Fetch all documents
    result = supabase.schema(DB_SCHEMA).table("documents") \
        .select("id, title, raw_content, metadata") \
        .execute()
    documents = result.data or []
    print(f"Found {len(documents)} documents.")

    if not documents:
        print("No documents to process. Run seed_vessels.py first.")
        return

    # 4. Sort alphabetically for predictable order
    documents.sort(key=lambda d: d.get("title", ""))

    # 5. Build set of already-embedded document IDs — never re-embed these
    existing = supabase.schema(DB_SCHEMA).table("document_chunks") \
        .select("document_id") \
        .execute()
    already_done = set(r["document_id"] for r in (existing.data or []))
    print(f"Already embedded: {len(already_done)} documents — skipping these")
    print(f"Remaining:        {len(documents) - len(already_done)} documents to embed")
    print()

    # 6. Process each document — skip if already embedded
    total_chunks   = 0
    total_embedded = 0
    total_skipped  = 0
    total_errors   = 0

    for doc in documents:
        doc_id = doc["id"]
        title  = doc["title"]
        raw    = doc.get("raw_content", "")

        # Skip if already embedded
        if doc_id in already_done:
            total_skipped += 1
            continue

        # Skip if no content
        if not raw:
            print(f"  SKIP {title}: no raw_content")
            total_skipped += 1
            continue

        # Chunk the document
        chunks = chunk_text(raw)
        print(f"  {title}: {len(chunks)} chunks")

        try:
            # E5 requires "passage: " prefix for documents being indexed
            prefixed   = [f"passage: {c}" for c in chunks]
            embeddings = model.encode(
                prefixed,
                normalize_embeddings=True,
                show_progress_bar=False
            )

            # Build chunk rows
            rows = []
            for i, (chunk_text_val, embedding) in enumerate(zip(chunks, embeddings)):
                rows.append({
                    "document_id": doc_id,
                    "chunk_index": i,
                    "content":     chunk_text_val,
                    "embedding":   embedding.tolist(),
                    "metadata":    doc.get("metadata", {}),
                    "token_count": count_tokens_approx(chunk_text_val),
                })

            # Insert in batches of 20 (Supabase request size limit)
            for batch_start in range(0, len(rows), 20):
                batch = rows[batch_start:batch_start + 20]
                supabase.schema(DB_SCHEMA).table("document_chunks") \
                    .insert(batch) \
                    .execute()

            total_chunks   += len(chunks)
            total_embedded += 1

        except Exception as e:
            print(f"  ERROR on {title}: {e}")
            total_errors += 1
            continue

    # 7. Final report
    print()
    print(f"=== Done ===")
    print(f"Documents embedded:   {total_embedded}")
    print(f"Documents skipped:    {total_skipped}")
    print(f"Documents errored:    {total_errors}")
    print(f"Total chunks created: {total_chunks}")
    print()
    print(f"Verify in Supabase SQL Editor:")
    print(f"  SELECT COUNT(*) FROM {DB_SCHEMA}.document_chunks;")


if __name__ == "__main__":
    main()
# end of file seed_embeddings.py
