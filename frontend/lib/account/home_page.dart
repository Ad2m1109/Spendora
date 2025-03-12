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
                  text: userName,
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

          // Title and introduction
          const Text(
            'Take Control of Your Finances',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Spendora is your personal finance tracking application, designed to help you manage your income, expenses, and savings effortlessly. With a user-friendly interface and powerful features, Spendora ensures that you stay in control of your financial health, no matter where you are.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Title and transaction management
          const Text(
            'Track Every Transaction with Ease',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adding, editing, and categorizing your financial transactions has never been simpler. Whether it’s your salary, rent, groceries, or entertainment expenses, Spendora allows you to keep an accurate record of every transaction, helping you understand where your money goes.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Title and visualization
          const Text(
            'Visualize Your Finances',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Numbers alone can be overwhelming, but Spendora transforms your financial data into beautiful and insightful graphs. Get a clear overview of your spending habits, track your financial trends over time, and gain valuable insights to make informed decisions.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Title and savings goals
          const Text(
            'Set and Achieve Your Savings Goals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Planning for a vacation, a new gadget, or building an emergency fund? Spendora lets you set personalized savings goals and track your progress step by step. You’ll receive notifications and alerts to keep you motivated and on track toward reaching your financial objectives.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Title and security
          const Text(
            'Secure and Reliable',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your financial data is protected with industry-standard encryption, ensuring your information remains private and secure. With safe authentication and backup options, you can trust Spendora to safeguard your finances while giving you seamless access across devices.',
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
                  text: 'Start your journey to financial freedom today with Spendora! ',
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
