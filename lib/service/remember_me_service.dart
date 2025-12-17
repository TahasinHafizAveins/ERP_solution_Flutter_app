import 'package:shared_preferences/shared_preferences.dart';

class RememberMeService {
  static const String _rememberMeKey = "rememberMe";
  static const String _usernameKey = "username";
  static const String _passwordKey = "password";

  // Save credentials with remember me preference
  Future<void> saveCredentials({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      // Save remember me preference
      await pref.setBool(_rememberMeKey, rememberMe);

      if (rememberMe) {
        // Save credentials if remember me is true
        await pref.setString(_usernameKey, username);
        await pref.setString(_passwordKey, password);
      } else {
        // Clear credentials if remember me is false
        await clearCredentials();
      }
    } catch (e) {
      print("Error saving credentials: $e");
    }
  }

  // Load saved credentials
  Future<Map<String, dynamic>> loadCredentials() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      final bool rememberMe = pref.getBool(_rememberMeKey) ?? false;
      final String username = pref.getString(_usernameKey) ?? "";
      final String password = pref.getString(_passwordKey) ?? "";

      return {
        'rememberMe': rememberMe,
        'username': rememberMe
            ? username
            : "", // Only return username if remember me is true
        'password': rememberMe
            ? password
            : "", // Only return password if remember me is true
      };
    } catch (e) {
      print("Error loading credentials: $e");
      return {'rememberMe': false, 'username': "", 'password': ""};
    }
  }

  // Clear saved credentials
  Future<void> clearCredentials() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();

      // Clear credential data but keep remember me preference
      await pref.remove(_usernameKey);
      await pref.remove(_passwordKey);

      print("Credentials cleared");
    } catch (e) {
      print("Error clearing credentials: $e");
    }
  }

  // Clear all data including remember me preference
  Future<void> clearAll() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();

      await pref.remove(_rememberMeKey);
      await pref.remove(_usernameKey);
      await pref.remove(_passwordKey);

      print("All remember me data cleared");
    } catch (e) {
      print("Error clearing all remember me data: $e");
    }
  }

  // Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      return pref.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      print("Error checking remember me: $e");
      return false;
    }
  }

  // Save only username (useful for auto-filling username only)
  Future<void> saveUsernameOnly(String username) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString(_usernameKey, username);
    } catch (e) {
      print("Error saving username: $e");
    }
  }

  // Load only username
  Future<String> loadUsername() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      return pref.getString(_usernameKey) ?? "";
    } catch (e) {
      print("Error loading username: $e");
      return "";
    }
  }
}
