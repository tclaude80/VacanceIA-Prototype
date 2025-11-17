# API Documentation - VacanceIA

## Base URL

```
Development: http://localhost:8000/api/v1
Production: https://api.vacanceia.io/v1
```

## Authentication

### Register

**Endpoint:** `POST /auth/register`

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123!",
  "full_name": "John Doe"
}
```

**Response:**
```json
{
  "id": 1,
  "email": "user@example.com",
  "full_name": "John Doe",
  "is_active": true
}
```

### Login

**Endpoint:** `POST /auth/login`

**Request:**
```json
{
  "username": "user@example.com",
  "password": "SecurePassword123!"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

### Get Current User

**Endpoint:** `GET /auth/me`

**Headers:**
```
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "id": 1,
  "email": "user@example.com",
  "full_name": "John Doe",
  "is_active": true
}
```

## Search

### Search Travel Options

**Endpoint:** `POST /search/travel`

**Headers:**
```
Authorization: Bearer {access_token}
Content-Type: application/json
```

**Request:**
```json
{
  "destination": "Tokyo, Japan",
  "start_date": "2025-03-15",
  "end_date": "2025-03-22",
  "budget": 3000,
  "travelers": 2,
  "preferences": ["culture", "food", "technology"]
}
```

**Response:**
```json
{
  "destination": "Tokyo, Japan",
  "flights": [
    {
      "airline": "Air France",
      "departure_time": "2025-03-15T10:00:00",
      "arrival_time": "2025-03-16T05:00:00",
      "duration": "13h",
      "price": 850.0,
      "stops": 1
    }
  ],
  "hotels": [
    {
      "name": "Tokyo Grand Hotel",
      "rating": 4.5,
      "price_per_night": 120.0,
      "location": "Shinjuku",
      "amenities": ["WiFi", "Breakfast", "Gym"]
    }
  ],
  "estimated_total": 2500.0,
  "recommendations": "Based on your preferences..."
}
```

### Get Popular Destinations

**Endpoint:** `GET /search/destinations/popular`

**Response:**
```json
{
  "destinations": [
    {
      "name": "Paris, France",
      "category": "Culture"
    },
    {
      "name": "Tokyo, Japan",
      "category": "Technology & Culture"
    }
  ]
}
```

## Itinerary

### Generate Itinerary

**Endpoint:** `POST /itinerary/generate`

**Headers:**
```
Authorization: Bearer {access_token}
Content-Type: application/json
```

**Request:**
```json
{
  "destination": "Kyoto, Japan",
  "duration": 5,
  "interests": ["temples", "gardens", "traditional cuisine"],
  "pace": "moderate",
  "special_requirements": ["vegetarian options"]
}
```

**Response:**
```json
{
  "destination": "Kyoto, Japan",
  "duration": 5,
  "daily_plans": [
    {
      "day": 1,
      "morning": "Visit Fushimi Inari Shrine",
      "lunch": "Traditional shojin ryori at temple restaurant",
      "afternoon": "Explore Arashiyama Bamboo Grove",
      "evening": "Gion district walking tour",
      "dinner": "Kaiseki dinner at local restaurant",
      "accommodation": "Traditional ryokan in Higashiyama",
      "estimated_cost": 150.0,
      "tips": "Start early to avoid crowds at Fushimi Inari"
    }
  ],
  "total_estimated_cost": 750.0,
  "overview": "Comprehensive 5-day Kyoto experience..."
}
```

### Get Itinerary Templates

**Endpoint:** `GET /itinerary/templates`

**Response:**
```json
{
  "templates": [
    {
      "id": 1,
      "destination": "Paris",
      "duration": 5,
      "theme": "Classic Parisian Experience"
    }
  ]
}
```

## Users

### Get User Profile

**Endpoint:** `GET /users/profile`

**Headers:**
```
Authorization: Bearer {access_token}
```

**Response:**
```json
{
  "email": "user@example.com",
  "full_name": "John Doe",
  "bio": "Travel enthusiast",
  "avatar_url": null
}
```

### Update User Profile

**Endpoint:** `PUT /users/profile`

**Request:**
```json
{
  "full_name": "John Smith",
  "bio": "World traveler and foodie"
}
```

### Get Travel Preferences

**Endpoint:** `GET /users/preferences`

**Response:**
```json
{
  "preferred_destinations": ["Paris", "Tokyo", "Barcelona"],
  "travel_style": "moderate",
  "interests": ["culture", "food", "history"],
  "budget_range": "medium",
  "dietary_restrictions": [],
  "accessibility_needs": []
}
```

### Export User Data (GDPR)

**Endpoint:** `GET /users/data-export`

**Response:**
```json
{
  "user_id": "user-123",
  "profile": {...},
  "preferences": {...},
  "trips": [...],
  "searches": [...],
  "exported_at": "2025-11-17T20:00:00Z"
}
```

### Delete Account (GDPR)

**Endpoint:** `DELETE /users/account`

**Response:**
```json
{
  "message": "Account deletion request received. Your data will be permanently deleted within 48 hours."
}
```

## Error Responses

### 400 Bad Request
```json
{
  "detail": "Invalid input data"
}
```

### 401 Unauthorized
```json
{
  "detail": "Could not validate credentials"
}
```

### 403 Forbidden
```json
{
  "detail": "Not enough permissions"
}
```

### 404 Not Found
```json
{
  "detail": "Resource not found"
}
```

### 422 Validation Error
```json
{
  "detail": [
    {
      "loc": ["body", "email"],
      "msg": "value is not a valid email address",
      "type": "value_error.email"
    }
  ]
}
```

### 429 Too Many Requests
```json
{
  "detail": "Rate limit exceeded. Please try again later."
}
```

### 500 Internal Server Error
```json
{
  "detail": "An unexpected error occurred. Please try again later.",
  "request_id": "req_abc123"
}
```

## Rate Limiting

- **Authentication endpoints:** 5 requests/minute
- **Search endpoints:** 100 requests/minute
- **General endpoints:** 60 requests/minute

**Headers:**
```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 59
X-RateLimit-Reset: 1700251200
```

## Webhooks (Future)

Coming soon: Real-time notifications for price changes, travel alerts, etc.

---

**Note:** Cette documentation est en développement. Pour la documentation interactive complète, visitez `/api/docs` sur votre instance.
