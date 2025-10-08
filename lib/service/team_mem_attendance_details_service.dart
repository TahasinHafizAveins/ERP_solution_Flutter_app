import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erp_solution/models/attendance_summery_model.dart';
import 'package:erp_solution/service/api_service.dart';
import 'package:erp_solution/utils/api_end_points.dart';

class TeamMemAttendanceDetailsService {
  final ApiService apiService;
  TeamMemAttendanceDetailsService(this.apiService);

  Future<AttendanceSummeryModel> fetchAttendanceSummary(String id) async {
    try {
      final response = await apiService.dio.get(
        '${ApiEndPoints.teamMemAttendanceDetailsApi}$id',
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.plain, // force plain text
        ),
      );

      final responseBody = json.decode(response.data);

      if (responseBody["Result"] != null) {
        return AttendanceSummeryModel.fromJson(responseBody);
      } else {
        final errorMessage =
            responseBody['Message'] ?? "Failed to load summary";
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      throw Exception(
        "Fetch failed: ${e.response?.data ?? e.message ?? "Unknown error"}",
      );
    }
  }
}
