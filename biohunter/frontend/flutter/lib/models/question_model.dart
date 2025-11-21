class QuestionModel {
  final String id;
  final String module; // 'cells', 'parasites', 'microbes'
  final String imageUrl;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String difficulty; // 'easy', 'medium', 'hard', 'expert', 'daily'
  final int level;
  final String? explanation;
  final Map<String, dynamic>? metadata;

  QuestionModel({
    required this.id,
    required this.module,
    required this.imageUrl,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.difficulty,
    this.level = 1,
    this.explanation,
    this.metadata,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map, String id) {
    return QuestionModel(
      id: id,
      module: map['module'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      difficulty: map['difficulty'] ?? 'easy',
      level: map['level'] ?? 1,
      explanation: map['explanation'],
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'module': module,
      'imageUrl': imageUrl,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'difficulty': difficulty,
      'level': level,
      'explanation': explanation,
      'metadata': metadata,
    };
  }

  bool isCorrect(int selectedIndex) {
    return selectedIndex == correctAnswerIndex;
  }

  String getCorrectAnswer() {
    return options[correctAnswerIndex];
  }
}
