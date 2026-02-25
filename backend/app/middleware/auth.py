"""
Astoria v2 — JWT authentication middleware.

Validates Supabase-issued JWTs on protected endpoints.
Extracts user ID and role from the token.
"""

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError, jwt
from pydantic import BaseModel
from app.core.config import get_settings

security = HTTPBearer()


class AuthUser(BaseModel):
    """Authenticated user extracted from JWT."""
    id: str
    email: str
    role: str = "researcher"  # "researcher" | "admin"


def decode_jwt(token: str) -> dict:
    """Decode and validate a Supabase JWT."""
    settings = get_settings()
    try:
        payload = jwt.decode(
            token,
            settings.supabase_jwt_secret,
            algorithms=["HS256"],
            audience="authenticated",
        )
        return payload
    except JWTError as e:
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
