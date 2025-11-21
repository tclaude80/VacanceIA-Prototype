import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  final String userId;
  final String username;
  final int score;
  final int rank;
  final String? photoUrl;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.score,
    required this.rank,
    this.photoUrl,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map, int rank) {
    return LeaderboardEntry(
      userId: map['userId'] ?? '',
      username: map['username'] ?? 'Player',
      score: map['score'] ?? 0,
      rank: rank,
      photoUrl: map['photoUrl'],
    );
  }
}

class LeaderboardService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<LeaderboardEntry> _globalLeaderboard = [];
  List<LeaderboardEntry> _friendsLeaderboard = [];
  LeaderboardEntry? _userRank;
  bool _isLoading = false;

  List<LeaderboardEntry> get globalLeaderboard => _globalLeaderboard;
  List<LeaderboardEntry> get friendsLeaderboard => _friendsLeaderboard;
  LeaderboardEntry? get userRank => _userRank;
  bool get isLoading => _isLoading;

  // Charger le leaderboard global
  Future<void> loadGlobalLeaderboard({int limit = 100}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('Leaderboards')
          .doc('global')
          .collection('rankings')
          .orderBy('score', descending: true)
          .limit(limit)
          .get();

      _globalLeaderboard = snapshot.docs
          .asMap()
          .entries
          .map((entry) => LeaderboardEntry.fromMap(
                entry.value.data(),
                entry.key + 1,
              ))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading global leaderboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger le leaderboard des amis
  Future<void> loadFriendsLeaderboard(String userId, List<String> friendIds) async {
    try {
      _isLoading = true;
      notifyListeners();

      final friendIdsWithUser = [...friendIds, userId];

      final snapshot = await _firestore
          .collection('Leaderboards')
          .doc('global')
          .collection('rankings')
          .where(FieldPath.documentId, whereIn: friendIdsWithUser)
          .get();

      final entries = snapshot.docs
          .map((doc) => LeaderboardEntry.fromMap(doc.data(), 0))
          .toList();

      entries.sort((a, b) => b.score.compareTo(a.score));

      _friendsLeaderboard = entries
          .asMap()
          .entries
          .map((entry) => LeaderboardEntry(
                userId: entry.value.userId,
                username: entry.value.username,
                score: entry.value.score,
                rank: entry.key + 1,
                photoUrl: entry.value.photoUrl,
              ))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading friends leaderboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtenir le rang de l'utilisateur
  Future<void> loadUserRank(String userId) async {
    try {
      final userDoc = await _firestore
          .collection('Leaderboards')
          .doc('global')
          .collection('rankings')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        _userRank = null;
        notifyListeners();
        return;
      }

      final userData = userDoc.data()!;
      final userScore = userData['score'] as int;

      final higherScoresSnapshot = await _firestore
          .collection('Leaderboards')
          .doc('global')
          .collection('rankings')
          .where('score', isGreaterThan: userScore)
          .get();

      final rank = higherScoresSnapshot.size + 1;

      _userRank = LeaderboardEntry(
        userId: userId,
        username: userData['username'] ?? 'Player',
        score: userScore,
        rank: rank,
        photoUrl: userData['photoUrl'],
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user rank: $e');
    }
  }

  // Écouter les changements en temps réel
  Stream<List<LeaderboardEntry>> watchGlobalLeaderboard({int limit = 100}) {
    return _firestore
        .collection('Leaderboards')
        .doc('global')
        .collection('rankings')
        .orderBy('score', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .asMap()
            .entries
            .map((entry) => LeaderboardEntry.fromMap(
                  entry.value.data(),
                  entry.key + 1,
                ))
            .toList());
  }
}
