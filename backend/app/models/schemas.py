"""
Astoria v2 — Pydantic models for API request/response schemas.
"""

from pydantic import BaseModel, Field
from datetime import datetime
from enum import Enum


# --- Enums ---

class QueryComplexity(str, Enum):
    SIMPLE = "simple"
    COMPLEX = "complex"
    RESEARCH = "research"


class IngestionStatus(str, Enum):
    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"


# --- Query ---

class QueryRequest(BaseModel):
    """User's natural language query."""
    question: str = Field(..., min_length=3, max_length=2000)
    include_sql: bool = Field(default=False, description="Return generated SQL in response")
    include_sources: bool = Field(default=True, description="Return source citations")


class SourceCitation(BaseModel):
    """A citation linking a claim to its source document."""
    document_id: str
    document_title: str
    source_url: str | None = None
    archive_name: str | None = None
    chunk_text: str = Field(description="Relevant excerpt from the source")
    relevance_score: float


class QueryResponse(BaseModel):
    """Response to a user query."""
    answer: str
    sql_generated: str | None = None
    data_preview: list[dict] | None = None
    sources: list[SourceCitation] = []
    complexity: QueryComplexity
    model_used: str
    processing_time_ms: int


# --- Data Exploration ---

class ShipSummary(BaseModel):
    """Brief ship record for listing views."""
    id: str
    name: str
    type: str | None = None
    year_built: int | None = None
    port_of_registry: str | None = None


class VoyageSummary(BaseModel):
    """Brief voyage record."""
    id: str
    ship_name: str
    departure_port: str | None = None
    arrival_port: str | None = None
    departure_date: str | None = None
    arrival_date: str | None = None


# --- Source Documents ---

class DocumentMeta(BaseModel):
    """Metadata about an ingested source document."""
    id: str
    title: str
    source_url: str | None = None
    archive_name: str | None = None
    ingested_at: datetime
    chunk_count: int
    checksum: str


# --- Ingestion ---

class IngestionTrigger(BaseModel):
    """Request to trigger a data ingestion run."""
    source_id: str = Field(description="Which scraper/source to run")
    force_reindex: bool = Field(default=False, description="Re-embed even if content unchanged")


class IngestionResult(BaseModel):
    """Result of an ingestion run."""
    run_id: str
    source_id: str
    status: IngestionStatus
    documents_processed: int = 0
    chunks_created: int = 0
    errors: list[str] = []
    started_at: datetime
    completed_at: datetime | None = None


# --- Health ---

class HealthResponse(BaseModel):
    """Health check response."""
    status: str = "ok"
    version: str
    environment: str
    supabase_connected: bool
    embedding_model_loaded: bool
