from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional
from langchain.llms import OpenAI
from langchain.chat_models import ChatAnthropic
from langchain.schema import HumanMessage, SystemMessage
import logging

from app.core.config import settings

logger = logging.getLogger(__name__)

class BaseAgent(ABC):
    """Base class for all AI agents."""
    
    def __init__(
        self,
        model: str = "gpt-4",
        temperature: float = 0.7,
        max_tokens: int = 2000,
    ):
        self.model = model
        self.temperature = temperature
        self.max_tokens = max_tokens
        self._setup_llm()
    
    def _setup_llm(self):
        """Initialize the LLM based on configuration."""
        if "gpt" in self.model.lower():
            self.llm = OpenAI(
                api_key=settings.OPENAI_API_KEY,
                model=self.model,
                temperature=self.temperature,
                max_tokens=self.max_tokens,
            )
        elif "claude" in self.model.lower():
            self.llm = ChatAnthropic(
                api_key=settings.ANTHROPIC_API_KEY,
                model=self.model,
                temperature=self.temperature,
                max_tokens=self.max_tokens,
            )
        else:
            raise ValueError(f"Unsupported model: {self.model}")
    
    @abstractmethod
    def get_system_prompt(self) -> str:
        """Return the system prompt for this agent."""
        pass
    
    @abstractmethod
    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Execute the agent's main task."""
        pass
    
    async def _generate_response(
        self,
        user_message: str,
        system_prompt: Optional[str] = None,
    ) -> str:
        """Generate a response from the LLM."""
        try:
            if system_prompt is None:
                system_prompt = self.get_system_prompt()
            
            messages = [
                SystemMessage(content=system_prompt),
                HumanMessage(content=user_message),
            ]
            
            response = await self.llm.agenerate([messages])
            return response.generations[0][0].text
        
        except Exception as e:
            logger.error(f"Error generating response: {str(e)}")
            raise
    
    def validate_input(self, input_data: Dict[str, Any]) -> bool:
        """Validate input data for the agent."""
        return True
    
    def sanitize_output(self, output: Dict[str, Any]) -> Dict[str, Any]:
        """Sanitize and format output data."""
        return output
