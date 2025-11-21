# 🏗️ Architecture BioHunter

## Vue d'Ensemble

BioHunter utilise une architecture client-serveur avec :
- **Frontend** : Flutter (iOS, Android, Web)
- **Backend** : Firebase (Serverless)
- **Base de données** : Cloud Firestore (NoSQL)
- **Authentification** : Firebase Auth
- **Stockage** : Firebase Storage

```
┌─────────────────────────────────────────────────┐
│                   FRONTEND                      │
│              Flutter + Flame                    │
│                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │  Screens │  │ Widgets  │  │ Services │     │
│  └──────────┘  └──────────┘  └──────────┘     │
│       │             │              │            │
│       └─────────────┴──────────────┘            │
│                     │                           │
└─────────────────────┼───────────────────────────┘
                      │
                      │ HTTPS / WebSocket
                      │
┌─────────────────────┼───────────────────────────┐
│                     │       BACKEND             │
│              Firebase Services                  │
│                     │                           │
│  ┌──────────────────┴──────────────────┐       │
│  │      Cloud Functions (Node.js)      │       │
│  │  • API Endpoints                     │       │
│  │  • Score Management                  │       │
│  │  • Leaderboard Updates               │       │
│  │  • Gacha System                      │       │
│  └──────────────────┬──────────────────┘       │
│                     │                           │
│  ┌─────────────────┴──────────────────┐        │
│  │         Cloud Firestore             │        │
│  │  Collections:                       │        │
│  │  • Users                            │        │
│  │  • Questions                        │        │
│  │  • GameSessions                     │        │
│  │  • Leaderboards                     │        │
│  │  • Achievements                     │        │
│  └─────────────────────────────────────┘        │
│                                                 │
│  ┌─────────────────────────────────────┐        │
│  │      Firebase Authentication        │        │
│  │  • Google Sign-In                   │        │
│  │  • Apple Sign-In                    │        │
│  │  • Anonymous Auth                   │        │
│  └─────────────────────────────────────┘        │
│                                                 │
│  ┌─────────────────────────────────────┐        │
│  │       Firebase Storage              │        │
│  │  • Microscope Images                │        │
│  │  • User Avatars                     │        │
│  │  • Assets                           │        │
│  └─────────────────────────────────────┘        │
└─────────────────────────────────────────────────┘
```

## Structure Frontend (Flutter)

### Organisation des Dossiers

```
lib/
├── main.dart                  # Point d'entrée
├── config/
│   ├── theme.dart            # Thèmes Light/Dark
│   └── firebase_config.dart  # Configuration Firebase
├── models/
│   ├── user_model.dart       # Modèle utilisateur
│   ├── question_model.dart   # Modèle question
│   └── leaderboard_model.dart
├── services/
│   ├── auth_service.dart     # Gestion authentification
│   ├── game_service.dart     # Logique de jeu
│   ├── leaderboard_service.dart
│   └── api_service.dart      # Appels API
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── game_screen.dart
│   └── leaderboard_screen.dart
├── widgets/
│   ├── question_card.dart
│   ├── answer_button.dart
│   └── particle_effect.dart
└── utils/
    ├── constants.dart
    └── helpers.dart
```

### Pattern d'Architecture : Provider

BioHunter utilise **Provider** pour la gestion d'état :

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthService()),
    ChangeNotifierProvider(create: (_) => GameService()),
    ChangeNotifierProvider(create: (_) => LeaderboardService()),
  ],
  child: MaterialApp(...)
)
```

### Flux de Données

1. **User Action** → Widget
2. Widget → **Provider Service**
3. Service → **Firebase API**
4. Firebase → **Service (update state)**
5. Service → **notifyListeners()**
6. **Widget rebuilds** automatiquement

## Structure Backend (Firebase)

### Cloud Functions

```javascript
// Endpoints principaux
exports.api = functions.https.onRequest(app)

// Routes
POST   /score              // Enregistrer un score
GET    /leaderboard        // Récupérer le classement
POST   /gacha-pull         // Tirer un gacha
GET    /daily-microscope   // Question du jour
```

### Collections Firestore

#### Users

```javascript
{
  userId: "string",
  username: "string",
  email: "string",
  photoUrl: "string",
  bioCoins: number,
  crystalCells: number,
  totalScore: number,
  gamesPlayed: number,
  currentStreak: number,
  maxStreak: number,
  achievements: ["achievement_id"],
  rewards: {
    skins: ["skin_id"],
    boosts: ["boost_id"]
  },
  lastPlayedAt: timestamp,
  createdAt: timestamp
}
```

#### Questions

```javascript
{
  questionId: "string",
  module: "cells|parasites|microbes",
  imageUrl: "string",
  question: "string",
  options: ["option1", "option2", "option3", "option4"],
  correctAnswerIndex: number,
  difficulty: "easy|medium|hard|expert|daily",
  level: number,
  explanation: "string",
  metadata: {}
}
```

#### GameSessions

```javascript
{
  sessionId: "string",
  userId: "string",
  score: number,
  questionsAnswered: number,
  correctAnswers: number,
  timeSpent: number,
  timestamp: timestamp
}
```

#### Leaderboards/{type}/rankings

```javascript
{
  userId: "string",
  username: "string",
  score: number,
  updatedAt: timestamp
}
```

### Sécurité (Firestore Rules)

- **Users** : Lecture publique, écriture propriétaire uniquement
- **Questions** : Lecture publique, écriture admin uniquement
- **GameSessions** : Création par propriétaire, lecture propriétaire
- **Leaderboards** : Lecture publique, écriture Cloud Functions uniquement

### Triggers & Scheduled Functions

```javascript
// Nettoyer les anciennes sessions (toutes les 24h)
exports.cleanupOldSessions = functions.pubsub
  .schedule('every 24 hours')
  .onRun(...)

// Vérifier les achievements (onCreate GameSession)
exports.checkAchievements = functions.firestore
  .document('GameSessions/{sessionId}')
  .onCreate(...)
```

## Flux de Jeu Complet

### 1. Démarrage de Partie

```
User clicks "Play"
  → GameService.loadQuestions(module)
  → Firestore query Questions
  → Questions loaded & shuffled
  → Game starts (90s timer)
```

### 2. Question-Réponse

```
User selects answer
  → GameService.answerQuestion(index)
  → Check if correct
  → Update score locally
  → Show feedback (particles + sound)
  → Delay 2s
  → Next question or End game
```

### 3. Fin de Partie

```
Game ends (time up or all questions done)
  → GameService.endGame()
  → Call Cloud Function POST /score
  → Update Firestore (Users, GameSessions, Leaderboards)
  → Trigger checkAchievements
  → Return to Home with updated stats
```

## Scalabilité

### Performances Cibles

- **500 ops/sec** baseline
- **1M MAU** en Semaine 12
- **Latence** < 100ms pour API calls
- **Crash-free** > 99.5%

### Optimisations

1. **Frontend**
   - Caching images (cached_network_image)
   - Lazy loading questions
   - Offline support avec local storage

2. **Backend**
   - Firestore indexes optimisés
   - Cloud Functions auto-scaling
   - CDN pour images (Firebase Storage)
   - Batch writes pour leaderboards

3. **Base de Données**
   - Dénormalisation (user stats dans Users)
   - Snapshots horaires leaderboards
   - Pagination avec curseurs

## Monitoring & Analytics

- **Firebase Analytics** : DAU, MAU, Retention
- **Crashlytics** : Crash reports
- **Performance Monitoring** : API latency
- **A/B Testing** : UI variants, gacha rates

## Intégrations Externes

### TikTok API

```
User completes challenge
  → POST to TikTok webhook
  → Verify score
  → Award Crystal Cells
  → Update leaderboard
```

### Social Sharing

- **Share Plus** : Native sharing
- **Screenshot** + pre-filled text
- Deeplinks pour invite friends

---

**Architecture évolutive, performante et scalable pour 1M+ utilisateurs 🚀**
