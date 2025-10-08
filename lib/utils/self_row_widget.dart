import 'package:flutter/material.dart';

class SelfRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const SelfRowWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(value, softWrap: true, overflow: TextOverflow.visible),
        ),
      ],
    );
  }
}
