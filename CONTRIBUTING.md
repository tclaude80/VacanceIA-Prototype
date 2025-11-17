# Guide de Contribution - VacanceIA

Merci de votre intérêt pour contribuer à VacanceIA ! 🎉

## Code de Conduite

Ce projet adhère au [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/). En participant, vous vous engagez à respecter ses termes.

## Comment Contribuer

### Signaler un Bug 🐛

1. Vérifiez que le bug n'a pas déjà été signalé dans [Issues](https://github.com/tclaude80/VacanceIA-Prototype/issues)
2. Créez une nouvelle issue avec le template "Bug Report"
3. Incluez :
   - Description claire du problème
   - Étapes de reproduction
   - Comportement attendu vs réel
   - Screenshots si pertinent
   - Environnement (OS, navigateur, version)

### Proposer une Fonctionnalité ✨

1. Créez une issue avec le template "Feature Request"
2. Décrivez :
   - Le problème que cela résout
   - La solution proposée
   - Les alternatives considérées
   - Impact sur la sécurité/privacy

### Soumettre une Pull Request 📤

1. **Fork** le repository
2. **Clone** votre fork localement
3. **Créez une branche** : `git checkout -b feature/ma-fonctionnalite`
4. **Commitez** vos changements : `git commit -m 'Add: nouvelle fonctionnalité'`
5. **Push** vers la branche : `git push origin feature/ma-fonctionnalite`
6. Ouvrez une **Pull Request**

## Standards de Code

### Backend (Python)

```bash
# Formatting
black backend/app

# Linting
flake8 backend/app

# Type checking
mypy backend/app

# Tests
pytest backend/tests -v --cov=app
```

**Style Guide:**
- Suivre [PEP 8](https://www.python.org/dev/peps/pep-0008/)
- Type hints obligatoires
- Docstrings pour fonctions publiques
- Max line length: 88 (Black default)

### Frontend (TypeScript/React)

```bash
# Linting
npm run lint

# Type checking
npm run type-check

# Tests
npm test
```

**Style Guide:**
- Functional components + hooks
- TypeScript strict mode
- Props typing obligatoire
- Named exports pour components

### Commits

Suivre [Conventional Commits](https://www.conventionalcommits.org/) :

```
feat: ajout recherche multi-destinations
fix: correction timeout API Amadeus
docs: mise à jour README sécurité
style: formatage code itinerary agent
refactor: optimisation cache Redis
test: ajout tests e2e recherche
chore: mise à jour dépendances
```

## Structure des PR

### Title
```
[Type] Description courte (max 50 caractères)
```

### Description
```markdown
## Description
Brève description du changement

## Motivation et Contexte
Pourquoi ce changement est nécessaire ?

## Types de Changements
- [ ] Bug fix (non-breaking change)
- [ ] Nouvelle fonctionnalité (non-breaking change)
- [ ] Breaking change
- [ ] Documentation

## Checklist
- [ ] Tests ajoutés/mis à jour
- [ ] Documentation mise à jour
- [ ] Code linté et formaté
- [ ] Pas d'impact sécurité négatif
- [ ] Conformité RGPD vérifiée

## Tests
Comment tester ce changement ?

## Screenshots (si applicable)
```

## Développement Local

### Setup Initial

```bash
# Cloner le repo
git clone https://github.com/tclaude80/VacanceIA-Prototype.git
cd VacanceIA-Prototype

# Copier .env
cp .env.example .env
# Éditer .env avec vos clés API

# Lancer avec Docker
docker-compose up -d

# Ou manuellement:

# Backend
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload

# Frontend
cd frontend
npm install
npm run dev
```

### Tests

```bash
# Backend tests
cd backend
pytest tests/ -v --cov=app --cov-report=html

# Frontend tests
cd frontend
npm test
npm run test:e2e
```

## Priorités de Contribution

### 🔴 Haute Priorité
- Sécurité et vulnérabilités
- Bugs critiques (crashes, data loss)
- Performance issues

### 🟡 Moyenne Priorité
- Nouvelles fonctionnalités
- Améliorations UX/UI
- Documentation

### 🟢 Basse Priorité
- Refactoring
- Optimisations mineures
- Traductions

## Zones de Contribution

### Backend
- [ ] Nouveaux agents IA
- [ ] Intégration APIs externes
- [ ] Optimisation algorithmes
- [ ] Tests unitaires/intégration

### Frontend
- [ ] Nouveaux composants UI
- [ ] Amélioration accessibilité
- [ ] Responsive design
- [ ] Tests E2E

### Infrastructure
- [ ] Scripts deployment
- [ ] Monitoring dashboards
- [ ] CI/CD workflows
- [ ] Docker optimizations

### Documentation
- [ ] Guides utilisateur
- [ ] API documentation
- [ ] Tutoriels
- [ ] Traductions

## Sécurité

**NE PAS** committer :
- Clés API ou secrets
- Credentials de base de données
- Tokens d'accès
- Informations personnelles

**TOUJOURS** :
- Utiliser `.env` pour secrets
- Scanner dependencies (Snyk, Dependabot)
- Valider inputs utilisateur
- Tester autorisation/authentification

## Revue de Code

### Attentes

- Réponse dans 48h (jours ouvrés)
- Au moins 1 approbation requise
- Tous les tests doivent passer
- Pas de conflits avec `main`

### Critères

- ✅ Code propre et lisible
- ✅ Tests adéquats
- ✅ Documentation claire
- ✅ Pas de régression
- ✅ Sécurité respectée
- ✅ Performance acceptable

## Licence

En contribuant, vous acceptez que vos contributions soient licenciées sous [MIT License](LICENSE).

## Questions ?

- 💬 [Discussions GitHub](https://github.com/tclaude80/VacanceIA-Prototype/discussions)
- 📧 Email: support@vacanceia.io
- 🐦 Twitter: [@tclaude80](https://twitter.com/tclaude80)

---

**Merci de contribuer à rendre le voyage plus accessible et responsable ! ✈️🌍**
