import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erp_solution/models/attendance_bar_chart_model.dart';
import 'package:erp_solution/models/attendance_summery_model.dart';
import 'package:erp_solution/service/api_service.dart';
import 'package:erp_solution/utils/api_end_points.dart';

class AttendanceSummeryService {
  final ApiService apiService;
  AttendanceSummeryService(this.apiService);

  Future<AttendanceSummeryModel> fetchAttendanceSummary() async {
    try {
      final response = await apiService.dio.get(
        ApiEndPoints.attendanceSummaryApi,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.plain, // force plain text
        ),
      );

      // unwrap "Result" directly
      final responseBody = json.decode(response.data)['Result'];

      //final Map<String, dynamic> responseBody = response.data[];

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

  Future<AttendanceBarChartModel> fetchAttendanceBarChart() async {
    try {
      final response = await apiService.dio.get(
        ApiEndPoints.getAttendanceBarChartApi,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.plain,
        ),
      );

      final decodedResponse = json.decode(response.data);
      final resultArray = decodedResponse['Result'] as List?;

      if (resultArray == null || resultArray.isEmpty) {
        throw Exception(decodedResponse['Message'] ?? "No data available");
      }

      return AttendanceBarChartModel.fromJson(resultArray[0]);
    } on DioException catch (e) {
      throw Exception(
        "Fetch failed: ${e.response?.data ?? e.message ?? "Unknown error"}",
      );
    }
  }
}
