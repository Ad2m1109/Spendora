import 'package:flutter/material.dart';
import '../services/transaction_service.dart'; // Import the transaction service
import 'package:frontend/utils/user_preferences.dart'; // Import user preferences for token and userId
import 'add_transaction_page.dart'; // Import the AddTransactionPage
import '../home_screen.dart'; // Import the HomeScreen

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<dynamic> transactions = [];
  bool isLoading = true;
  String token = ''; // Fetch from UserPreferences
  String userId = ''; // Fetch from UserPreferences
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Fetch token and userId from UserPreferences
    final userToken = await UserPreferences.getUserToken();
    final userID = await UserPreferences.getUserId();

    // Debug logs
    print('Retrieved userId: $userID');
    print('Retrieved token: $userToken');

    if (userToken == null || userID == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    setState(() {
      token = userToken;
      userId = userID;
    });
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      // Debug logs
      print('Fetching transactions for userId: $userId');
      print('Using token: $token');

      final fetchedTransactions =
          await TransactionService.getTransactionsByUser(userId, token);
      setState(() {
        transactions = fetchedTransactions;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading transactions: $e'); // Debug log
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load transactions: $e')),
      );
    }
  }

  Future<void> _deleteTransaction(int transactionId) async {
    try {
      await TransactionService.deleteTransaction(transactionId, token);
      _loadTransactions(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete transaction: $e')),
      );
    }
  }

  Future<void> _confirmDeleteTransaction(int transactionId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (result == true) {
      _deleteTransaction(transactionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(selectedNavIndex: 0),
              ),
            );
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : transactions.isEmpty
              ? Center(child: Text('No transactions found'))
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final amount =
                        double.tryParse(transaction['amount']) ?? 0.0;
                    final backgroundColor =
                        amount >= 0 ? Colors.green[100] : Colors.red[100];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(transaction['description']),
                        subtitle: Text(
                          'Amount: \$${transaction['amount']} - Date: ${transaction['date']}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteTransaction(
                              transaction['transactionId']),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add transaction form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionPage()),
          ).then(
              (_) => _loadTransactions()); // Refresh transactions after adding
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
