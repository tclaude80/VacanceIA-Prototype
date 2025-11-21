import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Icon(
                  Icons.biotech,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  'BioHunter',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Découvrez le monde microscopique\nen vous amusant!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 64),

                // Google Sign In
                ElevatedButton.icon(
                  onPressed: authService.isLoading
                      ? null
                      : () async {
                          final success = await authService.signInWithGoogle();
                          if (success && context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          }
                        },
                  icon: Icon(Icons.login),
                  label: const Text('Connexion avec Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                const SizedBox(height: 16),

                // Apple Sign In
                ElevatedButton.icon(
                  onPressed: authService.isLoading
                      ? null
                      : () async {
                          final success = await authService.signInWithApple();
                          if (success && context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          }
                        },
                  icon: Icon(Icons.apple),
                  label: const Text('Connexion avec Apple'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                const SizedBox(height: 32),

                // Anonymous Sign In (for testing)
                TextButton(
                  onPressed: authService.isLoading
                      ? null
                      : () async {
                          final success = await authService.signInAnonymously();
                          if (success && context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          }
                        },
                  child: Text(
                    'Continuer en mode invité',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                if (authService.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
