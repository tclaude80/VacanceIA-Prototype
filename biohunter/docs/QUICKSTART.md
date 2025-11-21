# 🚀 Guide de Démarrage Rapide - BioHunter

## Prérequis

### Backend (Firebase)
- Node.js 18 ou supérieur
- Firebase CLI
- Un compte Firebase (gratuit)

### Frontend (Flutter)
- Flutter SDK 3.0 ou supérieur
- Android Studio / Xcode (pour le développement mobile)
- VS Code avec extensions Flutter/Dart (recommandé)

## Installation Rapide

### 1. Configuration Firebase

```bash
# Installer Firebase CLI
npm install -g firebase-tools

# Se connecter à Firebase
firebase login

# Initialiser le projet
cd backend/firebase
firebase init
```

Sélectionner :
- Firestore
- Functions
- Hosting (optionnel)

### 2. Déploiement des Cloud Functions

```bash
cd backend/firebase/functions
npm install
firebase deploy --only functions
```

### 3. Configuration Firestore

```bash
# Déployer les règles et index
firebase deploy --only firestore
```

### 4. Configuration Flutter

```bash
cd frontend/flutter

# Installer les dépendances
flutter pub get

# Configurer FlutterFire
flutterfire configure
```

Cette commande va :
- Créer votre projet Firebase
- Télécharger les fichiers de configuration
- Mettre à jour `firebase_config.dart`

### 5. Lancer l'application

```bash
# Mode développement
flutter run

# Pour Android
flutter run -d android

# Pour iOS
flutter run -d ios

# Pour Web
flutter run -d chrome
```

## Configuration des Variables d'Environnement

### Backend

Créer un fichier `.env` dans `backend/firebase/functions/` :

```env
FIREBASE_PROJECT_ID=your-project-id
TIKTOK_API_KEY=your-tiktok-api-key
```

### Frontend

Les configurations Firebase sont générées automatiquement par `flutterfire configure`.

## Ajout de Questions de Quiz

### Via Firebase Console

1. Aller sur https://console.firebase.google.com
2. Sélectionner votre projet
3. Aller dans Firestore Database
4. Créer une collection `Questions`
5. Ajouter des documents avec cette structure :

```json
{
  "module": "cells",
  "imageUrl": "https://example.com/cell-image.jpg",
  "question": "Qu'est-ce que cette cellule ?",
  "options": [
    "Globule rouge",
    "Globule blanc",
    "Plaquette",
    "Neurone"
  ],
  "correctAnswerIndex": 0,
  "difficulty": "easy",
  "level": 1,
  "explanation": "C'est un globule rouge qui transporte l'oxygène."
}
```

### Via Script (Bulk Import)

Créer un fichier `backend/scripts/import_questions.js` et utiliser le Firebase Admin SDK.

## Tests

### Backend

```bash
cd backend/firebase/functions
npm test
```

### Frontend

```bash
cd frontend/flutter

# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test
```

## Build de Production

### Android

```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## Déploiement

### Firebase Hosting (Web)

```bash
# Build
flutter build web

# Copier dans le dossier public de Firebase
cp -r build/web/* backend/firebase/public/

# Déployer
cd backend/firebase
firebase deploy --only hosting
```

### Google Play Store / App Store

Suivre les guides officiels de Flutter :
- [Android](https://docs.flutter.dev/deployment/android)
- [iOS](https://docs.flutter.dev/deployment/ios)

## Dépannage

### Erreur Firebase

```bash
# Réinstaller les dépendances
cd backend/firebase/functions
rm -rf node_modules package-lock.json
npm install
```

### Erreur Flutter

```bash
# Nettoyer le cache
flutter clean
flutter pub get

# Reconfigurer Firebase
flutterfire configure
```

## Support

Pour plus d'aide, consulter :
- [Documentation Flutter](https://docs.flutter.dev)
- [Documentation Firebase](https://firebase.google.com/docs)
- Issues GitHub du projet

---

**Bon développement ! 🦠🔬**
