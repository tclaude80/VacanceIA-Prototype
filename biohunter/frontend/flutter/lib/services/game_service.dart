import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/question_model.dart';

class GameService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QuestionModel> _currentQuestions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  int _timeRemaining = 90;
  bool _isGameActive = false;

  List<QuestionModel> get currentQuestions => _currentQuestions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get correctAnswers => _correctAnswers;
  int get timeRemaining => _timeRemaining;
  bool get isGameActive => _isGameActive;

  QuestionModel? get currentQuestion {
    if (_currentQuestionIndex < _currentQuestions.length) {
      return _currentQuestions[_currentQuestionIndex];
    }
    return null;
  }

  // Charger des questions pour un module
  Future<void> loadQuestions(String module, {int count = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection('Questions')
          .where('module', isEqualTo: module)
          .limit(count)
          .get();

      _currentQuestions = querySnapshot.docs
          .map((doc) => QuestionModel.fromMap(doc.data(), doc.id))
          .toList();

      _currentQuestions.shuffle();
      _currentQuestionIndex = 0;
      _score = 0;
      _correctAnswers = 0;
      _timeRemaining = 90;
      _isGameActive = true;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading questions: $e');
    }
  }

  // Répondre à une question
  Future<bool> answerQuestion(int selectedIndex) async {
    if (currentQuestion == null) return false;

    final isCorrect = currentQuestion!.isCorrect(selectedIndex);

    if (isCorrect) {
      _correctAnswers++;
      _score += 10; // 10 points par bonne réponse

      // Bonus de temps
      if (_timeRemaining > 60) {
        _score += 5;
      }
    }

    notifyListeners();
    return isCorrect;
  }

  // Passer à la question suivante
  void nextQuestion() {
    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      endGame();
    }
  }

  // Décrémenter le temps
  void decrementTime() {
    if (_timeRemaining > 0) {
      _timeRemaining--;
      notifyListeners();

      if (_timeRemaining == 0) {
        endGame();
      }
    }
  }

  // Terminer le jeu
  Future<void> endGame() async {
    _isGameActive = false;
    notifyListeners();
  }

  // Enregistrer le score
  Future<void> saveScore(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('YOUR_CLOUD_FUNCTION_URL/score'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'score': _score,
          'sessionData': {
            'questionsAnswered': _currentQuestionIndex + 1,
            'correctAnswers': _correctAnswers,
            'timeSpent': 90 - _timeRemaining,
          }
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Score saved successfully');
      }
    } catch (e) {
      debugPrint('Error saving score: $e');
    }
  }

  // Réinitialiser le jeu
  void resetGame() {
    _currentQuestions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _timeRemaining = 90;
    _isGameActive = false;
    notifyListeners();
  }

  // Charger la question du jour
  Future<QuestionModel?> loadDailyQuestion() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final doc = await _firestore.collection('DailyMicroscope').doc(today).get();

      if (doc.exists) {
        final questionId = doc.data()?['questionId'];
        if (questionId != null) {
          final questionDoc = await _firestore.collection('Questions').doc(questionId).get();
          if (questionDoc.exists) {
            return QuestionModel.fromMap(questionDoc.data()!, questionDoc.id);
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error loading daily question: $e');
      return null;
    }
  }
}
