import 'package:flutter/material.dart';

class ColorWidget {
  static Color getStatusColor(String status) {
    final lowerStatus = status.toLowerCase();

    if (lowerStatus.contains("present") || lowerStatus.contains("on time")) {
      return Colors.green.shade600; // Green for present/on time
    } else if (lowerStatus.contains("late")) {
      return Colors.orange.shade600; // Orange for late
    } else if (lowerStatus.contains("absent")) {
      return Colors.red.shade600; // Red for absent
    } else if (lowerStatus.contains("leave")) {
      return Colors.blue.shade600; // Blue for leave
    } else if (lowerStatus.contains("holiday")) {
      return Colors.purple.shade600; // Purple for holiday
    }
    return Colors.grey.shade600; // Default grey
  }
}
