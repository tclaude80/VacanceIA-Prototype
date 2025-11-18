# Guide de Déploiement Docker - VacanceIA

## Table des Matières
1. [Prérequis](#prérequis)
2. [Configuration Initiale](#configuration-initiale)
3. [Déploiement avec Docker Compose](#déploiement-avec-docker-compose)
4. [Push vers Docker Hub](#push-vers-docker-hub)
5. [Optimisations](#optimisations)
6. [Dépannage](#dépannage)

## Prérequis

### Logiciels requis
- Docker Engine 20.10+
- Docker Compose 2.0+
- Git
- Compte Docker Hub (optionnel pour push)

### Vérification de l'installation
```bash
docker --version
docker-compose --version
git --version
```

## Configuration Initiale

### 1. Cloner le repository
```bash
git clone https://github.com/tclaude80/VacanceIA-Prototype.git
cd VacanceIA-Prototype
```

### 2. Configuration des variables d'environnement

Copiez le fichier d'exemple:
```bash
cp .env.example .env
```

Modifiez `.env` avec vos propres valeurs:
```env
# Database
POSTGRES_USER=vacanceia
POSTGRES_PASSWORD=your_secure_password
POSTGRES_DB=vacanceia

# Redis
REDIS_PASSWORD=your_redis_password

# API Keys
ANTHROPIC_API_KEY=your_anthropic_key
OPENAI_API_KEY=your_openai_key

# Security
SECRET_KEY=your_secret_key_here
JWT_SECRET=your_jwt_secret
```

## Déploiement avec Docker Compose

### Démarrage des services

#### Mode développement
```bash
# Construire et démarrer tous les services
docker-compose up --build

# En arrière-plan
docker-compose up -d --build
```

#### Mode production
```bash
# Utiliser les builds optimisées
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Vérification des services
```bash
# Vérifier l'état des containers
docker-compose ps

# Voir les logs
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs -f backend
```

### Accès aux services
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Documentation: http://localhost:8000/docs
- PostgreSQL: localhost:5432
- Redis: localhost:6379

## Push vers Docker Hub

### 1. Connexion à Docker Hub
```bash
docker login
```

### 2. Build et tag des images

#### Backend
```bash
# Build
docker build -t tclaude80/vacanceia:backend-latest ./backend

# Tag avec version
docker tag tclaude80/vacanceia:backend-latest tclaude80/vacanceia:backend-v1.0.0

# Push
docker push tclaude80/vacanceia:backend-latest
docker push tclaude80/vacanceia:backend-v1.0.0
```

#### Frontend
```bash
# Build
docker build -t tclaude80/vacanceia:frontend-latest ./frontend

# Tag avec version
docker tag tclaude80/vacanceia:frontend-latest tclaude80/vacanceia:frontend-v1.0.0

# Push
docker push tclaude80/vacanceia:frontend-latest
docker push tclaude80/vacanceia:frontend-v1.0.0
```

### 3. Script automatisé

Créez un fichier `deploy.sh`:
```bash
#!/bin/bash

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: ./deploy.sh <version>"
    exit 1
fi

# Build et push backend
docker build -t tclaude80/vacanceia:backend-$VERSION ./backend
docker tag tclaude80/vacanceia:backend-$VERSION tclaude80/vacanceia:backend-latest
docker push tclaude80/vacanceia:backend-$VERSION
docker push tclaude80/vacanceia:backend-latest

# Build et push frontend
docker build -t tclaude80/vacanceia:frontend-$VERSION ./frontend
docker tag tclaude80/vacanceia:frontend-$VERSION tclaude80/vacanceia:frontend-latest
docker push tclaude80/vacanceia:frontend-$VERSION
docker push tclaude80/vacanceia:frontend-latest

echo "Deployment completed for version $VERSION"
```

Utilisation:
```bash
chmod +x deploy.sh
./deploy.sh v1.0.0
```

## Optimisations

### Build Multi-stage pour Production

Le backend utilise déjà un build optimisé. Pour le frontend en production:

Créez `frontend/Dockerfile.prod`:
```dockerfile
# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Utilisation du cache
```bash
# Build avec cache
docker-compose build --parallel

# Sans cache (build propre)
docker-compose build --no-cache
```

### Nettoyage des ressources
```bash
# Arrêter et supprimer les containers
docker-compose down

# Supprimer aussi les volumes
docker-compose down -v

# Nettoyer les images non utilisées
docker image prune -a
```

## Dépannage

### Le container ne démarre pas
```bash
# Vérifier les logs
docker-compose logs backend

# Vérifier la configuration
docker-compose config

# Redémarrer un service
docker-compose restart backend
```

### Problèmes de connexion à la base de données
```bash
# Vérifier que PostgreSQL est prêt
docker-compose exec postgres pg_isready -U vacanceia

# Se connecter à la base
docker-compose exec postgres psql -U vacanceia -d vacanceia
```

### Problèmes de permissions
```bash
# Reconstruire avec les bonnes permissions
docker-compose build --no-cache backend

# Vérifier l'utilisateur dans le container
docker-compose exec backend whoami
```

### Erreurs de mémoire

Augmentez les ressources Docker:
- Docker Desktop: Settings > Resources > Memory
- Linux: Modifiez `/etc/docker/daemon.json`

### Logs détaillés
```bash
# Activer le debug
export COMPOSE_LOG_LEVEL=DEBUG
docker-compose up
```

## Commandes Utiles

### Gestion des containers
```bash
# Lister tous les containers
docker ps -a

# Entrer dans un container
docker-compose exec backend bash

# Copier des fichiers
docker cp local-file.txt container_name:/app/

# Statistiques des containers
docker stats
```

### Base de données
```bash
# Backup
docker-compose exec postgres pg_dump -U vacanceia vacanceia > backup.sql

# Restore
docker-compose exec -T postgres psql -U vacanceia vacanceia < backup.sql
```

### Monitoring
```bash
# Surveiller les ressources
docker-compose top

# Logs en temps réel
docker-compose logs -f --tail=100
```

## Support

Pour plus d'informations:
- Documentation: `/docs`
- Issues: https://github.com/tclaude80/VacanceIA-Prototype/issues
- Docker Hub: https://hub.docker.com/r/tclaude80/vacanceia
