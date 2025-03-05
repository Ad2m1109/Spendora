import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000/auth"; // For Android Emulator

  // Add a new user (register)
  static Future<void> addUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': userData['fullName'],
        'email': userData['email'],
        'password': userData['password'],
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add user');
    }
  }

  // Sign in (login)
  static Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}