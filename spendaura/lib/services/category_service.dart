import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class CategoryService {
  static String get baseUrl => ApiClient.baseUrl;

  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      _validateResponse(response);
      return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to load categories: ${e.toString()}');
    }
  }

  static Future<void> addCategory(String categoryName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'categoryName': categoryName}),
      );

      _validateResponse(response, successCode: 201);
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to add category: ${e.toString()}');
    }
  }

  static Future<void> deleteCategory(int categoryId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$categoryId'),
        headers: {'Content-Type': 'application/json'},
      );

      _validateResponse(response); // Validate the response
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Failed to delete category: ${e.toString()}');
    }
  }

  static void _validateResponse(http.Response response,
      {int successCode = 200}) {
    if (response.statusCode != successCode) {
      final error =
          jsonDecode(response.body)['error'] ?? 'Unknown error occurred';
      throw Exception('Server responded with: $error (${response.statusCode})');
    }
  }
}
