import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class TransactionService {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000";
    } else if (Platform.isAndroid || Platform.isIOS) {
      return "http://192.168.10.119:5000";
    } else {
      return "http://localhost:5000";
    }
  }

  // Create a new transaction
  static Future<Map<String, dynamic>> createTransaction(
      String userId,
      double amount,
      String date,
      String description,
      int categoryId,
      String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId,
        'amount': amount,
        'date': date,
        'description': description,
        'categoryId': categoryId,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to create transaction';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Failed to create transaction');
      }
    }
  }

  // Fetch transactions for a user
  static Future<List<dynamic>> getTransactionsByUser(
      String userId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/get'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to fetch transactions';
        throw Exception(errorMessage);
      } catch (e) {
        print('Error fetching transactions: $e'); // Debug log
        throw Exception('Failed to fetch transactions');
      }
    }
  }

  // Update a transaction
  static Future<void> updateTransaction(int transactionId, double amount,
      String date, String description, int categoryId, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/transactions/$transactionId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        'date': date,
        'description': description,
        'categoryId': categoryId,
      }),
    );

    if (response.statusCode != 200) {
      try {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to update transaction';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Failed to update transaction');
      }
    }
  }

  // Delete a transaction
  static Future<void> deleteTransaction(int transactionId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/transactions/$transactionId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      try {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to delete transaction';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Failed to delete transaction');
      }
    }
  }

  // Fetch dashboard metrics
  static Future<Map<String, dynamic>> getDashboardMetrics(
      String userId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/metrics'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to fetch metrics';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Failed to fetch metrics');
      }
    }
  }

  // Fetch income categories chart
  static Future<Uint8List> getIncomeCategoriesChart(
      String userId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/income-categories-chart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to fetch income categories chart');
    }
  }

  // Fetch daily net savings chart
  static Future<Uint8List> getDailyNetSavingsChart(
      String userId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/daily-net-savings-chart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to fetch daily net savings chart');
    }
  }
}
