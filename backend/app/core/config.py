"""
Astoria v2 — Application configuration.

All settings are loaded from environment variables (or .env file).
"""

from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    """Application settings loaded from environment."""

    # --- Application ---
    app_name: str = "Astoria v2"
    app_version: str = "2.0.0"
    debug: bool = False
    environment: str = "production"  # "development" | "production"

    # --- Supabase ---
    supabase_url: str
    supabase_anon_key: str
    supabase_service_role_key: str
    supabase_jwt_secret: str

    # --- LLM API Keys ---
    anthropic_api_key: str = ""
    google_api_key: str = ""
    groq_api_key: str = ""

    # --- LLM Model Selection ---
    llm_sql_model: str = "gemini-2.0-flash"
    llm_research_model: str = "claude-sonnet-4-20250514"
    llm_narrative_model: str = "llama-3.3-70b-versatile"  # via Groq

    # --- Embedding ---
    embedding_model: str = "intfloat/e5-large-v2"
    embedding_dimension: int = 1024

    # --- CORS ---
    cors_origins: list[str] = ["http://localhost:5173", "http://localhost:3000"]

    # --- Rate Limiting ---
    rate_limit_per_minute: int = 30

    model_config = {
        "env_file": ".env",
        "env_file_encoding": "utf-8",
        "case_sensitive": False,
    }


@lru_cache()
def get_settings() -> Settings:
    """Cached settings instance."""
    return Settings()
