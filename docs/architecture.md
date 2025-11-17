# Architecture Technique VacanceIA

## Vue d'ensemble

VacanceIA est une application web full-stack utilisant une architecture microservices avec des agents IA spécialisés.

## Diagramme d'architecture

```
┌────────────────────────┐
│   Frontend (React)      │
│   - Vite + TypeScript   │
│   - Tailwind CSS        │
│   - React Query         │
└──────────┬─────────────┘
           │ HTTPS/TLS 1.3
┌──────────┴─────────────┐
│   API Gateway           │
│   - Rate Limiting       │
│   - Authentication      │
└──────────┬─────────────┘
           │
┌──────────┴─────────────┐
│   Backend (FastAPI)     │
│   - REST API            │
│   - WebSocket           │
└──────────┬─────────────┘
           │
      ┌────┼────┐
      │         │      │
┌─────┴───┐  ┌─┴──┐  ┌─┴──────────┐
│ AI Agents│  │ DB │  │   Redis    │
│          │  └───┘  │   Cache     │
│ Research │         └───────────┘
│ Budget   │
│ Itinerary│
│ Safety   │
└──────────┘
```

## Composants Principaux

### 1. Frontend (React + TypeScript)

**Technologies:**
- React 18 avec TypeScript
- Vite (build tool rapide)
- Tailwind CSS (styling)
- React Query (state management)
- React Router (navigation)

**Structure:**
```
frontend/src/
├── components/     # Composants réutilisables
├── pages/          # Pages de l'application
├── services/       # API clients
├── hooks/          # Custom React hooks
└── utils/          # Utilitaires
```

### 2. Backend (FastAPI + Python)

**Technologies:**
- FastAPI (web framework)
- Pydantic (validation)
- SQLAlchemy (ORM)
- Alembic (migrations)

**Structure:**
```
backend/app/
├── api/            # API endpoints
├── core/           # Configuration, sécurité
├── models/         # Modèles de données
├── services/       # Logique métier
├── ai/             # Agents IA
└── utils/          # Utilitaires
```

### 3. Agents IA

Chaque agent est spécialisé dans une tâche spécifique :

**Research Agent:**
- Recherche d'options de voyage
- Comparaison de prix
- Analyse de reviews

**Itinerary Agent:**
- Création d'itinéraires personnalisés
- Optimisation des parcours
- Recommandations culturelles

**Budget Agent:**
- Optimisation des coûts
- Détection de bonnes affaires
- Prévision des dépenses

**Safety Agent:**
- Évaluation des risques
- Alertes sécurité
- Recommandations sanitaires

### 4. Base de Données

**PostgreSQL** avec :
- Chiffrement transparent des données
- Sauvegardes automatiques
- Réplication pour haute disponibilité

**Schéma:**
```sql
-- Utilisateurs
users (
  id, email, password_hash, created_at, mfa_enabled
)

-- Profils
user_profiles (
  user_id, full_name, bio, avatar_url, preferences
)

-- Recherches
searches (
  id, user_id, destination, dates, budget, results
)

-- Itinéraires
itineraries (
  id, user_id, destination, duration, plan, created_at
)
```

### 5. Cache (Redis)

**Utilisation:**
- Session management
- Rate limiting
- Cache de recherches
- Cache de résultats IA

## Flux de Données

### Recherche de Voyage

```
1. User submits search form
   ↓
2. Frontend validates & sends to API
   ↓
3. API authenticates user
   ↓
4. Research Agent executes:
   - Calls external APIs (Amadeus, etc.)
   - LLM analyzes & ranks options
   - Caches results
   ↓
5. Structured response returned
   ↓
6. Frontend displays results
```

### Génération d'Itinéraire

```
1. User submits itinerary request
   ↓
2. Itinerary Agent:
   - Retrieves user preferences
   - Calls LLM with structured prompt
   - Validates generated itinerary
   - Estimates costs (Budget Agent)
   ↓
3. Day-by-day plan returned
   ↓
4. Frontend renders interactive itinerary
```

## Sécurité

### Authentification

- **OAuth 2.0** avec JWT tokens
- **MFA** obligatoire (TOTP ou WebAuthn)
- **Refresh tokens** en httpOnly cookies
- **Rate limiting** sur endpoints sensibles

### Autorisation

- **RBAC** (Role-Based Access Control)
- Principe du moindre privilège
- Validation des permissions à chaque requête

### Chiffrement

- **TLS 1.3** pour transit
- **AES-256-GCM** pour données au repos
- **Argon2** pour hachage de mots de passe

### Protection des APIs

- Input sanitization
- CORS strict
- CSP headers
- Rate limiting par IP et par user

## Performance

### Optimisations

- **Cache multi-niveaux:**
  - Browser cache (static assets)
  - CDN cache (images, fonts)
  - Redis cache (API responses)
  - Database query cache

- **Async processing:**
  - Celery pour tâches lourdes
  - WebSocket pour real-time updates

- **Database:**
  - Indexes optimisés
  - Connection pooling
  - Query optimization

## Monitoring

### Métriques

- **Prometheus** pour métriques
- **Grafana** pour dashboards
- **Sentry** pour error tracking
- **ELK Stack** pour logs

### Alertes

- Temps de réponse API
- Taux d'erreurs
- Utilisation ressources
- Tentatives d'intrusion

## Déploiement

### Infrastructure

- **Docker** containers
- **Kubernetes** orchestration
- **CI/CD** avec GitHub Actions
- **Blue-Green deployment**

### Environnements

1. **Development** - Local
2. **Staging** - Pré-production
3. **Production** - Live

## Scalabilité

### Horizontal Scaling

- Load balancer
- Multiple API instances
- Database replication
- Redis cluster

### Vertical Scaling

- Resource limits dynamiques
- Auto-scaling basé sur métriques

## Conformité

### RGPD

- Consentement explicite
- Right to access (export data)
- Right to erasure (delete account)
- Data minimization
- Privacy by design

### Standards

- ISO 27001 (Information Security)
- SOC 2 Type II (Security Controls)
- PCI DSS (Payment processing)

---

**Dernière mise à jour:** 2025-11-17
