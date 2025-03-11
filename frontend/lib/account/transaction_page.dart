import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transactions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildTransactionItem(
                  'Grocery Shopping',
                  'Mar 8, 2025',
                  '-\$58.95',
                  Icons.shopping_basket,
                  isExpense: true,
                ),
                _buildTransactionItem(
                  'Salary Deposit',
                  'Mar 5, 2025',
                  '+\$2,450.00',
                  Icons.account_balance_wallet,
                  isExpense: false,
                ),
                _buildTransactionItem(
                  'Utilities Bill',
                  'Mar 3, 2025',
                  '-\$145.30',
                  Icons.power,
                  isExpense: true,
                ),
                _buildTransactionItem(
                  'Online Shopping',
                  'Mar 1, 2025',
                  '-\$89.99',
                  Icons.shopping_cart,
                  isExpense: true,
                ),
                _buildTransactionItem(
                  'Freelance Income',
                  'Feb 28, 2025',
                  '+\$350.00',
                  Icons.work,
                  isExpense: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String date, String amount,
      IconData iconData, {required bool isExpense}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isExpense ? Colors.red.shade100 : Colors.green.shade100,
          child: Icon(
            iconData,
            color: isExpense ? Colors.red : Colors.green,
          ),
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isExpense ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }
}