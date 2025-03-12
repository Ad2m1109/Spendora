import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // Keys
  static const _keyUserId = 'userId';
  static const _keyName = 'name';
  static const _keyEmail = 'email';
  static const _keyToken = 'token'; // Added for token management
  static const _keyRememberMe = 'rememberMe';
  static const _keyRememberedEmail = 'remembered_email';
  static const _keyRememberedPassword = 'remembered_password';

  // Get SharedPreferences instance
  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Save user information
  static Future<bool> saveUserInfo(String userId, String name, String email) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_keyUserId, userId);
      await prefs.setString(_keyName, name);
      await prefs.setString(_keyEmail, email);
      return true;
    } catch (e) {
      throw Exception('Failed to save user info: $e');
    }
  }

  // Save user token
  static Future<bool> saveUserToken(String token) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_keyToken, token);
      return true;
    } catch (e) {
      throw Exception('Failed to save user token: $e');
    }
  }

  // Get user name
  static Future<String?> getUserName() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_keyName);
    } catch (e) {
      throw Exception('Failed to get user name: $e');
    }
  }

  // Get user ID
  static Future<String?> getUserId() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_keyUserId);
    } catch (e) {
      throw Exception('Failed to get user ID: $e');
    }
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_keyEmail);
    } catch (e) {
      throw Exception('Failed to get user email: $e');
    }
  }

  // Get user token
  static Future<String?> getUserToken() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_keyToken);
    } catch (e) {
      throw Exception('Failed to get user token: $e');
    }
  }

  // Clear user data (for logout)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyName);
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyToken); // Clear token on logout
      return true;
    } catch (e) {
      throw Exception('Failed to clear user data: $e');
    }
  }

  // Save remembered credentials when "Remember me" is checked
  static Future<bool> saveRememberedCredentials(String email, String password, bool rememberMe) async {
    try {
      final prefs = await _getPrefs();

      // Save the remember me state
      await prefs.setBool(_keyRememberMe, rememberMe);

      if (rememberMe) {
        // If remember me is checked, save the email and password
        await prefs.setString(_keyRememberedEmail, email);
        await prefs.setString(_keyRememberedPassword, password);
      } else {
        // If remember me is unchecked, clear saved credentials
        await prefs.remove(_keyRememberedEmail);
        await prefs.remove(_keyRememberedPassword);
      }

      return true;
    } catch (e) {
      throw Exception('Failed to save remembered credentials: $e');
    }
  }

  // Get remembered credentials
  static Future<Map<String, dynamic>> getRememberedCredentials() async {
    try {
      final prefs = await _getPrefs();

      // Get the remember me state
      final rememberMe = prefs.getBool(_keyRememberMe) ?? false;

      if (rememberMe) {
        return {
          'email': prefs.getString(_keyRememberedEmail) ?? '',
          'password': prefs.getString(_keyRememberedPassword) ?? '',
          'rememberMe': true
        };
      }

      return {
        'email': '',
        'password': '',
        'rememberMe': false
      };
    } catch (e) {
      throw Exception('Failed to get remembered credentials: $e');
    }
  }

  // Clear remembered credentials (useful when logging out)
  static Future<bool> clearRememberedCredentials() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_keyRememberMe);
      await prefs.remove(_keyRememberedEmail);
      await prefs.remove(_keyRememberedPassword);
      return true;
    } catch (e) {
      throw Exception('Failed to clear remembered credentials: $e');
    }
  }
}