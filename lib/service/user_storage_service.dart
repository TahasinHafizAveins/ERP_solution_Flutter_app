import 'dart:convert';

import 'package:erp_solution/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorageService {
  static const _userKey = "user";

  // Save user data as a JSON string
  Future<void> saveUser(UserModel user) async {
    final pref = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await pref.setString(_userKey, jsonString);
  }

  // Load user data from JSON string
  Future<UserModel?> loadUser() async {
    final pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString(_userKey);
    if (jsonString == null) return null;
    try {
      final Map<String, dynamic> userMap = jsonDecode(jsonString);
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  // Clear user data
  Future<void> clearUser() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_userKey);
  }
}
