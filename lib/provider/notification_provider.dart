import 'package:erp_solution/models/notification_model.dart';
import 'package:erp_solution/models/notification_type_model.dart';
import 'package:erp_solution/service/notifications_list_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationsListService service;
  NotificationProvider(this.service);

  bool _isLoading = false;
  String? _error;
  List<NotificationModel>? _notifications;
  List<NotificationTypeModel>? _notificationTypes;
  Set<String> _readNotificationIds = {}; // Track read notification IDs

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<NotificationModel>? get notifications => _notifications;
  List<NotificationTypeModel>? get notificationTypes => _notificationTypes;

  int get unreadCount {
    if (_notifications == null) return 0;
    return _notifications!
        .where(
          (notification) =>
              !_readNotificationIds.contains(_getNotificationId(notification)),
        )
        .length;
  }

  // Helper method to generate a unique ID for each notification
  String _getNotificationId(NotificationModel notification) {
    return '${notification.aPEmployeeFeedbackID}-${notification.referenceID}-${notification.feedbackRequestDate}';
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notifications = await service.fetchNotifications();
      // Load previously read notifications from storage
      await _loadReadNotifications();
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

  // Mark a notification as read
  void markAsRead(NotificationModel notification) {
    final notificationId = _getNotificationId(notification);
    _readNotificationIds.add(notificationId);
    _saveReadNotifications();
    notifyListeners();
  }

  // Mark all notifications as read
  void markAllAsRead() {
    if (_notifications != null) {
      for (var notification in _notifications!) {
        final notificationId = _getNotificationId(notification);
        _readNotificationIds.add(notificationId);
      }
      _saveReadNotifications();
      notifyListeners();
    }
  }

  // Check if a notification is read
  bool isNotificationRead(NotificationModel notification) {
    return _readNotificationIds.contains(_getNotificationId(notification));
  }

  // Load read notifications from local storage
  Future<void> _loadReadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final readIds = prefs.getStringList('read_notification_ids') ?? [];
    _readNotificationIds = readIds.toSet();
  }

  // Save read notifications to local storage
  Future<void> _saveReadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'read_notification_ids',
      _readNotificationIds.toList(),
    );
  }

  // Clear all read status (for testing/logout)
  void clearReadStatus() {
    _readNotificationIds.clear();
    _saveReadNotifications();
    notifyListeners();
  }

  void clearData() {
    _notifications = null;
    _notificationTypes = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
