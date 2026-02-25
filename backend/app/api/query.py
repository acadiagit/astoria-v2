"""
Astoria v2 — Query endpoints.

Main entry point for natural language queries against the maritime database.
Phase 1: Scaffold with placeholder logic.
Phase 2: Full RAG pipeline integration.
"""

from fastapi import APIRouter, Depends
from app.middleware.auth import AuthUser, get_current_user
from app.models.schemas import QueryRequest, QueryResponse, QueryComplexity

router = APIRouter(prefix="/query", tags=["query"])


@router.post("", response_model=QueryResponse)
async def submit_query(
    request: QueryRequest,
    user: AuthUser = Depends(get_current_user),
):
    """Submit a natural language query about maritime history.

    The system will:
    1. Classify the query complexity (simple / complex / research).
    2. Route to the appropriate LLM (Gemini Flash / Claude / Groq).
    3. Generate SQL if applicable.
    4. Retrieve relevant document chunks for context.
    5. Synthesize a narrative answer with source citations.
    """
    # Phase 1: Return a placeholder response confirming the pipeline shape.
    # Phase 2 will integrate LlamaIndex, query routing, and LLM calls.

    return QueryResponse(
        answer=(
            f"[Phase 1 placeholder] Query received: '{request.question}'. "
            f"Authenticated as {user.email}. "
            f"The full RAG pipeline will be connected in Phase 2."
        ),
        sql_generated="SELECT 'phase 1 placeholder';" if request.include_sql else None,
        data_preview=None,
        sources=[],
        complexity=QueryComplexity.SIMPLE,
        model_used="placeholder",
        processing_time_ms=0,
    )
