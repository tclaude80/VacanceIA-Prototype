from fastapi import APIRouter, HTTPException, status, Depends
from pydantic import BaseModel, EmailStr
from typing import Optional, List
import logging

from app.api.v1.endpoints.auth import oauth2_scheme, decode_token

router = APIRouter()
logger = logging.getLogger(__name__)

class UserProfile(BaseModel):
    email: EmailStr
    full_name: str
    bio: Optional[str] = None
    avatar_url: Optional[str] = None

class TravelPreferences(BaseModel):
    preferred_destinations: List[str] = []
    travel_style: str = "moderate"  # relaxed, moderate, packed
    interests: List[str] = []
    budget_range: str = "medium"  # low, medium, high, luxury
    dietary_restrictions: List[str] = []
    accessibility_needs: List[str] = []

class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    bio: Optional[str] = None
    travel_preferences: Optional[TravelPreferences] = None

@router.get("/profile", response_model=UserProfile)
async def get_user_profile(token: str = Depends(oauth2_scheme)):
    """
    Get current user's profile.
    """
    payload = decode_token(token)
    
    # TODO: Fetch from database
    return UserProfile(
        email=payload.get("sub"),
        full_name="User Name",
        bio="Travel enthusiast",
        avatar_url=None,
    )

@router.put("/profile", response_model=UserProfile)
async def update_user_profile(
    update: UserUpdate,
    token: str = Depends(oauth2_scheme)
):
    """
    Update current user's profile.
    """
    payload = decode_token(token)
    
    # TODO: Update in database
    
    return UserProfile(
        email=payload.get("sub"),
        full_name=update.full_name or "User Name",
        bio=update.bio,
        avatar_url=None,
    )

@router.get("/preferences", response_model=TravelPreferences)
async def get_travel_preferences(token: str = Depends(oauth2_scheme)):
    """
    Get user's travel preferences.
    """
    # TODO: Fetch from database
    return TravelPreferences(
        preferred_destinations=["Paris", "Tokyo", "Barcelona"],
        travel_style="moderate",
        interests=["culture", "food", "history"],
        budget_range="medium",
        dietary_restrictions=[],
        accessibility_needs=[],
    )

@router.put("/preferences", response_model=TravelPreferences)
async def update_travel_preferences(
    preferences: TravelPreferences,
    token: str = Depends(oauth2_scheme)
):
    """
    Update user's travel preferences.
    
    These preferences are used by AI agents to personalize recommendations.
    """
    # TODO: Save to database
    return preferences

@router.delete("/account")
async def delete_user_account(token: str = Depends(oauth2_scheme)):
    """
    Delete user account (GDPR compliance - Right to erasure).
    
    This will permanently delete all user data within 48 hours.
    """
    payload = decode_token(token)
    
    # TODO: Mark account for deletion
    # TODO: Schedule data erasure job
    
    return {
        "message": "Account deletion request received. "
                   "Your data will be permanently deleted within 48 hours."
    }

@router.get("/data-export")
async def export_user_data(token: str = Depends(oauth2_scheme)):
    """
    Export all user data (GDPR compliance - Right to data portability).
    
    Returns a comprehensive JSON export of all user data.
    """
    payload = decode_token(token)
    
    # TODO: Fetch all user data from database
    
    return {
        "user_id": "user-123",
        "profile": {},
        "preferences": {},
        "trips": [],
        "searches": [],
        "exported_at": "2025-11-17T20:00:00Z",
    }
