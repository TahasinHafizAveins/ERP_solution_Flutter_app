import 'package:erp_solution/models/user_model.dart';
import 'package:erp_solution/service/auth_service.dart';
import 'package:erp_solution/service/token_service.dart';
import 'package:erp_solution/service/user_storage_service.dart';
import 'package:erp_solution/utils/jwt_decoder.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);
  UserModel? _user;
  bool _isLoading = false;
  bool _initialized = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  String? get authToken => _authService.apiService.accessToken;

  Future<void> init() async {
    if (_initialized) return;

    try {
      _isLoading = true;
      notifyListeners();
      final token = await TokenService().loadToken();
      final savedUser = await UserStorageService().loadUser();

      if (token != null && token.isNotEmpty) {
        //  check JWT expiration
        if (JWTDecoder.isValid(token)) {
          _user = savedUser;
          // Update ApiService with the loaded token
          _authService.apiService.setToken(token);
        } else {
          await logout();
        }
      }

      _initialized = true;
    } catch (e) {
      print("Error during auth init: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login method
  Future<void> login(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = await _authService.login(username: username, password: password);

      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout() async {
    _user = null;
    _initialized = false;
    await TokenService().clearToken();
    await UserStorageService().clearUser();
    _authService.apiService.accessToken = null;
    _authService.apiService.refreshToken = null;
    notifyListeners();
  }
}
