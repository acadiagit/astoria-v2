"""
Astoria v2 — Supabase client initialization.

Provides both a public client (for auth operations using anon key)
and a service client (for admin operations using service role key).
"""

from supabase import create_client, Client
from functools import lru_cache
from app.core.config import get_settings


@lru_cache()
def get_supabase_client() -> Client:
    """Public Supabase client (uses anon key, respects RLS)."""
    settings = get_settings()
    return create_client(settings.supabase_url, settings.supabase_anon_key)


@lru_cache()
def get_supabase_admin() -> Client:
    """Admin Supabase client (uses service role key, bypasses RLS).

    Use this only for backend operations that need elevated privileges:
    data ingestion, schema migrations, user management.
    """
    settings = get_settings()
    return create_client(settings.supabase_url, settings.supabase_service_role_key)
