import 'package:dio/dio.dart';
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

  // for no separate token refresh api
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
          //Load token fresh each time to ensure it's current
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
            // You might want to navigate to login here
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

  /*
// if there is separate api for token refresh then use this code

void init() {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 && refreshToken != null) {
            try {
              await refreshAccessToken();
              final cloneReq = await dio.request(
                e.requestOptions.path,
                options: Options(
                  method: e.requestOptions.method,
                  headers: {
                    ...e.requestOptions.headers,
                    "Authorization": "Bearer $accessToken",
                  },
                ),
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
              );
              return handler.resolve(cloneReq);
            } catch (_) {
              return handler.reject(e);
            }
          } else {
            return handler.next(e);
          }
        },
      ),
    );
  }

  Future<void> refreshAccessToken() async {
    final response = await dio.post("/refresh", data: {
      "refresh_token": refreshToken,
    });
    accessToken = response.data["access_token"];
    refreshToken = response.data["refresh_token"];
  }*/
}
