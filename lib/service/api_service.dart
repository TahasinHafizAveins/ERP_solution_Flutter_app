import 'package:dio/dio.dart';
import 'package:erp_solution/utils/api_end_points.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  final Dio dio = Dio(
    BaseOptions(baseUrl: "https://nagaderp.mynagad.com:7070"),
  );

  String? accessToken;
  String? refreshToken;

  // for no separate token refresh api
  void init() {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (accessToken != null &&
              !options.path.contains(ApiEndPoints.loginApi)) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // No refresh API available → force logout
            // Example: clear tokens and redirect to login

            accessToken = null;
            refreshToken = null;

            // notify Provider here to trigger logout
            // e.g., authProvider.logout();
            return handler.reject(e);
          }
          return handler.next(e);
        },
      ),
    );

    // LogInterceptor to see Api Logs

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: false, // set to false for multi-line JSON
        maxWidth: 120, // controls line wrap
      ),
    );
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
