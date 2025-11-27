import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Function()? onNotificationClick;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      // ANDROID SETTINGS
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // IOS SETTINGS
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // COMBINE SETTINGS
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle notification tap
          onNotificationClick?.call();
        },
      );

      // Create notification channel for Android
      await _createNotificationChannel();

      _initialized = true;
      print('Notification service initialized successfully');
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'erp_channel',
      'Nagad People & Culture',
      description: 'Notifications for Nagad People & Culture',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // SHOW NOTIFICATION
  static Future<void> show(String title, String body) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'erp_channel',
            'Nagad People & Culture',
            channelDescription: 'Notifications for Nagad People & Culture',
            importance: Importance.high,
            showWhen: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        details,
      );

      print('Notification shown: $title - $body');
    } catch (e) {
      print('Error showing notification: $e');
    }
  }
}
