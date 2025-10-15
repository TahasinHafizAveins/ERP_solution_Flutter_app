import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = "token";

  Future<void> saveToken(String token) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString(_tokenKey, token);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> loadToken() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString(_tokenKey) ?? "";
      return token;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> clearToken() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove(_tokenKey);
      print("Token cleared");
    } catch (e) {
      print("Error clearing token: $e");
    }
  }
}
