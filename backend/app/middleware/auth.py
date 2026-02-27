"""
Astoria v2 — JWT authentication middleware.

Validates Supabase-issued JWTs on protected endpoints.
Extracts user ID and role from the token.
Supports both HS256 (legacy) and RS256/ES256 (new Supabase projects).
"""

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError, jwt
from pydantic import BaseModel
from app.core.config import get_settings
import httpx
import functools

security = HTTPBearer()


class AuthUser(BaseModel):
    """Authenticated user extracted from JWT."""
    id: str
    email: str
    role: str = "researcher"  # "researcher" | "admin"


@functools.lru_cache()
def _fetch_jwks(supabase_url: str) -> dict:
    """Fetch JWKS (public keys) from Supabase for asymmetric JWT verification."""
    jwks_url = f"{supabase_url}/auth/v1/.well-known/jwks.json"
    response = httpx.get(jwks_url, timeout=10)
    response.raise_for_status()
    return response.json()


def decode_jwt(token: str) -> dict:
    """Decode and validate a Supabase JWT.

    Tries HS256 with the legacy secret first, then falls back
    to fetching JWKS for ES256/RS256 verification.
    """
    settings = get_settings()

    # Try HS256 with legacy JWT secret first
    try:
        payload = jwt.decode(
            token,
            settings.supabase_jwt_secret,
            algorithms=["HS256"],
            audience="authenticated",
        )
        return payload
    except JWTError:
        pass

    # Fall back to JWKS-based verification (ES256/RS256)
    try:
        # Peek at the token header to get the algorithm and key ID
        unverified_header = jwt.get_unverified_header(token)
        alg = unverified_header.get("alg", "ES256")
        kid = unverified_header.get("kid")

        jwks = _fetch_jwks(settings.supabase_url)
        key = None
        for k in jwks.get("keys", []):
            if k.get("kid") == kid:
                key = k
                break

        if not key:
            raise JWTError("No matching key found in JWKS")

        payload = jwt.decode(
            token,
            key,
            algorithms=[alg],
            audience="authenticated",
        )
        return payload
    except (JWTError, httpx.HTTPError) as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid or expired token: {e}",
            headers={"WWW-Authenticate": "Bearer"},
        )


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> AuthUser:
    """Dependency: extract and validate the current user from JWT.

    Usage:
        @router.get("/protected")
        async def protected_route(user: AuthUser = Depends(get_current_user)):
            return {"user_id": user.id}
    """
    payload = decode_jwt(credentials.credentials)

    user_id = payload.get("sub")
    email = payload.get("email", "")
    role = payload.get("user_metadata", {}).get("role", "researcher")

    if not user_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token missing user ID",
        )

    return AuthUser(id=user_id, email=email, role=role)


async def require_admin(
    user: AuthUser = Depends(get_current_user),
) -> AuthUser:
    """Dependency: require admin role.

    Usage:
        @router.post("/admin-only")
        async def admin_route(user: AuthUser = Depends(require_admin)):
            return {"admin": user.id}
    """
    if user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required",
        )
    return user
