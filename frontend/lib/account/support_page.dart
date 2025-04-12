import 'package:flutter/material.dart';
import 'package:frontend/profile_page.dart';
import 'package:frontend/sign_in_page.dart';
import 'package:frontend/account/dashboard.dart';
import 'package:frontend/account/categories_page.dart'; // Import CategoriesPage
import 'package:frontend/account/contact_team_page.dart'; // Import ContactTeamPage

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _supportTopics = [
    {
      'title': 'Dashboard',
      'description': 'View your financial overview and statistics',
      'icon': Icons.dashboard,
      'onTap': (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          ),
    },
    {
      'title': 'Account Settings',
      'description': 'Manage your account information and preferences',
      'icon': Icons.settings,
      'onTap': (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          ),
    },
    {
      'title': 'Manage Categories',
      'description': 'Add, edit, or delete your financial categories',
      'icon': Icons.category,
      'onTap': (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoriesPage()),
          ),
    },
    {
      'title': 'Transaction Issues',
      'description': 'Troubleshoot problems with your transactions',
      'icon': Icons.receipt_long,
    },
    {
      'title': 'Budgeting Help',
      'description': 'Tips and guidance for effective budgeting',
      'icon': Icons.pie_chart,
    },
    {
      'title': 'Contact Support Team',
      'description': 'Get in touch with our customer service',
      'icon': Icons.support_agent,
      'onTap': (BuildContext context) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const ContactTeamPage()), // Navigate to ContactTeamPage
          ),
    },
    {
      'title': 'Security & Privacy',
      'description': 'Learn about how we keep your data safe',
      'icon': Icons.security,
    },
    {
      'title': 'Logout',
      'description': 'Sign out of your account',
      'icon': Icons.exit_to_app,
      'onTap': (BuildContext context) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTopics = _supportTopics
        .where((topic) =>
            topic['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            topic['description']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Support Center',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(166, 235, 78, 1),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'How can we help you today?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Search bar
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for help topics...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Common Topics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: filteredTopics.length,
                itemBuilder: (context, index) {
                  final topic = filteredTopics[index];
                  return _buildSupportItem(
                    topic['title'],
                    topic['description'],
                    topic['icon'],
                    onTap: topic['onTap'] != null
                        ? () => topic['onTap'](context)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportItem(String title, String description, IconData iconData,
      {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Icon(iconData, color: Color.fromRGBO(25, 65, 55, 1)),
        title: Text(title),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap ?? () {},
      ),
    );
  }
}
