class SignalRNotificationService {
  /*  late HubConnection _connection;

  Future<void> initSignalR() async {
    _connection = HubConnectionBuilder()
        .withUrl(
          "https://nagaderp.mynagad.com:7070/HRMS/hubs/notification",
          HttpConnectionOptions(
            accessTokenFactory: () async => "<Your JWT Token>",
          ),
        )
        .build();

    await _connection.start();

    print("Connected to SignalR");

    // 🔥 LISTEN TO NOTIFICATIONS
    _connection.on("ReceiveNotification", (message) async {
      print("Received from hub: $message");

      // You will receive something like: ["{json}"] OR ["Your message"]
      final raw = message?[0];

      // If backend sends JSON, decode it:
      try {
        final model = NotificationModel.fromJson(raw);
        NotificationService.show(
          model.title ?? "New Notification",
          model.message ?? "",
        );
      } catch (e) {
        // backend sending plain string? show as text
        NotificationsService.show("New Notification", raw.toString());
      }
    });
  }*/
}
