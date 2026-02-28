"""
Astoria v2 — Data exploration endpoints.

Browse and filter the maritime database directly.
Queries the documents table filtered by metadata type.
"""

from fastapi import APIRouter, Depends, Query, HTTPException
from app.middleware.auth import AuthUser, get_current_user
from app.models.schemas import ShipSummary, VoyageSummary
from app.core.supabase import get_supabase_admin

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
    supabase = get_supabase_admin()

    query_builder = (
        supabase.table("documents")
        .select("id, title, metadata")
        .eq("metadata->>type", "ship")
        .order("title")
        .range(offset, offset + limit - 1)
    )

    if search:
        query_builder = query_builder.ilike("title", f"%{search}%")

    result = query_builder.execute()

    ships = []
    for doc in (result.data or []):
        meta = doc.get("metadata", {})
        year = meta.get("year_built")

        if year_min and year and int(year) < year_min:
            continue
        if year_max and year and int(year) > year_max:
            continue

        ships.append(ShipSummary(
            id=doc["id"],
            name=meta.get("ship_name", doc["title"]),
            type=meta.get("ship_type"),
            year_built=int(year) if year else None,
            port_of_registry=meta.get("port_of_registry"),
        ))

    return ships


@router.get("/ships/{ship_id}")
async def get_ship(
    ship_id: str,
    user: AuthUser = Depends(get_current_user),
):
    """Get detailed information about a specific ship."""
    supabase = get_supabase_admin()

    result = (
        supabase.table("documents")
        .select("id, title, raw_content, metadata, ingested_at")
        .eq("id", ship_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(status_code=404, detail="Ship not found")

    return result.data


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
    supabase = get_supabase_admin()

    query_builder = (
        supabase.table("documents")
        .select("id, title, metadata")
        .eq("metadata->>type", "voyage")
        .order("title")
        .range(offset, offset + limit - 1)
    )

    if ship_name:
        query_builder = query_builder.ilike("metadata->>ship_name", f"%{ship_name}%")

    result = query_builder.execute()

    voyages = []
    for doc in (result.data or []):
        meta = doc.get("metadata", {})

        if port:
            dep = (meta.get("departure_port") or "").lower()
            arr = (meta.get("arrival_port") or "").lower()
            if port.lower() not in dep and port.lower() not in arr:
                continue

        if date_from:
            dep_date = meta.get("departure_date", "")
            if dep_date and dep_date < date_from:
                continue

        if date_to:
            arr_date = meta.get("arrival_date", "")
            if arr_date and arr_date > date_to:
                continue

        voyages.append(VoyageSummary(
            id=doc["id"],
            ship_name=meta.get("ship_name", "Unknown"),
            departure_port=meta.get("departure_port"),
            arrival_port=meta.get("arrival_port"),
            departure_date=meta.get("departure_date"),
            arrival_date=meta.get("arrival_date"),
        ))

    return voyages
