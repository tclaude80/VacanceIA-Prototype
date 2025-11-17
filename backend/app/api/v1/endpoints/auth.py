from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from pydantic import BaseModel, EmailStr
from typing import Optional

from app.core.security import (
    create_access_token,
    create_refresh_token,
    verify_password,
    get_password_hash,
    decode_token,
)

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

class UserRegister(BaseModel):
    email: EmailStr
    password: str
    full_name: str

class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"

class UserResponse(BaseModel):
    id: int
    email: str
    full_name: str
    is_active: bool

@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(user_data: UserRegister):
    """
    Register a new user.
    
    - **email**: User's email address
    - **password**: Strong password (min 8 characters)
    - **full_name**: User's full name
    """
    # TODO: Check if user exists
    # TODO: Create user in database
    
    return {
        "id": 1,
        "email": user_data.email,
        "full_name": user_data.full_name,
        "is_active": True,
    }

@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """
    OAuth2 compatible login endpoint.
    
    Returns access and refresh tokens.
    """
    # TODO: Verify credentials against database
    # TODO: Check if MFA is enabled
    
    # Create tokens
    access_token = create_access_token(data={"sub": form_data.username})
    refresh_token = create_refresh_token(data={"sub": form_data.username})
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer",
    }

@router.post("/refresh", response_model=Token)
async def refresh_token(refresh_token: str):
    """
    Refresh access token using refresh token.
    """
    payload = decode_token(refresh_token)
    
    if payload.get("type") != "refresh":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token type",
        )
    
    # Create new tokens
    access_token = create_access_token(data={"sub": payload.get("sub")})
    new_refresh_token = create_refresh_token(data={"sub": payload.get("sub")})
    
    return {
        "access_token": access_token,
        "refresh_token": new_refresh_token,
        "token_type": "bearer",
    }

@router.get("/me", response_model=UserResponse)
async def get_current_user(token: str = Depends(oauth2_scheme)):
    """
    Get current authenticated user.
    """
    payload = decode_token(token)
    
    # TODO: Fetch user from database
    
    return {
        "id": 1,
        "email": payload.get("sub"),
        "full_name": "User Name",
        "is_active": True,
    }
