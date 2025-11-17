from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
import logging

from app.ai.agents.itinerary_agent import ItineraryAgent

router = APIRouter()
logger = logging.getLogger(__name__)

class ItineraryRequest(BaseModel):
    destination: str = Field(..., description="Destination for the itinerary")
    duration: int = Field(..., ge=1, le=30, description="Trip duration in days")
    interests: List[str] = Field(
        default=[],
        description="Traveler interests (e.g., 'museums', 'hiking', 'food')"
    )
    pace: str = Field(
        default="moderate",
        description="Travel pace: 'relaxed', 'moderate', or 'packed'"
    )
    special_requirements: Optional[List[str]] = Field(
        default=[],
        description="Special requirements (e.g., 'wheelchair accessible', 'vegan')"
    )
    
    class Config:
        json_schema_extra = {
            "example": {
                "destination": "Kyoto, Japan",
                "duration": 5,
                "interests": ["temples", "gardens", "traditional cuisine"],
                "pace": "moderate",
                "special_requirements": ["vegetarian options"]
            }
        }

class DayPlan(BaseModel):
    day: int
    morning: str
    lunch: str
    afternoon: str
    evening: str
    dinner: str
    accommodation: str
    estimated_cost: float
    tips: str

class ItineraryResponse(BaseModel):
    destination: str
    duration: int
    daily_plans: List[DayPlan]
    total_estimated_cost: float
    overview: str

@router.post("/generate", response_model=ItineraryResponse)
async def generate_itinerary(request: ItineraryRequest):
    """
    Generate a personalized travel itinerary using AI.
    
    This endpoint creates a detailed day-by-day itinerary based on
    user preferences, interests, and travel style.
    """
    try:
        # Initialize itinerary agent
        itinerary_agent = ItineraryAgent(model="gpt-4", temperature=0.7)
        
        # Prepare input
        agent_input = {
            "destination": request.destination,
            "duration": request.duration,
            "interests": request.interests,
            "pace": request.pace,
            "special_requirements": request.special_requirements,
        }
        
        # Generate itinerary
        results = await itinerary_agent.execute(agent_input)
        
        # TODO: Parse AI response into structured format
        
        # Mock response
        daily_plans = [
            DayPlan(
                day=i + 1,
                morning=f"Day {i + 1} morning activities",
                lunch="Local restaurant recommendation",
                afternoon=f"Day {i + 1} afternoon activities",
                evening="Evening entertainment",
                dinner="Dinner recommendation",
                accommodation="Hotel name",
                estimated_cost=150.0,
                tips="Local tips and insights",
            )
            for i in range(request.duration)
        ]
        
        return ItineraryResponse(
            destination=request.destination,
            duration=request.duration,
            daily_plans=daily_plans,
            total_estimated_cost=request.duration * 150.0,
            overview="Comprehensive itinerary overview...",
        )
    
    except Exception as e:
        logger.error(f"Error generating itinerary: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error generating itinerary: {str(e)}"
        )

@router.get("/templates")
async def get_itinerary_templates():
    """
    Get pre-built itinerary templates for popular destinations.
    """
    return {
        "templates": [
            {
                "id": 1,
                "destination": "Paris",
                "duration": 5,
                "theme": "Classic Parisian Experience",
            },
            {
                "id": 2,
                "destination": "Tokyo",
                "duration": 7,
                "theme": "Modern & Traditional Japan",
            },
        ]
    }
