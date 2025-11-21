import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/game_service.dart';
import '../services/auth_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer? _timer;
  int? _selectedAnswer;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final gameService = Provider.of<GameService>(context, listen: false);
      if (gameService.isGameActive) {
        gameService.decrementTime();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameService = Provider.of<GameService>(context);
    final question = gameService.currentQuestion;

    if (question == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: Text('Aucune question disponible'),
        ),
      );
    }

    if (!gameService.isGameActive) {
      return _buildGameOverScreen(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${gameService.currentQuestionIndex + 1}/${gameService.currentQuestions.length}',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${gameService.timeRemaining}s',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Score: ${gameService.score}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Bonnes réponses: ${gameService.correctAnswers}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Image microscopique
            Expanded(
              flex: 2,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: question.imageUrl.isNotEmpty
                    ? Image.network(
                        question.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.biotech, size: 80),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.biotech, size: 80),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Question
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Options
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildOptionButton(
                      context,
                      question.options[index],
                      index,
                      question.correctAnswerIndex,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String option,
    int index,
    int correctIndex,
  ) {
    Color? buttonColor;
    if (_showResult && _selectedAnswer != null) {
      if (index == correctIndex) {
        buttonColor = Colors.green;
      } else if (index == _selectedAnswer) {
        buttonColor = Colors.red;
      }
    }

    return ElevatedButton(
      onPressed: _showResult
          ? null
          : () async {
              setState(() {
                _selectedAnswer = index;
                _showResult = true;
              });

              final gameService =
                  Provider.of<GameService>(context, listen: false);
              await gameService.answerQuestion(index);

              await Future.delayed(const Duration(seconds: 2));

              if (mounted) {
                setState(() {
                  _selectedAnswer = null;
                  _showResult = false;
                });
                gameService.nextQuestion();
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        option,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGameOverScreen(BuildContext context) {
    final gameService = Provider.of<GameService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 100,
                  color: Colors.amber,
                ),
                const SizedBox(height: 24),
                Text(
                  'Partie Terminée!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 48),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildStatRow(
                          'Score Final',
                          '${gameService.score} points',
                        ),
                        const Divider(),
                        _buildStatRow(
                          'Bonnes Réponses',
                          '${gameService.correctAnswers}/${gameService.currentQuestions.length}',
                        ),
                        const Divider(),
                        _buildStatRow(
                          'Bio-Coins Gagnés',
                          '+${gameService.score}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (authService.currentUser != null) {
                      await gameService.saveScore(authService.currentUser!.id);
                      await authService.addBioCoins(gameService.score);
                    }
                    gameService.resetGame();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Retour à l\'Accueil'),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Share score
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('Partager le Score'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
