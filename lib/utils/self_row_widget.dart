import 'package:flutter/material.dart';

class SelfRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const SelfRowWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
