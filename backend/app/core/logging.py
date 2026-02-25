"""
Astoria v2 — Structured logging configuration.

Uses structlog for JSON-formatted logs in production
and human-readable logs in development.
"""

import structlog
import logging
from app.core.config import get_settings


def setup_logging() -> None:
    """Configure structured logging based on environment."""
    settings = get_settings()

    if settings.environment == "development":
        renderer = structlog.dev.ConsoleRenderer(colors=True)
    else:
        renderer = structlog.processors.JSONRenderer()

    structlog.configure(
        processors=[
            structlog.contextvars.merge_contextvars,
            structlog.processors.add_log_level,
            structlog.processors.StackInfoRenderer(),
            structlog.dev.set_exc_info,
            structlog.processors.TimeStamper(fmt="iso"),
            renderer,
        ],
        wrapper_class=structlog.make_filtering_bound_logger(
            logging.DEBUG if settings.debug else logging.INFO
        ),
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(),
        cache_logger_on_first_use=True,
    )


def get_logger(name: str = "astoria"):
    """Get a structured logger instance."""
    return structlog.get_logger(name)
