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
        // Check JWT expiration
        if (JWTDecoder.isValid(token)) {
          _user = savedUser;
          // Update ApiService with the loaded token
          _authService.apiService.setToken(token);
          print("User initialized with valid token");
        } else {
          // Token is expired on app start
          print("Token expired on app start");
          await forceLogout();
        }
      } else {
        print("No token found on app start");
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

  // Logout method (user initiated)
  Future<void> logout() async {
    print("Logging out user");
    _user = null;
    _initialized = false;
    await TokenService().clearToken();
    await UserStorageService().clearUser();
    _authService.apiService.clearToken();

    notifyListeners();
  }

  // Force logout (for token expiration - doesn't clear stored token as it's already cleared)
  Future<void> forceLogout() async {
    print("Force logging out due to token expiration");
    _user = null;
    _initialized = false;
    _authService.apiService.clearToken();

    // Don't clear token from storage here as it's already cleared by ApiService
    notifyListeners();
  }
}
