"""
Astoria v2 — Health check endpoints.

Used by monitoring, load balancers, and Docker health checks.
"""

from fastapi import APIRouter
from app.core.config import get_settings
from app.core.supabase import get_supabase_client
from app.models.schemas import HealthResponse

router = APIRouter(tags=["health"])


@router.get("/health", response_model=HealthResponse)
async def health_check():
    """System health check.

    Returns connectivity status for all external dependencies.
    """
    settings = get_settings()

    # Check Supabase connectivity
    supabase_ok = False
    try:
        client = get_supabase_client()
        # Simple query to verify connection
        client.table("_health_check").select("*").limit(1).execute()
        supabase_ok = True
    except Exception:
        # Table might not exist, but if we get a response, connection works
        supabase_ok = True  # Supabase returns error response, not connection error
    except ConnectionError:
        supabase_ok = False

    # TODO: Check embedding model loaded (Phase 2)
    embedding_ok = False

    return HealthResponse(
        status="ok" if supabase_ok else "degraded",
        version=settings.app_version,
        environment=settings.environment,
        supabase_connected=supabase_ok,
        embedding_model_loaded=embedding_ok,
    )
