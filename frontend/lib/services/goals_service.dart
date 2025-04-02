import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GoalsService {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000";
    } else if (Platform.isAndroid || Platform.isIOS) {
      return "http://192.168.1.10:5000";
    } else {
      return "http://localhost:5000";
    }
  }

  static Future<List<Map<String, dynamic>>> fetchGoals(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/goals?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      _validateResponse(response);
      return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to load goals: ${e.toString()}');
    }
  }

  static Future<int> createGoal(Map<String, dynamic> goalData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/goals'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          ...goalData,
          'currentAmount':
              goalData['currentAmount'] ?? 0, // Default to 0 if not provided
        }),
      );

      _validateResponse(response, successCode: 201);
      return jsonDecode(response.body)['id'] as int;
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to create goal: ${e.toString()}');
    }
  }

  static Future<void> updateGoal(int goalId, double currentAmount) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/goals/$goalId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'currentAmount': currentAmount}),
      );

      _validateResponse(response);
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to update goal: ${e.toString()}');
    }
  }

  static Future<void> deleteGoal(int goalId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/goals/$goalId'),
        headers: {'Content-Type': 'application/json'},
      );

      _validateResponse(response);
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to delete goal: ${e.toString()}');
    }
  }

  static void _validateResponse(http.Response response,
      {int successCode = 200}) {
    if (response.statusCode != successCode) {
      final error =
          jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
      throw Exception('Server responded with: $error (${response.statusCode})');
    }
  }
}
