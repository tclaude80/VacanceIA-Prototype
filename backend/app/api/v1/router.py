from fastapi import APIRouter

from app.api.v1.endpoints import auth, search, itinerary, users

api_router = APIRouter()

api_router.include_router(
    auth.router,
    prefix="/auth",
    tags=["Authentication"]
)

api_router.include_router(
    users.router,
    prefix="/users",
    tags=["Users"]
)

api_router.include_router(
    search.router,
    prefix="/search",
    tags=["Search"]
)

api_router.include_router(
    itinerary.router,
    prefix="/itinerary",
    tags=["Itinerary"]
)
