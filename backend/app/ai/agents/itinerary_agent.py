from typing import Any, Dict, List
import asyncio
import logging

from app.ai.agents.base_agent import BaseAgent

logger = logging.getLogger(__name__)

class ItineraryAgent(BaseAgent):
    """Agent specialized in creating personalized travel itineraries."""
    
    def get_system_prompt(self) -> str:
        return """
        You are an expert travel itinerary planner. Your role is to:
        
        1. Create detailed, day-by-day travel itineraries
        2. Balance activities, rest, and travel time
        3. Optimize routes and timing
        4. Consider user preferences and energy levels
        5. Include practical tips and local insights
        
        Always ensure:
        - Realistic timing and logistics
        - Mix of popular and off-the-beaten-path experiences
        - Flexibility for spontaneous changes
        - Cultural sensitivity and respect
        - Accessibility considerations
        
        Format itineraries as structured JSON with daily breakdowns.
        """
    
    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Generate a personalized travel itinerary.
        
        Args:
            input_data: Dict containing:
                - destination: str
                - duration: int (days)
                - interests: List[str]
                - pace: str (relaxed/moderate/packed)
                - special_requirements: List[str]
        
        Returns:
            Dict containing the complete itinerary
        """
        if not self.validate_input(input_data):
            raise ValueError("Invalid input data")
        
        destination = input_data.get("destination")
        duration = input_data.get("duration")
        interests = input_data.get("interests", [])
        pace = input_data.get("pace", "moderate")
        special_requirements = input_data.get("special_requirements", [])
        
        user_message = f"""
        Create a detailed {duration}-day itinerary for {destination}.
        
        Traveler Profile:
        - Interests: {', '.join(interests)}
        - Preferred Pace: {pace}
        - Special Requirements: {', '.join(special_requirements)}
        
        For each day, provide:
        1. Morning activities (with timing)
        2. Lunch recommendations
        3. Afternoon activities
        4. Evening plans
        5. Dinner suggestions
        6. Accommodation notes
        7. Transportation details
        8. Estimated daily budget
        9. Pro tips and local insights
        
        Ensure the itinerary is:
        - Logistically feasible
        - Culturally respectful
        - Balanced and enjoyable
        - Includes buffer time
        
        Format as JSON with clear day-by-day structure.
        """
        
        response = await self._generate_response(user_message)
        
        results = {
            "destination": destination,
            "duration": duration,
            "itinerary": response,
            "generated_at": asyncio.get_event_loop().time(),
        }
        
        return self.sanitize_output(results)
    
    def validate_input(self, input_data: Dict[str, Any]) -> bool:
        """Validate itinerary input data."""
        required_fields = ["destination", "duration"]
        if not all(field in input_data for field in required_fields):
            return False
        
        # Validate duration
        duration = input_data.get("duration")
        if not isinstance(duration, int) or duration < 1 or duration > 30:
            return False
        
        return True
