"""
Astoria v2 — Embedding service.

Loads Microsoft E5-large-v2 at startup and provides embed_query() / embed_documents()
for the RAG pipeline. E5 models require "query: " / "passage: " prefixes.
"""

import structlog
from sentence_transformers import SentenceTransformer
from app.core.config import get_settings

logger = structlog.get_logger()

# Module-level singleton — loaded once at startup via load_model()
_model: SentenceTransformer | None = None


def load_model() -> None:
    """Load the embedding model into memory. Call once at startup."""
    global _model
    settings = get_settings()
    model_name = settings.embedding_model

    logger.info("loading_embedding_model", model=model_name)
    _model = SentenceTransformer(model_name)
    logger.info(
        "embedding_model_loaded",
        model=model_name,
        dimension=settings.embedding_dimension,
    )


def is_loaded() -> bool:
    """Check if the embedding model is loaded."""
    return _model is not None


def embed_query(text: str) -> list[float]:
    """Embed a single user query.

    E5 models expect the prefix "query: " for retrieval queries.
    Returns a 1024-dim float vector.
    """
    if _model is None:
        raise RuntimeError("Embedding model not loaded. Call load_model() first.")

    prefixed = f"query: {text}"
    vector = _model.encode(prefixed, normalize_embeddings=True)
    return vector.tolist()


def embed_passages(texts: list[str]) -> list[list[float]]:
    """Embed a batch of document passages.

    E5 models expect the prefix "passage: " for documents being indexed.
    Returns a list of 1024-dim float vectors.
    """
    if _model is None:
        raise RuntimeError("Embedding model not loaded. Call load_model() first.")

    prefixed = [f"passage: {t}" for t in texts]
    vectors = _model.encode(prefixed, normalize_embeddings=True, show_progress_bar=True)
    return vectors.tolist()
