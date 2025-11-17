from typing import Any, Dict, List
import asyncio
import logging

from app.ai.agents.base_agent import BaseAgent

logger = logging.getLogger(__name__)

class ResearchAgent(BaseAgent):
    """Agent specialized in researching travel options."""
    
    def get_system_prompt(self) -> str:
        return """
        You are an expert travel research assistant. Your role is to:
        
        1. Research and compare travel options (flights, hotels, activities)
        2. Analyze prices, reviews, and availability
        3. Consider user preferences and constraints
        4. Provide comprehensive, unbiased recommendations
        5. Explain your reasoning clearly
        
        Always prioritize:
        - Accuracy of information
        - User safety and security
        - Value for money
        - Sustainable and ethical travel options
        
        Format your responses as structured JSON with clear categories.
        """
    
    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Research travel options based on user criteria.
        
        Args:
            input_data: Dict containing:
                - destination: str
                - dates: Dict[start_date, end_date]
                - budget: float
                - preferences: List[str]
                - travelers: int
        
        Returns:
            Dict containing research results
        """
        if not self.validate_input(input_data):
            raise ValueError("Invalid input data")
        
        # Extract input
        destination = input_data.get("destination")
        dates = input_data.get("dates")
        budget = input_data.get("budget")
        preferences = input_data.get("preferences", [])
        travelers = input_data.get("travelers", 1)
        
        # Create research prompt
        user_message = f"""
        Research travel options for the following trip:
        
        Destination: {destination}
        Travel Dates: {dates['start_date']} to {dates['end_date']}
        Budget: ${budget}
        Number of Travelers: {travelers}
        Preferences: {', '.join(preferences)}
        
        Please provide:
        1. Flight options (3-5 best options)
        2. Accommodation options (3-5 best options)
        3. Top activities and attractions
        4. Local transportation recommendations
        5. Budget breakdown
        6. Safety considerations
        7. Sustainable travel tips
        
        Format the response as JSON.
        """
        
        # Generate response
        response = await self._generate_response(user_message)
        
        # Parse and structure results
        results = {
            "destination": destination,
            "research_data": response,
            "timestamp": asyncio.get_event_loop().time(),
        }
        
        return self.sanitize_output(results)
    
    def validate_input(self, input_data: Dict[str, Any]) -> bool:
        """Validate research input data."""
        required_fields = ["destination", "dates", "budget"]
        return all(field in input_data for field in required_fields)
