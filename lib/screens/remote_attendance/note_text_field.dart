import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  final TextEditingController? controller;
  const NoteTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 3,
      controller: controller,
      decoration: InputDecoration(
        labelText: "Note (optional)",
        prefixIcon: const Icon(Icons.note_alt_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
