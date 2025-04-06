import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<Map<String, dynamic>> _helpSections = [
    {
      'title': 'Understanding Your Results',
      'icon': Icons.analytics,
      'items': [
        {
          'question': 'What is Body Composition Analysis?',
          'answer':
              'Body composition analysis is the measurement of body fat in relation to lean body mass. It is an essential measurement of fitness level since it provides a better metric than traditional methods like BMI.',
        },
        {
          'question': 'How to Read Your InBody Results',
          'answer':
              'Your InBody Result Sheet provides a comprehensive view of your body composition. The key metrics include Weight, Skeletal Muscle Mass, Body Fat Mass, and Percent Body Fat. The results are color-coded: within range (green), slightly out of range (yellow), and out of range (red).',
        },
        {
          'question': 'What is BMI?',
          'answer':
              'Body Mass Index (BMI) is a value derived from a person\'s weight and height. It is calculated as weight in kilograms divided by height in meters squared. While useful for population studies, BMI doesn\'t account for body composition and may misclassify muscular individuals.',
        },
        {
          'question': 'What is PBF?',
          'answer':
              'PBF (Percent Body Fat) is the percentage of your body weight that is fat. Healthy ranges vary by gender and age, with women typically having higher percentages than men.',
        },
      ],
    },
    {
      'title': 'Testing Guidelines',
      'icon': Icons.assignment,
      'items': [
        {
          'question': 'How to Prepare for a Test',
          'answer':
              '• Test at similar times of day\n• Avoid eating for 2-4 hours before testing\n• Avoid exercise 12 hours before testing\n• Empty your bladder before testing\n• Remove metal objects and accessories',
        },
        {
          'question': 'Testing Frequency',
          'answer':
              'For general health monitoring, testing every 4-8 weeks is recommended. For active fitness programs or weight management, every 2-4 weeks may be more appropriate.',
        },
        {
          'question': 'When to Avoid Testing',
          'answer':
              'Avoid testing during menstruation or when experiencing significant fluid retention as these factors can affect accuracy.',
        },
      ],
    },
    {
      'title': 'Using the App',
      'icon': Icons.smartphone,
      'items': [
        {
          'question': 'How to Track Progress',
          'answer':
              'The app automatically saves your test results. View your progress over time in the \'Previous Results\' section. Compare specific metrics by selecting parameters and date ranges.',
        },
        {
          'question': 'Setting Goals',
          'answer':
              'Go to the \'Goals\' section to set targets for specific body composition metrics. The app will track your progress toward these goals over time.',
        },
        {
          'question': 'Data Synchronization',
          'answer':
              'Your data is automatically synced across devices when you\'re signed in to your account and connected to the internet.',
        },
        {
          'question': 'Data Privacy',
          'answer':
              'Your health data is encrypted and stored securely. We never share your personal information with third parties without your explicit consent.',
        },
      ],
    },
    {
      'title': 'Troubleshooting',
      'icon': Icons.build,
      'items': [
        {
          'question': 'App Not Responding',
          'answer':
              'Try closing and reopening the app. If issues persist, restart your device. Ensure your app is updated to the latest version.',
        },
        {
          'question': 'Test Results Not Showing',
          'answer':
              'Check your internet connection as results need to sync with our servers. If connected and still having issues, try signing out and back into your account.',
        },
        {
          'question': 'Account Issues',
          'answer':
              'For password resets or account recovery, use the \'Forgot Password\' option on the login screen. For other account issues, please contact support.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0383C2),
        elevation: 0,
        title: const Text(
          'Help Center',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Header section
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 30,
                bottom: 50,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF0383C2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for help',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Support buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Row(
                children: [
                  _buildSupportButton(
                    context,
                    'Contact Us',
                    Icons.email,
                    Colors.orange,
                    () => _launchEmail(),
                  ),
                  const SizedBox(width: 16),
                  _buildSupportButton(
                    context,
                    'Call Support',
                    Icons.phone,
                    Colors.green,
                    () => _launchPhone(),
                  ),
                  const SizedBox(width: 16),
                  _buildSupportButton(
                    context,
                    'Live Chat',
                    Icons.chat,
                    Colors.blue,
                    () => _openLiveChat(),
                  ),
                ],
              ),
            ),
          ),

          // Section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),

          // Help sections
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildHelpSection(_helpSections[index]),
                );
              },
              childCount: _helpSections.length,
            ),
          ),

          // Bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(Map<String, dynamic> section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF0383C2),
          ),
        ),
        child: ExpansionTile(
          leading: Icon(
            section['icon'] as IconData,
            color: const Color(0xFF0383C2),
          ),
          title: Text(
            section['title'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: (section['items'] as List<Map<String, dynamic>>)
              .map((item) => _buildFAQItem(item))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            item['question'] as String,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item['answer'] as String,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@biotrack.com',
      queryParameters: {'subject': 'BioTrack Support Request'},
    );

    try {
      launchUrl(emailLaunchUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch email client'),
        ),
      );
    }
  }

  void _launchPhone() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: '+18001234567',
    );

    try {
      launchUrl(phoneLaunchUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch phone dialer'),
        ),
      );
    }
  }

  void _openLiveChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Live Chat'),
          content: const Text(
              'Live chat is not available in the demo version. In a real application, this would connect to your customer support system.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
