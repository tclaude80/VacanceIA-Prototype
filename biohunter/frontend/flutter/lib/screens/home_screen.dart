import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/game_service.dart';
import '../services/leaderboard_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final leaderboardService =
        Provider.of<LeaderboardService>(context, listen: false);
    leaderboardService.loadGlobalLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BioHunter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _showProfileDialog(context);
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(context),
          _buildLeaderboardTab(context),
          _buildProfileTab(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Classement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDailyMicroscope(context),
          const SizedBox(height: 24),
          _buildModulesSection(context),
          const SizedBox(height: 24),
          _buildStatsSection(context),
        ],
      ),
    );
  }

  Widget _buildDailyMicroscope(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Microscope du Jour',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Découvrez la question microscopique quotidienne!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to daily question
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Jouer Maintenant'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesSection(BuildContext context) {
    final modules = [
      {
        'title': 'Cellules',
        'icon': Icons.cell_wifi,
        'module': 'cells',
        'color': Colors.green
      },
      {
        'title': 'Parasites',
        'icon': Icons.bug_report,
        'module': 'parasites',
        'color': Colors.red
      },
      {
        'title': 'Microbes',
        'icon': Icons.biotech,
        'module': 'microbes',
        'color': Colors.blue
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modules de Jeu',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final module = modules[index];
            return _buildModuleCard(
              context,
              module['title'] as String,
              module['icon'] as IconData,
              module['module'] as String,
              module['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    String title,
    IconData icon,
    String module,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          final gameService = Provider.of<GameService>(context, listen: false);
          gameService.loadQuestions(module);
          Navigator.of(context).pushNamed('/game');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vos Statistiques',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Bio-Coins',
                  user.bioCoins.toString(),
                  Icons.monetization_on,
                ),
                _buildStatItem(
                  context,
                  'Score Total',
                  user.totalScore.toString(),
                  Icons.star,
                ),
                _buildStatItem(
                  context,
                  'Parties',
                  user.gamesPlayed.toString(),
                  Icons.gamepad,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildLeaderboardTab(BuildContext context) {
    final leaderboardService = Provider.of<LeaderboardService>(context);

    return RefreshIndicator(
      onRefresh: () => leaderboardService.loadGlobalLeaderboard(),
      child: leaderboardService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: leaderboardService.globalLeaderboard.length,
              itemBuilder: (context, index) {
                final entry = leaderboardService.globalLeaderboard[index];
                return _buildLeaderboardItem(context, entry);
              },
            ),
    );
  }

  Widget _buildLeaderboardItem(
    BuildContext context,
    dynamic entry,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRankColor(entry.rank),
          child: Text(
            '#${entry.rank}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(entry.username),
        trailing: Text(
          '${entry.score} pts',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey;
    if (rank == 3) return Colors.brown;
    return Colors.blue;
  }

  Widget _buildProfileTab(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Center(child: Text('Chargement...'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage:
                user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
            child: user.photoUrl == null
                ? const Icon(Icons.person, size: 60)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.username,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Déconnexion'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    // TODO: Implement profile dialog
  }
}
