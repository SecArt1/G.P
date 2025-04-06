import 'package:flutter/material.dart';
import 'package:bio_track/StartTest.dart';
import 'package:bio_track/edit_profile.dart';
import 'package:bio_track/services/user_service.dart';
import 'package:bio_track/models/user_model.dart';
import 'package:bio_track/goals_page.dart';
import 'package:bio_track/achievements_page.dart';
import 'package:bio_track/help_page.dart';
import 'package:bio_track/results_dashboard_page.dart';
import 'package:share_plus/share_plus.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData(forceRefresh: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reload data when app is resumed
      _loadUserData(forceRefresh: true);
    }
  }

  Future<void> _loadUserData({bool forceRefresh = false}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userService = UserService();
      final user = await userService.getCurrentUser(forceRefresh: forceRefresh);

      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Calculate age from date of birth
  int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust age if birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0383C2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active,
                  color: Color(0xFF0383C2),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Notifications',
                style: TextStyle(
                  color: Color(0xFF0383C2),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildNotificationItem(
                  title: 'Test Results Ready',
                  message: 'Your latest test results are now available.',
                  time: '2 hours ago',
                  isNew: true,
                ),
                const Divider(height: 24),
                _buildNotificationItem(
                  title: 'Weekly Summary',
                  message: 'Check out your progress for this week!',
                  time: '1 day ago',
                  isNew: false,
                ),
                const Divider(height: 24),
                _buildNotificationItem(
                  title: 'Goal Achieved',
                  message:
                      'Congratulations! You\'ve reached your target weight goal.',
                  time: '3 days ago',
                  isNew: false,
                ),
                const Divider(height: 24),
                _buildNotificationItem(
                  title: 'Appointment Reminder',
                  message:
                      'You have a scheduled health check tomorrow at 10:00 AM.',
                  time: '4 days ago',
                  isNew: false,
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFF0383C2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Mark all as read logic would go here
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0383C2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text('Mark All Read'),
            ),
          ],
          actionsPadding: const EdgeInsets.all(16),
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required bool isNew,
    TextStyle? titleStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isNew ? const Color(0xFF0383C2) : Colors.transparent,
            ),
            margin: const EdgeInsets.only(top: 5, right: 10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: titleStyle ??
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shareApp() async {
    try {
      final text = 'Check out BioTrack - A comprehensive health tracking app! '
          'Download it today: https://biotrack.app.com';

      await Share.share(text, subject: 'BioTrack Health App');
    } catch (e) {
      print('Error sharing app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0383C2), Color(0xFF045D87)],
                ),
              ),
            ),

            // Content
            SingleChildScrollView(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        // Logo
                        Image.asset(
                          'assets/Logo.png',
                          height: 30,
                        ),

                        const Spacer(),

                        // Action buttons
                        _buildIconButton(
                          icon: Icons.notifications_outlined,
                          onTap: () => _showNotificationsDialog(context),
                        ),
                        _buildIconButton(
                          icon: Icons.question_mark_outlined,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HelpPage())),
                        ),
                        _buildIconButton(
                          icon: Icons.share_outlined,
                          onTap: _shareApp,
                        ),
                      ],
                    ),
                  ),

                  // User profile section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Row(
                      children: [
                        // User avatar
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_rounded,
                              color: Color(0xFF0383C2), size: 32),
                        ),

                        const SizedBox(width: 16),

                        // User details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User name
                              Row(
                                children: [
                                  Text(
                                    _isLoading
                                        ? "Loading..."
                                        : (_currentUser?.fullName ?? "User"),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_currentUser?.fullName == null)
                                    IconButton(
                                      icon: const Icon(Icons.refresh,
                                          color: Colors.white, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        _loadUserData();
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              // User age
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _isLoading
                                      ? "Age: -"
                                      : _currentUser?.dateOfBirth != null
                                          ? "Age: ${calculateAge(_currentUser!.dateOfBirth!)}"
                                          : "Age: Not set",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Welcome message
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: Text(
                        _isLoading
                            ? "Welcome!"
                            : "Welcome, ${_currentUser?.fullName?.split(' ').first ?? 'User'}!",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Main content card
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick actions title
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Icons grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildActionItem(
                              icon: 'assets/profile.png',
                              label: 'Profile',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage()),
                              ),
                            ),
                            _buildActionItem(
                              icon: 'assets/achieve.png',
                              label: 'Achievements',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AchievementsPage()),
                              ),
                            ),
                            _buildActionItem(
                              icon: 'assets/goals.png',
                              label: 'Goals',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GoalsPage()),
                              ),
                            ),
                            _buildActionItem(
                              icon: 'assets/help.png',
                              label: 'Help',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HelpPage()),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Main actions title
                        const Text(
                          'Your Health Journey',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Start test card
                        _buildActionCard(
                          title: 'Start New Test',
                          description:
                              'Begin a new health assessment to track your progress',
                          icon: 'assets/start_test.png',
                          gradientColors: const [
                            Color(0xFF0383C2),
                            Color(0xFF03A9F4)
                          ],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SummaryPage()),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Results dashboard card
                        _buildActionCard(
                          title: 'Results Dashboard',
                          description:
                              'View your health metrics and progress over time',
                          icon: 'assets/prev_result.png',
                          gradientColors: const [
                            Color(0xFF43A047),
                            Color(0xFF66BB6A)
                          ],
                          onTap: () async {
                            await _loadUserData(forceRefresh: true);
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ResultsDashboardPage(),
                                ),
                              ).then((_) {
                                _loadUserData(forceRefresh: true);
                              });
                            }
                          },
                        ),
                      ],
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

  // Helper method to build action icon buttons
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: Material(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }

  // Helper method to build action items
  Widget _buildActionItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0383C2).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                icon,
                width: 40,
                height: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0383C2),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build action cards
  Widget _buildActionCard({
    required String title,
    required String description,
    required String icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Card content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Card icon
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      icon,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
