import 'package:flutter/material.dart';
import 'package:frontend/utils/user_preferences.dart'; // Import the user preferences utility

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'User'; // Default value

  @override
  void initState() {
    super.initState();
    // Load user name when widget initializes
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    // Get user name from preferences
    final name = await UserPreferences.getUserName();
    if (name != null && name.isNotEmpty) {
      setState(() {
        userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome heading with emoji and dynamic user name
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              children: [
                const TextSpan(text: 'Welcome to Spendora, '),
                TextSpan(
                  text: userName, // Dynamic user name instead of hardcoded "Aladdin"
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const TextSpan(text: '! '),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      '🎉',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Welcome text
          const Text(
            'Spendora is your ultimate personal finance companion, designed to help you take control of your money with ease. Whether you\'re tracking daily expenses, managing your income, or setting ambitious savings goals, Spendora provides intuitive tools to simplify financial management.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'With interactive dashboards, insightful reports, and smart budgeting features, you\'ll gain a clear understanding of your financial health. Plus, with secure data encryption and seamless access across devices, you can manage your finances with confidence anytime, anywhere.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Final message with rocket emoji
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'Start your journey toward smarter spending and better savings today with Spendora! ',
                ),
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      '🚀',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Get started button
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to onboarding or dashboard
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}