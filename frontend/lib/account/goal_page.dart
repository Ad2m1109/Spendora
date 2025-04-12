import 'package:flutter/material.dart';
import 'package:frontend/utils/user_preferences.dart'; // Import UserPreferences
import 'package:frontend/services/category_service.dart'; // Import CategoryService
import '../services/goals_service.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({Key? key}) : super(key: key);

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  List<dynamic> goals = [];
  bool isLoading = true;
  String userId = ''; // Dynamically fetch userId
  Map<int, String> categoryMap = {}; // Dynamically fetched categories

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final fetchedUserId = await UserPreferences.getUserId();
      if (fetchedUserId == null || fetchedUserId.isEmpty) {
        throw Exception('User ID not found');
      }
      setState(() {
        userId = fetchedUserId;
      });
      await _loadCategories(); // Fetch categories dynamically
      _fetchGoals(); // Fetch goals after loading userId and categories
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService.getCategories();
      setState(() {
        categoryMap = {
          for (var category in categories)
            category['categoryId']: category['categoryName']
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    }
  }

  Future<void> _fetchGoals() async {
    try {
      setState(() {
        isLoading = true;
      });
      final fetchedGoals = await GoalsService.fetchGoals(int.parse(userId));
      setState(() {
        goals = fetchedGoals;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load goals: $e')),
      );
    }
  }

  Future<void> _addNewGoal() async {
    final TextEditingController goalNameController = TextEditingController();
    final TextEditingController targetAmountController =
        TextEditingController();
    final TextEditingController currentAmountController =
        TextEditingController();
    int? selectedCategoryId;

    // Show a dialog to get goal details from the user
    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Goal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: goalNameController,
                    decoration: const InputDecoration(labelText: 'Goal Name'),
                  ),
                  TextField(
                    controller: targetAmountController,
                    decoration:
                        const InputDecoration(labelText: 'Target Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: currentAmountController,
                    decoration: const InputDecoration(
                        labelText: 'Current Amount (optional)'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categoryMap.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // Cancel
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final goalName = goalNameController.text.trim();
                    final targetAmount =
                        double.tryParse(targetAmountController.text.trim());
                    final currentAmount =
                        double.tryParse(currentAmountController.text.trim()) ??
                            0;

                    if (goalName.isEmpty ||
                        targetAmount == null ||
                        targetAmount <= 0 ||
                        selectedCategoryId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter valid details')),
                      );
                      return;
                    }

                    // Check if the selected category is already used
                    final isCategoryUsed = goals.any(
                        (goal) => goal['categoryId'] == selectedCategoryId);
                    if (isCategoryUsed) {
                      _showWarningDialog(
                        'Category Already Used',
                        'The selected category is already associated with another goal. Please choose a different category.',
                      );
                      return; // Keep the dialog open
                    }

                    try {
                      final newGoal = {
                        'userId':
                            int.parse(userId), // Use dynamically fetched userId
                        'goalName': goalName,
                        'targetAmount': targetAmount,
                        'currentAmount': currentAmount,
                        'categoryId': selectedCategoryId,
                      };
                      await GoalsService.createGoal(newGoal);
                      _fetchGoals(); // Refresh the goals list
                      Navigator.of(context)
                          .pop(); // Close the dialog after success
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add goal: $e')),
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showWarningDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Savings Goals',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(166, 235, 78, 1), // Updated title color
            ),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      final targetAmount =
                          double.tryParse(goal['targetAmount'].toString()) ??
                              0.0;
                      final currentAmount =
                          double.tryParse(goal['currentAmount'].toString()) ??
                              0.0;
                      final progress =
                          targetAmount > 0 ? currentAmount / targetAmount : 0.0;

                      return _buildGoalItem(
                        goal['goalName'],
                        'Target: \$${targetAmount.toStringAsFixed(2)}',
                        'Saved: \$${currentAmount.toStringAsFixed(2)}',
                        progress,
                        Icons.star, // Replace with appropriate icon
                      );
                    },
                  ),
                ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addNewGoal,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(166, 235, 78, 1),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Add New Savings Goal'),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String title, String target, String saved,
      double progress, IconData iconData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconData,
                    color: Color.fromRGBO(25, 65, 55, 1)), // Updated icon color
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(target),
                Text(saved),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress.isNaN || progress.isInfinite
                  ? 0
                  : progress, // Ensure valid progress value
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% Complete',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
