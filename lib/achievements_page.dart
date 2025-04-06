import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _achievements = [];
  List<Map<String, dynamic>> _upcomingAchievements = [];
  Map<String, dynamic> _userStats = {};

  final List<Map<String, dynamic>> _achievementDefinitions = [
    {
      'id': 'first_test',
      'title': 'First Test',
      'description': 'Complete your first test',
      'icon': Icons.assignment_turned_in,
      'color': Colors.blue,
      'threshold': 1,
    },
    {
      'id': 'test_streak_7',
      'title': '7-Day Streak',
      'description': 'Complete tests for 7 consecutive days',
      'icon': Icons.flash_on,
      'color': Colors.orange,
      'threshold': 7,
    },
    {
      'id': 'test_streak_30',
      'title': '30-Day Streak',
      'description': 'Complete tests for 30 consecutive days',
      'icon': Icons.local_fire_department,
      'color': Colors.red,
      'threshold': 30,
    },
    {
      'id': 'weight_goal',
      'title': 'Weight Goal Achieved',
      'description': 'Reach your weight goal',
      'icon': Icons.fitness_center,
      'color': Colors.green,
      'threshold': 1,
    },
    {
      'id': 'body_fat_goal',
      'title': 'Body Fat Goal Achieved',
      'description': 'Reach your body fat percentage goal',
      'icon': Icons.trending_down,
      'color': Colors.purple,
      'threshold': 1,
    },
    {
      'id': 'muscle_mass_goal',
      'title': 'Muscle Mass Goal Achieved',
      'description': 'Reach your muscle mass goal',
      'icon': Icons.fitness_center,
      'color': Colors.amber,
      'threshold': 1,
    },
    {
      'id': 'tests_10',
      'title': '10 Tests Completed',
      'description': 'Complete 10 tests',
      'icon': Icons.assignment_turned_in,
      'color': Colors.teal,
      'threshold': 10,
    },
    {
      'id': 'tests_50',
      'title': '50 Tests Completed',
      'description': 'Complete 50 tests',
      'icon': Icons.assignment_turned_in,
      'color': Colors.indigo,
      'threshold': 50,
    },
    {
      'id': 'tests_100',
      'title': '100 Tests Completed',
      'description': 'Complete 100 tests',
      'icon': Icons.assignment_turned_in,
      'color': Colors.deepPurple,
      'threshold': 100,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Load user stats
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final userData = userDoc.data() ?? {};

        final stats = {
          'testsCompleted': userData['testsCompleted'] ?? 0,
          'currentStreak': userData['currentStreak'] ?? 0,
          'longestStreak': userData['longestStreak'] ?? 0,
          'goalsAchieved': userData['goalsAchieved'] ?? 0,
          'lastTestDate': userData['lastTestDate'] != null
              ? (userData['lastTestDate'] as Timestamp).toDate()
              : null,
        };

        // Load achievements
        final achievementsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('achievements')
            .orderBy('date', descending: true)
            .get();

        final achievements = achievementsSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                  'date': (doc.data()['date'] as Timestamp).toDate(),
                })
            .toList();

        // Mock data for sample app - in a real app this would come from Firestore
        if (achievements.isEmpty) {
          achievements.add({
            'id': 'first_test',
            'title': 'First Test',
            'description': 'Complete your first test',
            'date': DateTime.now().subtract(const Duration(days: 30)),
          });

          if (stats['currentStreak'] >= 7) {
            achievements.add({
              'id': 'test_streak_7',
              'title': '7-Day Streak',
              'description': 'Complete tests for 7 consecutive days',
              'date': DateTime.now().subtract(const Duration(days: 20)),
            });
          }
        }

        // Calculate upcoming achievements
        final upcoming = _achievementDefinitions.where((def) {
          // Check if the achievement is not already earned
          return !achievements.any((a) => a['id'] == def['id']);
        }).map((def) {
          // Calculate progress
          double progress = 0;
          switch (def['id']) {
            case 'first_test':
              progress = stats['testsCompleted'] > 0 ? 1 : 0;
              break;
            case 'test_streak_7':
              progress = stats['currentStreak'] / 7;
              break;
            case 'test_streak_30':
              progress = stats['currentStreak'] / 30;
              break;
            case 'tests_10':
              progress = stats['testsCompleted'] / 10;
              break;
            case 'tests_50':
              progress = stats['testsCompleted'] / 50;
              break;
            case 'tests_100':
              progress = stats['testsCompleted'] / 100;
              break;
            default:
              progress = 0;
          }

          return {
            ...def,
            'progress': progress > 1 ? 1 : progress,
          };
        }).toList();

        setState(() {
          _userStats = stats;
          _achievements = achievements;
          _upcomingAchievements = upcoming;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading achievements: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    // Find the achievement definition
    final definition = _achievementDefinitions.firstWhere(
      (def) => def['id'] == achievement['id'],
      orElse: () => {
        'title': achievement['title'],
        'description': achievement['description'],
        'icon': Icons.star,
        'color': Colors.amber,
      },
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (definition['color'] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                definition['icon'] as IconData,
                color: definition['color'] as Color,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Earned on ${DateFormat('MMM d, yyyy').format(achievement['date'])}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAchievement(Map<String, dynamic> achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (achievement['color'] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement['icon'] as IconData,
                color: achievement['color'] as Color,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: achievement['progress'],
                      backgroundColor: Colors.grey[200],
                      color: achievement['color'] as Color,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(achievement['progress'] * 100).toInt()}% Complete',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0383C2),
        elevation: 0,
        title: const Text(
          'Achievements',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0383C2)),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with stats
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0383C2),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Your Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              _userStats['testsCompleted'] ?? 0,
                              'Tests',
                              Icons.assignment_turned_in,
                            ),
                            _buildStatItem(
                              _userStats['currentStreak'] ?? 0,
                              'Streak',
                              Icons.local_fire_department,
                            ),
                            _buildStatItem(
                              _achievements.length,
                              'Badges',
                              Icons.emoji_events,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Earned Achievements',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Earned achievements
                        _achievements.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Complete tests to earn achievements',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            : Column(
                                children: _achievements
                                    .map((a) => _buildAchievementCard(a))
                                    .toList(),
                              ),

                        const SizedBox(height: 32),
                        const Text(
                          'Upcoming Achievements',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Upcoming achievements
                        _upcomingAchievements.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text(
                                    'You have earned all available achievements!',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            : Column(
                                children: _upcomingAchievements
                                    .take(
                                        3) // Show only 3 upcoming achievements
                                    .map((a) => _buildUpcomingAchievement(a))
                                    .toList(),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(int value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF0383C2), size: 24),
              const SizedBox(height: 8),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0383C2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
