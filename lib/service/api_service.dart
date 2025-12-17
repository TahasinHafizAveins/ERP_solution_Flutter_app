import 'package:dio/dio.dart';
import 'package:erp_solution/service/auth_event_service.dart';
import 'package:erp_solution/service/token_service.dart';
import 'package:erp_solution/utils/api_end_points.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndPoints.base,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  String? accessToken;
  String? refreshToken;

  Future<void> init() async {
    // Clear existing interceptors
    dio.interceptors.clear();

    // 1. Add logger FIRST
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: false,
        maxWidth: 120,
      ),
    );

    // 2. Then add auth interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Load token fresh each time to ensure it's current
          if (accessToken == null) {
            final savedToken = await TokenService().loadToken();
            if (savedToken != null && savedToken.isNotEmpty) {
              accessToken = savedToken;
              print("Loaded token in interceptor: $accessToken");
            }
          }

          if (accessToken != null &&
              accessToken!.isNotEmpty &&
              !options.path.contains(ApiEndPoints.loginApi)) {
            options.headers["Authorization"] = "Bearer $accessToken";
            print("Added Authorization header with token");
          } else {
            print("No token available for request to: ${options.path}");
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          print("Dio Error: ${e.message}, Status: ${e.response?.statusCode}");

          if (e.response?.statusCode == 401) {
            print("Token expired or invalid, clearing...");
            accessToken = null;
            await TokenService().clearToken();

            // Notify about token expiration
            AuthEventService().notifyTokenExpired();
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Method to update token from outside
  void setToken(String token) {
    accessToken = token;
    print("Token updated in ApiService: $token");
  }

  // Clear token (for logout)
  void clearToken() {
    accessToken = null;
    refreshToken = null;
  }
}
