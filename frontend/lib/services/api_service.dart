import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform, File;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000";
    } else if (Platform.isAndroid || Platform.isIOS) {
      return "http://192.168.0.197:5000";
    } else {
      return "http://localhost:5000";
    }
  }

  // Add a new user (register)
  static Future<void> addUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': userData['fullName'],
        'email': userData['email'],
        'password': userData['password'],
      }),
    );

    if (response.statusCode != 201) {
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to add user';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Failed to add user');
      }
    }
  }

  // Sign in (login)
  static Future<Map<String, dynamic>> signIn(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Unknown error occurred';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Login failed');
      }
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile(
      String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to get user profile';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Failed to get user profile');
      }
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile(
      String userId, Map<String, dynamic> userData, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(userData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to update profile';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Failed to update profile');
      }
    }
  }

  // Change password
  static Future<void> changePassword(String userId, String currentPassword,
      String newPassword, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      try {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to change password';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Failed to change password');
      }
    }
  }

  // Forgot password request
  static Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      try {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to process password reset';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Failed to process password reset');
      }
    }
  }

  // Logout (invalidate token on server)
  static Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Logout failed';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Logout failed');
      }
    }
  }

  // Reset Password
  static Future<void> resetPassword(String token, String newPassword) async {
    final url = Uri.parse(
        '$baseUrl/auth/reset-password/confirm'); // Adjust endpoint as needed

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
          'password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Password reset successful
        return;
      } else {
        // Handle different status codes
        final errorData = jsonDecode(response.body);
        throw errorData['message'] ?? 'Failed to reset password';
      }
    } catch (e) {
      // Re-throw to be handled by the UI
      throw 'Password reset failed: $e';
    }
  }

  // Upload profile picture
  static Future<void> uploadProfilePicture(
      String userId, File imageFile, String token) async {
    if (kIsWeb) {
      throw UnsupportedError('MultipartFile is not supported on the web.');
    } else {
      final request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/users/$userId/upload'));
      request.headers['Authorization'] = 'Bearer $token';
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode != 200) {
        try {
          final errorData = json.decode(await response.stream.bytesToString());
          final errorMessage =
              errorData['message'] ?? 'Failed to upload profile picture';
          throw Exception(errorMessage);
        } catch (_) {
          throw Exception('Failed to upload profile picture');
        }
      }
    }
  }
}
