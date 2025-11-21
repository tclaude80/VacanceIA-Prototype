import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      await _loadUserData(firebaseUser.uid);
    } else {
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('Users').doc(uid).get();
      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data()!, uid);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  // Connexion avec Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(googleProvider);

      if (userCredential.user != null) {
        await _createOrUpdateUser(userCredential.user!);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Connexion avec Apple
  Future<bool> signInWithApple() async {
    try {
      _isLoading = true;
      notifyListeners();

      final appleProvider = AppleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(appleProvider);

      if (userCredential.user != null) {
        await _createOrUpdateUser(userCredential.user!);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error signing in with Apple: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Connexion anonyme (pour testing)
  Future<bool> signInAnonymously() async {
    try {
      _isLoading = true;
      notifyListeners();

      final UserCredential userCredential = await _auth.signInAnonymously();

      if (userCredential.user != null) {
        await _createOrUpdateUser(userCredential.user!);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error signing in anonymously: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _createOrUpdateUser(User firebaseUser) async {
    final userRef = _firestore.collection('Users').doc(firebaseUser.uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      // Créer nouveau profil
      final newUser = UserModel(
        id: firebaseUser.uid,
        username: firebaseUser.displayName ?? 'Player${DateTime.now().millisecondsSinceEpoch}',
        email: firebaseUser.email ?? '',
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );

      await userRef.set(newUser.toMap());
      _currentUser = newUser;
    } else {
      _currentUser = UserModel.fromMap(doc.data()!, firebaseUser.uid);
    }

    notifyListeners();
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Mettre à jour le profil
  Future<void> updateProfile({
    String? username,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return;

    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      await _firestore.collection('Users').doc(_currentUser!.id).update(updates);

      _currentUser = _currentUser!.copyWith(
        username: username,
        photoUrl: photoUrl,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }
  }

  // Ajouter des bio-coins
  Future<void> addBioCoins(int amount) async {
    if (_currentUser == null) return;

    try {
      await _firestore.collection('Users').doc(_currentUser!.id).update({
        'bioCoins': FieldValue.increment(amount),
      });

      _currentUser = _currentUser!.copyWith(
        bioCoins: _currentUser!.bioCoins + amount,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding bio-coins: $e');
    }
  }
}
