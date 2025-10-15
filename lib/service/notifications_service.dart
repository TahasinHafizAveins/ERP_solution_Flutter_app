import 'package:dio/dio.dart';
import 'package:erp_solution/models/notification_model.dart';
import 'package:erp_solution/models/notification_type_model.dart';
import 'package:erp_solution/service/api_service.dart';
import 'package:erp_solution/utils/api_end_points.dart';

class NotificationsService {
  final ApiService apiService;
  NotificationsService(this.apiService);

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await apiService.dio.get(
        ApiEndPoints.notificationListApi,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Ensure response.data is a Map
      final data = response.data;
      if (data is! Map<String, dynamic> || !data.containsKey('Result')) {
        throw Exception("Unexpected response format");
      }

      final List<dynamic> responseBody = data['Result'];
      return responseBody
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Failed to load notifications: $e");
    }
  }

  Future<List<NotificationTypeModel>> getNotificationTypes() async {
    try {
      final response = await apiService.dio.get(
        ApiEndPoints.notificationTypesApi,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final data = response.data;
      if (data is! Map<String, dynamic> || !data.containsKey('Result')) {
        throw Exception("Unexpected response format");
      }

      final List<dynamic> responseBody = data['Result'];
      return responseBody
          .map((json) => NotificationTypeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Failed to load notification types: $e");
    }
  }
}
