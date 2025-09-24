import 'package:flutter/material.dart';

extension WidgetExtensions on List<Widget> {
  /// Adds spacing between widgets in a horizontal Row
  List<Widget> withSpacing(double spacing) {
    if (isEmpty) return [];
    final List<Widget> spaced = [];
    for (var i = 0; i < length; i++) {
      spaced.add(this[i]);
      if (i != length - 1) spaced.add(SizedBox(width: spacing));
    }
    return spaced;
  }
}
