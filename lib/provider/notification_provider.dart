import 'package:erp_solution/models/notification_model.dart';
import 'package:erp_solution/models/notification_type_model.dart';
import 'package:erp_solution/service/notifications_service.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationsService service;
  NotificationProvider(this.service);

  bool _isLoading = false;
  String? _error;
  List<NotificationModel>? _notifications;
  List<NotificationTypeModel>? _notificationTypes;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<NotificationModel>? get notifications => _notifications;
  List<NotificationTypeModel>? get notificationTypes => _notificationTypes;

  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notifications = await service.fetchNotifications();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNotificationTypes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notificationTypes = await service.getNotificationTypes();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
