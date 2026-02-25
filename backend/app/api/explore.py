"""
Astoria v2 — Data exploration endpoints.

Browse and filter the maritime database directly.
Phase 1: Scaffold with placeholder logic.
Phase 4: Full implementation with frontend integration.
"""

from fastapi import APIRouter, Depends, Query
from app.middleware.auth import AuthUser, get_current_user
from app.models.schemas import ShipSummary, VoyageSummary

router = APIRouter(prefix="/explore", tags=["explore"])


@router.get("/ships", response_model=list[ShipSummary])
async def list_ships(
    search: str | None = Query(None, description="Search by ship name"),
    year_min: int | None = Query(None, description="Filter by minimum year built"),
    year_max: int | None = Query(None, description="Filter by maximum year built"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    user: AuthUser = Depends(get_current_user),
):
    """List ships with optional filters."""
    # Phase 1 placeholder — Phase 4 connects to Supabase
    return []


@router.get("/ships/{ship_id}")
async def get_ship(
    ship_id: str,
    user: AuthUser = Depends(get_current_user),
):
    """Get detailed information about a specific ship."""
    return {"id": ship_id, "message": "Phase 1 placeholder"}


@router.get("/voyages", response_model=list[VoyageSummary])
async def list_voyages(
    ship_name: str | None = Query(None),
    port: str | None = Query(None, description="Filter by departure or arrival port"),
    date_from: str | None = Query(None, description="YYYY-MM-DD"),
    date_to: str | None = Query(None, description="YYYY-MM-DD"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    user: AuthUser = Depends(get_current_user),
):
    """List voyages with optional filters."""
    return []
