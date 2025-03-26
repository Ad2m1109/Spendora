import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class CategoryService {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000";
    } else if (Platform.isAndroid || Platform.isIOS) {
      return "http://192.168.10.119:5000";
    } else {
      return "http://localhost:5000";
    }
  }

  // Fetch all categories
  static Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to fetch categories';
        throw Exception(errorMessage);
      } catch (e) {
        print('Error fetching categories: $e'); // Debug log
        throw Exception('Failed to fetch categories');
      }
    }
  }
}
