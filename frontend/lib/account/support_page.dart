import 'package:flutter/material.dart';
import 'package:frontend/profile_page.dart';
import 'package:frontend/sign_in_page.dart'; // Ensure you have this screen

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support Center',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
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
            child: ListView(
              children: [
                // Account Settings now navigates to Profile Page
                _buildSupportItem(
                  'Account Settings',
                  'Manage your account information and preferences',
                  Icons.settings,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                _buildSupportItem(
                  'Transaction Issues',
                  'Troubleshoot problems with your transactions',
                  Icons.receipt_long,
                ),
                _buildSupportItem(
                  'Budgeting Help',
                  'Tips and guidance for effective budgeting',
                  Icons.pie_chart,
                ),
                _buildSupportItem(
                  'Contact Support Team',
                  'Get in touch with our customer service',
                  Icons.support_agent,
                ),
                _buildSupportItem(
                  'Security & Privacy',
                  'Learn about how we keep your data safe',
                  Icons.security,
                ),

                // Logout Button
                _buildSupportItem(
                  'Logout',
                  'Sign out of your account',
                  Icons.exit_to_app,
                  onTap: () {
                    // Navigate to LoginScreen and remove current screen from stack
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem(String title, String description, IconData iconData, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Icon(iconData, color: Colors.green),
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
