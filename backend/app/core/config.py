from pydantic_settings import BaseSettings
from typing import List
import secrets

class Settings(BaseSettings):
    # Project
    PROJECT_NAME: str = "VacanceIA"
    VERSION: str = "0.1.0"
    ENVIRONMENT: str = "development"
    
    # Security
    SECRET_KEY: str = secrets.token_urlsafe(32)
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 15
    REFRESH_TOKEN_EXPIRE_DAYS: int = 30
    
    # CORS
    CORS_ORIGINS: List[str] = [
        "http://localhost:3000",
        "http://localhost:5173",
        "https://vacanceia.io",
    ]
    ALLOWED_HOSTS: List[str] = ["localhost", "127.0.0.1", "vacanceia.io"]
    
    # Database
    DATABASE_URL: str = "postgresql://user:password@localhost:5432/vacanceia"
    
    # Redis
    REDIS_URL: str = "redis://localhost:6379/0"
    
    # AI APIs
    OPENAI_API_KEY: str = ""
    ANTHROPIC_API_KEY: str = ""
    HUGGINGFACE_API_KEY: str = ""
    
    # External APIs
    AMADEUS_API_KEY: str = ""
    AMADEUS_API_SECRET: str = ""
    GOOGLE_MAPS_API_KEY: str = ""
    OPENWEATHER_API_KEY: str = ""
    
    # Monitoring
    SENTRY_DSN: str = ""
    
    # Rate Limiting
    RATE_LIMIT_PER_MINUTE: int = 60
    
    # Email
    SMTP_HOST: str = ""
    SMTP_PORT: int = 587
    SMTP_USER: str = ""
    SMTP_PASSWORD: str = ""
    
    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
