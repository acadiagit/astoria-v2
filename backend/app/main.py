"""
Astoria v2 — FastAPI application entry point.

Registers all routers, middleware, and startup events.
"""

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import get_settings
from app.core.logging import setup_logging, get_logger
from app.api import health, query, explore, sources, ingest


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application startup and shutdown events."""
    setup_logging()
    logger = get_logger()
    settings = get_settings()

    logger.info(
        "starting_astoria",
        version=settings.app_version,
        environment=settings.environment,
    )

    # TODO Phase 2: Load embedding model on startup
    # TODO Phase 2: Initialize LlamaIndex components

    yield

    logger.info("shutting_down_astoria")


def create_app() -> FastAPI:
    """Application factory."""
    settings = get_settings()

    app = FastAPI(
        title=settings.app_name,
        version=settings.app_version,
        description=(
            "Maritime history research platform. "
            "Query historical ship records, voyages, and maritime archives "
            "using natural language."
        ),
        lifespan=lifespan,
        docs_url="/api/docs" if settings.debug else None,
        redoc_url="/api/redoc" if settings.debug else None,
    )

    # --- CORS ---
    origins = settings.cors_origins
    if settings.environment == "development":
        origins.append("http://localhost:5173")

    app.add_middleware(
        CORSMiddleware,
        allow_origins=origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # --- Routers ---
    app.include_router(health.router, prefix="/api")
    app.include_router(query.router, prefix="/api")
    app.include_router(explore.router, prefix="/api")
    app.include_router(sources.router, prefix="/api")
    app.include_router(ingest.router, prefix="/api")

    return app


app = create_app()
