import 'package:flutter/material.dart';

class AreaTextField extends StatelessWidget {
  final TextEditingController controller;
  const AreaTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Area *",
        prefixIcon: const Icon(Icons.map),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Area is required' : null,
    );
  }
}
