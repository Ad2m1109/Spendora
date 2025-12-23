import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import '../services/transaction_service.dart'; // Import the transaction service
import '../services/category_service.dart'; // Import the category service
import 'package:frontend/utils/user_preferences.dart'; // Import user preferences for token and userId

class EditTransactionPage extends StatefulWidget {
  final Map<String, dynamic> transaction;

  EditTransactionPage({required this.transaction});

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  String? _selectedCategory;
  List<Map<String, dynamic>> _categories = [];
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    try {
      _amountController =
          TextEditingController(text: widget.transaction['amount'].toString());
      _descriptionController =
          TextEditingController(text: widget.transaction['description']);
      _selectedDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz')
          .parse(widget.transaction['date']);
      _selectedCategory = widget.transaction['categoryId'].toString();
      _loadCategories();
    } catch (e) {
      print('Error initializing EditTransactionPage: $e'); // Debug log
      setState(() {
        _initializationError = 'Failed to initialize page: $e';
      });
    }
  }

  Future<void> _loadCategories() async {
    try {
      final List<dynamic> categories = await CategoryService.getCategories();
      setState(() {
        _categories = categories.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('Error loading categories: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initializationError != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Transaction'),
        ),
        body: Center(
          child: Text(_initializationError!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Transaction',
          style: TextStyle(
              color: Color.fromRGBO(166, 235, 78, 1)), // Updated title color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today,
                        color: Color.fromRGBO(
                            25, 65, 55, 1)), // Updated icon color
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['categoryId'].toString(),
                    child: Text(category['categoryName']),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final userId = await UserPreferences.getUserId();
                      final token = await UserPreferences.getUserToken();

                      if (userId == null || token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User not logged in')),
                        );
                        return;
                      }

                      await TransactionService.updateTransaction(
                        widget.transaction['transactionId'],
                        double.parse(_amountController.text),
                        DateFormat('yyyy-MM-dd')
                            .format(_selectedDate!), // Format the date
                        _descriptionController.text,
                        int.parse(_selectedCategory!), // Use category ID
                        token,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Transaction updated successfully')),
                      );
                      Navigator.pop(context); // Return to the transaction page
                    } catch (e) {
                      print('Error updating transaction: $e'); // Debug log
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to update transaction: $e')),
                      );
                    }
                  }
                },
                child: Text('Update Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
