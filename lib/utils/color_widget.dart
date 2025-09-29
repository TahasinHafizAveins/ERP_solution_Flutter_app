import 'package:flutter/material.dart';

class ColorWidget {
  static Color getStatusColor(String status) {
    final value = status.trim().toLowerCase() ?? "";
    switch (status.toLowerCase()) {
      case "present":
        return Colors.green.shade400;
      case "late":
        return Colors.red.shade400;
      case "absent":
        return Colors.orange.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}
