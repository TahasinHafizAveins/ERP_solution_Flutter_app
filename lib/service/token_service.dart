import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  Future<void> saveToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", token);
  }

  Future<String> loadToken() async {
    String token = '';
    print("tookennnnn loadToken");
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("token") != null) {
      token = pref.getString("token")!;
    }
    return token;
  }

  Future<void> clearToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
