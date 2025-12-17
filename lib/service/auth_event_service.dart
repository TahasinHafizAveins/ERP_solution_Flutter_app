// lib/service/auth_event_service.dart
import 'package:flutter/material.dart';

class AuthEventService {
  static final AuthEventService _instance = AuthEventService._internal();
  factory AuthEventService() => _instance;
  AuthEventService._internal();

  // Listeners for auth events
  final List<VoidCallback> _onTokenExpiredListeners = [];

  void addTokenExpiredListener(VoidCallback listener) {
    _onTokenExpiredListeners.add(listener);
  }

  void removeTokenExpiredListener(VoidCallback listener) {
    _onTokenExpiredListeners.remove(listener);
  }

  void notifyTokenExpired() {
    print(
      "Notifying ${_onTokenExpiredListeners.length} listeners about token expiration",
    );
    for (final listener in _onTokenExpiredListeners) {
      try {
        listener();
      } catch (e) {
        print("Error in token expired listener: $e");
      }
    }
  }
}
