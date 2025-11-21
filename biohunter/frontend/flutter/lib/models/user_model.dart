class UserModel {
  final String id;
  final String username;
  final String email;
  final String? photoUrl;
  final int bioCoins;
  final int crystalCells;
  final int totalScore;
  final int gamesPlayed;
  final int currentStreak;
  final int maxStreak;
  final List<String> achievements;
  final Map<String, dynamic> rewards;
  final DateTime? lastPlayedAt;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.photoUrl,
    this.bioCoins = 0,
    this.crystalCells = 0,
    this.totalScore = 0,
    this.gamesPlayed = 0,
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.achievements = const [],
    this.rewards = const {},
    this.lastPlayedAt,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      bioCoins: map['bioCoins'] ?? 0,
      crystalCells: map['crystalCells'] ?? 0,
      totalScore: map['totalScore'] ?? 0,
      gamesPlayed: map['gamesPlayed'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      maxStreak: map['maxStreak'] ?? 0,
      achievements: List<String>.from(map['achievements'] ?? []),
      rewards: Map<String, dynamic>.from(map['rewards'] ?? {}),
      lastPlayedAt: map['lastPlayedAt']?.toDate(),
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'bioCoins': bioCoins,
      'crystalCells': crystalCells,
      'totalScore': totalScore,
      'gamesPlayed': gamesPlayed,
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'achievements': achievements,
      'rewards': rewards,
      'lastPlayedAt': lastPlayedAt,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? photoUrl,
    int? bioCoins,
    int? crystalCells,
    int? totalScore,
    int? gamesPlayed,
    int? currentStreak,
    int? maxStreak,
    List<String>? achievements,
    Map<String, dynamic>? rewards,
    DateTime? lastPlayedAt,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bioCoins: bioCoins ?? this.bioCoins,
      crystalCells: crystalCells ?? this.crystalCells,
      totalScore: totalScore ?? this.totalScore,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      achievements: achievements ?? this.achievements,
      rewards: rewards ?? this.rewards,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      createdAt: createdAt,
    );
  }
}
