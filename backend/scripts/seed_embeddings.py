#!/usr/bin/env python3
"""
Astoria v2 — Seed Embeddings Script

Reads all documents from Supabase, chunks their raw_content,
generates embeddings using E5-large-v2, and upserts into document_chunks.

Usage:
    cd backend
    python -m scripts.seed_embeddings

    Or from project root:
    cd backend && python scripts/seed_embeddings.py

Environment:
    Requires .env file with SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, etc.
"""

import os
import sys
import hashlib
import textwrap

# Add backend directory to path so we can import app modules
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dotenv import load_dotenv
load_dotenv()

from supabase import create_client
from sentence_transformers import SentenceTransformer

# ── Configuration ──────────────────────────────────────────────

EMBEDDING_MODEL = os.getenv("EMBEDDING_MODEL", "intfloat/e5-large-v2")
CHUNK_SIZE = 500       # target characters per chunk
CHUNK_OVERLAP = 50     # overlap between consecutive chunks
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")


def get_supabase():
    """Create Supabase admin client."""
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

        # Try to find a sentence boundary (period, newline) near the chunk end
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
            # No good break found — hard split
            chunks.append(text[start:end].strip())
            start = end - overlap

    return [c for c in chunks if c]


def count_tokens_approx(text: str) -> int:
    """Rough token count (words * 1.3)."""
    return int(len(text.split()) * 1.3)


def main():
    print(f"=== Astoria v2 — Seed Embeddings ===")
    print(f"Model: {EMBEDDING_MODEL}")
    print()

    # 1. Load embedding model
    print("Loading embedding model...")
    model = SentenceTransformer(EMBEDDING_MODEL)
    print(f"  Model loaded. Dimension: {model.get_sentence_embedding_dimension()}")

    # 2. Connect to Supabase
    supabase = get_supabase()
    print("Connected to Supabase.")

    # 3. Fetch all documents
    result = supabase.table("documents").select("id, title, raw_content, metadata").execute()
    documents = result.data or []
    print(f"Found {len(documents)} documents.")

    if not documents:
        print("No documents to process. Run 002_maritime_seed_data.sql first.")
        return

    # 4. Process each document
    total_chunks = 0
    total_embedded = 0

    for doc in documents:
        doc_id = doc["id"]
        title = doc["title"]
        raw = doc.get("raw_content", "")

        if not raw:
            print(f"  SKIP {title}: no raw_content")
            continue

        # Chunk the document
        chunks = chunk_text(raw)
        print(f"  {title}: {len(chunks)} chunks")

        # Check if chunks already exist for this document
        existing = (
            supabase.table("document_chunks")
            .select("id")
            .eq("document_id", doc_id)
            .execute()
        )
        if existing.data:
            print(f"    Already has {len(existing.data)} chunks — deleting for re-seed")
            supabase.table("document_chunks").delete().eq("document_id", doc_id).execute()

        # Generate embeddings (batch)
        prefixed = [f"passage: {c}" for c in chunks]
        embeddings = model.encode(prefixed, normalize_embeddings=True, show_progress_bar=False)

        # Insert chunks with embeddings
        rows = []
        for i, (chunk_text_val, embedding) in enumerate(zip(chunks, embeddings)):
            rows.append({
                "document_id": doc_id,
                "chunk_index": i,
                "content": chunk_text_val,
                "embedding": embedding.tolist(),
                "metadata": doc.get("metadata", {}),
                "token_count": count_tokens_approx(chunk_text_val),
            })

        # Insert in batches of 20 (Supabase has request size limits)
        batch_size = 20
        for batch_start in range(0, len(rows), batch_size):
            batch = rows[batch_start:batch_start + batch_size]
            supabase.table("document_chunks").insert(batch).execute()

        total_chunks += len(chunks)
        total_embedded += len(embeddings)

    print()
    print(f"=== Done ===")
    print(f"Documents processed: {len(documents)}")
    print(f"Total chunks created: {total_chunks}")
    print(f"Total embeddings generated: {total_embedded}")


if __name__ == "__main__":
    main()
