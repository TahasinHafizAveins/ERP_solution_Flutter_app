import 'package:dio/dio.dart';
import 'package:erp_solution/models/user_model.dart';
import 'package:erp_solution/service/api_service.dart';
import 'package:erp_solution/service/token_service.dart';
import 'package:erp_solution/service/user_storage_service.dart';
import 'package:erp_solution/utils/api_end_points.dart';

class AuthService {
  final ApiService apiService;
  AuthService(this.apiService);

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiService.dio.post(
        ApiEndPoints.loginApi,
        data: {"UserName": username, "Password": password},
      );

      final Map<String, dynamic> responseBody = response.data;

      //API return nested "Result" object
      if (responseBody["Result"] != null &&
          responseBody['Result']['ReasonID'] == 0) {
        final userModel = UserModel.fromJson(responseBody);
        //Save token
        final token = userModel.result?.token;

        if (token != null && token.isNotEmpty) {
          await TokenService().saveToken(token);
          await UserStorageService().saveUser(userModel);

          apiService.accessToken = token; //Update apiService with the new token
        }

        return userModel;
      } else {
        final errorMessage =
            responseBody['Result']?['Message'] ??
            responseBody['Message'] ??
            "Login failed";
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      throw Exception(
        "Login failed: ${e.response?.data ?? e.message ?? "Unknown error"}",
      );
    }
  }
}
