# 🚀 Guide de Démarrage Rapide - VacanceIA

## Installation en 5 Minutes

### Prérequis

- Docker & Docker Compose installés
- Git
- (Optionnel) Node.js 18+ et Python 3.11+ pour développement local

### Étape 1 : Cloner le Repository

```bash
git clone https://github.com/tclaude80/VacanceIA-Prototype.git
cd VacanceIA-Prototype
```

### Étape 2 : Configuration

```bash
# Copier le fichier d'environnement
cp .env.example .env

# Éditer .env et ajouter vos clés API
nano .env  # ou vim, code, etc.
```

**Clés API minimales requises :**

- `OPENAI_API_KEY` ou `ANTHROPIC_API_KEY` (pour les agents IA)
- `SECRET_KEY` (générer avec `openssl rand -hex 32`)

### Étape 3 : Lancer l'Application

```bash
# Avec Docker (recommandé)
docker-compose up -d

# Attendre que tous les services soient prêts (~30 secondes)
docker-compose logs -f
```

### Étape 4 : Accéder à l'Application

- **Frontend** : http://localhost:3000
- **API Backend** : http://localhost:8000
- **API Documentation** : http://localhost:8000/api/docs

## Configuration Avancée

### Développement Local (sans Docker)

#### Backend

```bash
cd backend

# Créer environnement virtuel
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Installer dépendances
pip install -r requirements.txt

# Lancer serveur
uvicorn app.main:app --reload --port 8000
```

#### Frontend

```bash
cd frontend

# Installer dépendances
npm install

# Lancer serveur de développement
npm run dev
```

### Base de Données

```bash
# Créer les tables (avec Docker)
docker-compose exec backend alembic upgrade head

# Ou localement
cd backend
alembic upgrade head
```

## Tester l'Application

### 1. Créer un Compte

Allez sur http://localhost:3000 et créez un compte utilisateur.

### 2. Rechercher un Voyage

1. Cliquez sur "Recherche" dans la navigation
2. Entrez une destination (ex: "Tokyo, Japan")
3. Sélectionnez vos dates
4. Définissez votre budget
5. Cliquez sur "Rechercher avec l'IA"

### 3. Générer un Itinéraire

1. Cliquez sur "Mon Itinéraire"
2. Entrez destination et durée
3. Sélectionnez vos intérêts
4. Choisissez votre rythme de voyage
5. Cliquez sur "Générer l'itinéraire avec l'IA"

## Commandes Utiles

### Docker

```bash
# Démarrer tous les services
docker-compose up -d

# Arrêter tous les services
docker-compose down

# Voir les logs
docker-compose logs -f [service_name]

# Reconstruire les images
docker-compose build

# Redémarrer un service spécifique
docker-compose restart backend

# Exécuter une commande dans un container
docker-compose exec backend bash
```

### Tests

```bash
# Backend
cd backend
pytest tests/ -v

# Frontend
cd frontend
npm test
```

### Linting & Formatting

```bash
# Backend
cd backend
black app/
flake8 app/

# Frontend
cd frontend
npm run lint
```

## Dépannage

### Port déjà utilisé

```bash
# Modifier les ports dans docker-compose.yml
# Exemple: changer "3000:3000" en "3001:3000"
```

### Erreur de connexion à la base de données

```bash
# Vérifier que PostgreSQL est démarré
docker-compose ps

# Redémarrer le service
docker-compose restart postgres
```

### Erreur API Key

```bash
# Vérifier que les clés API sont dans .env
cat .env | grep API_KEY

# Redémarrer le backend après modification
docker-compose restart backend
```

### Clear Cache

```bash
# Vider le cache Redis
docker-compose exec redis redis-cli FLUSHALL
```

## Prochaines Étapes

1. 📖 Lire la [Documentation Complète](docs/architecture.md)
2. 🔒 Consulter le [Guide de Sécurité](SECURITY.md)
3. 🤝 Voir le [Guide de Contribution](CONTRIBUTING.md)
4. 🐛 Signaler des bugs via [GitHub Issues](https://github.com/tclaude80/VacanceIA-Prototype/issues)

## APIs Externes (Optionnel)

Pour activer toutes les fonctionnalités, obtenez des clés API pour :

- **Amadeus** (vols & hôtels) : https://developers.amadeus.com/
- **Google Maps** (cartes) : https://developers.google.com/maps
- **OpenWeather** (météo) : https://openweathermap.org/api

## Support

- 💬 [Discussions GitHub](https://github.com/tclaude80/VacanceIA-Prototype/discussions)
- 📧 Email: support@vacanceia.io
- 🐦 Twitter: [@tclaude80](https://twitter.com/tclaude80)

---

**Bon voyage avec VacanceIA ! ✈️🌍**
