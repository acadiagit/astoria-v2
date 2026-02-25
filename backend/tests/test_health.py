"""
Astoria v2 — Health endpoint tests.
"""

import pytest
from httpx import AsyncClient, ASGITransport
from unittest.mock import patch
from app.main import app


@pytest.fixture
def anyio_backend():
    return "asyncio"


@pytest.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as c:
        yield c


@pytest.mark.anyio
async def test_health_endpoint(client):
    """Health endpoint returns 200 with expected structure."""
    with patch("app.api.health.get_supabase_client"):
        response = await client.get("/api/health")

    assert response.status_code == 200
    data = response.json()
    assert "status" in data
    assert "version" in data
    assert "environment" in data
    assert "supabase_connected" in data
    assert "embedding_model_loaded" in data
