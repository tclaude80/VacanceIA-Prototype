# 🦠 BioHunter - Quiz Microscopique Viral

## 🎯 Vision du Projet

**BioHunter** est un jeu éducatif grand public qui transforme l'apprentissage de la microbiologie en une expérience de quiz addictive. Les joueurs chassent des parasites et cellules rares en mode quiz, avec des images microscopiques authentiques.

### Public Cible
- Adolescents (15-18 ans)
- Jeunes adultes (20-35 ans)
- Adultes curieux de science, néophytes en biologie

## 🎮 Gameplay Core

### Mécanique Principale
- **Quiz de 90 secondes** : Image de microscopie → 4 réponses multiples → Feedback instantané → Récompense aléatoire
- **Session cible** : 10-15 minutes (sweet spot mobile)
- **Boucle addictive** : Question → Réponse → Particles+Sound → Reward (coins/XP) → Question suivante SANS friction

### Système de Progression
- **5 niveaux** par module
- **3 modules MVP** :
  - 🧬 Cellules
  - 🦠 Parasites
  - 🔬 Microbes
- Arbre de déblocage séquentiel

## 🏗️ Architecture Technique

### Stack Recommandé
- **Frontend** : Flutter + Flame (cross-platform) OU Unity 2D
- **Backend** : Firebase (Firestore + Auth + Cloud Functions)
- **Base de données** : Firestore avec collections :
  - Users
  - Questions
  - Leaderboards
  - Achievements
  - GameSessions
  - TikTokChallenges

### Scalabilité
- **Cible** : 1M MAU en Semaine 12
- **Backend** : Serverless auto-scale Firebase (500 ops/sec baseline)

## 🎨 UI/UX Design

### Design Language
- Style Neomorphic inspiré de Genshin Impact meets Duolingo
- Couleurs biologiques (verts/bleus/violets)
- Animations fluides 60fps

### Accessibilité
- Mode Dark/Light systématique
- Filtres couleur pour daltonisme
- Tailles de texte ajustables
- Haptic feedback toggle iOS

### Animations & Juice
- Explosions de particules pour bonnes réponses (5+ sprites)
- SFX satisfaisants (ding/whoosh/cash register)
- Animation de level up dramatique (2s)

## 🎯 Gamification

### Engagement Quotidien
- **Daily Microscope** (8h AM, timezone utilisateur)
- **Streak multiplier** (2x/5x/10x)
- **Daily Spin Wheel**

### Fonctionnalités Sociales
- Leaderboard global/pays/amis
- Partage screenshot 1-clic
- TikTok challenge tracking intégré

## 💰 Monétisation

### Monnaies In-App
**Bio-Coins** (gratuit) :
- 50 par niveau complété
- 10 par bonne réponse
- Bonus de streak
- 100 coins = 1 gacha pull

**Crystal Cells** (IAP) :
- 3 tiers : $2.99 / $9.99 / $19.99
- Débloque : skins microscopes, boosts XP, niveaux experts
- Revenu cible : €0.80-1.20/MAU

### Publicités
- Rewarded video ads max 5/jour
- Interstitiel optional entre sessions (dismiss après 3s)
- Banner ads bottom si non-premium

## 📊 KPIs & Analytics

### Métriques de Succès
- Rétention D1 > 40%
- Session moyenne > 10 min
- ARPU > €0.80/mois
- IAP conversion 3-5%
- Crash-free > 99.5%

### Tracking
- Firebase Analytics : DAU/MAU, Session Duration, Retention D1/D7/D30
- Conversion rate IAP, Churn rate
- A/B testing : UI variants, gacha timing, notification frequency

## 🚀 Intégration Virale

### TikTok Integration
- **#CellSpotChallenge** : Users filment top scores 30s
- Top 100 = 1000 Crystal Cells
- Score sync Firebase → TikTok API webhook

### Mécanismes de Partage
- Screenshot auto + message pré-rempli Instagram/Twitter/TikTok
- WhatsApp share API
- Copy leaderboard rank to clipboard

## 📁 Structure du Projet

```
biohunter/
├── backend/          # Firebase Cloud Functions
├── frontend/         # Application Flutter
├── assets/           # Images, sons, ressources
│   ├── images/       # Images microscopiques
│   └── sounds/       # Effets sonores
├── docs/             # Documentation
└── README.md
```

## 🛠️ Installation

Voir [QUICKSTART.md](docs/QUICKSTART.md) pour les instructions détaillées.

## 📝 License

MIT License - Voir [LICENSE](../LICENSE)

## 🤝 Contribution

Voir [CONTRIBUTING.md](../CONTRIBUTING.md) pour les guidelines de contribution.

---

🦠 **Made with Flutter & Firebase** | 🔬 **Powered by Real Microscopy**
