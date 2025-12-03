import 'package:signalr_core/signalr_core.dart';

import 'notification_service.dart';

class SignalRNotificationService {
  static final SignalRNotificationService _instance =
      SignalRNotificationService._internal();
  factory SignalRNotificationService() => _instance;
  SignalRNotificationService._internal();

  HubConnection? _connection;
  bool _isConnected = false;
  bool _isInitialized = false;
  bool _isConnecting = false;
  String? _lastNotificationHash;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    print('SignalR Service Initialized');
  }

  Future<void> startConnection(String token) async {
    if (_isConnecting || _isConnected) {
      print('SignalR: Connection already in progress or established');
      return;
    }

    try {
      _isConnecting = true;

      // Stop existing connection if any
      await stopConnection();

      if (token.isEmpty) {
        print('No token provided for SignalR connection');
        _isConnecting = false;
        return;
      }

      _connection = HubConnectionBuilder()
          .withUrl(
            "https://nagaderp.mynagad.com:7070/HRMS/hubs/notification",
            HttpConnectionOptions(
              accessTokenFactory: () async => token,
              logging: (level, message) => print('SignalR: $message'),
            ),
          )
          .build();

      // Setup event handlers
      _setupEventHandlers();

      await _connection!.start();
      _isConnected = true;
      _isConnecting = false;
      print('✅ SignalR Connected Successfully');
    } catch (e) {
      _isConnecting = false;
      _isConnected = false;
      print('❌ SignalR Connection Failed: $e');
    }
  }

  void _setupEventHandlers() {
    if (_connection == null) return;

    _connection!.onclose((error) {
      _isConnected = false;
      print('SignalR Connection Closed: ${error ?? "No error"}');
    });

    _connection!.on("ReceiveNotification", (message) {
      print('📨 SignalR Notification Received: $message');
      _handleNotification(message);
    });

    _connection!.onreconnecting((error) {
      print('SignalR Reconnecting: $error');
      _isConnected = false;
    });

    _connection!.onreconnected((connectionId) {
      _isConnected = true;
      print('SignalR Reconnected: $connectionId');
    });
  }

  void _handleNotification(List<dynamic>? message) {
    if (message == null || message.isEmpty) return;

    try {
      final raw = message[0];

      // Enhanced deduplication - use a combination of content and timestamp
      final now = DateTime.now();
      final notificationHash =
          '$raw-${now.millisecondsSinceEpoch ~/ 1000}'; // Hash by second

      if (_lastNotificationHash == notificationHash) {
        print('🔄 Duplicate notification ignored: $raw');
        return;
      }

      _lastNotificationHash = notificationHash;

      print('📨 Raw notification data: $raw');
      print('🔍 Data type: ${raw.runtimeType}');

      String title = "People & Culture";
      String body = "";

      if (raw is String) {
        if (raw == "RemoteAttendance") {
          title = "Attendance Update";
          body = "Remote attendance has been recorded successfully";
        } else {
          body = _formatNotificationBody(raw);
        }
      }

      // Show local notification
      print('🎯 Showing notification: $title - $body');
      NotificationService.show(title, body);
    } catch (e) {
      print('❌ Error handling notification: $e');
      NotificationService.show("People & Culture", "New notification received");
    }
  }

  String _formatNotificationBody(String raw) {
    // Add custom formatting for known notification types
    switch (raw) {
      case "RemoteAttendance":
        return "Remote attendance has been recorded successfully";
      case "LeaveApproved":
        return "Your leave request has been approved";
      case "LeaveRejected":
        return "Your leave request has been rejected";
      case "NewTask":
        return "You have been assigned a new task";
      default:
        // Convert camelCase to readable text
        return raw
            .replaceAllMapped(RegExp(r'([A-Z])'), (Match m) => ' ${m[1]}')
            .trim();
    }
  }

  Future<void> stopConnection() async {
    _isConnecting = false;
    if (_isConnected && _connection != null) {
      try {
        await _connection!.stop();
        _isConnected = false;
        _connection = null;
        print('SignalR Connection Stopped');
      } catch (e) {
        print('Error stopping SignalR: $e');
      }
    }
  }

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
}
