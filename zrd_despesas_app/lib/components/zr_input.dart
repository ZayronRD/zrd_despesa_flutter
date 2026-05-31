import 'package:flutter/material.dart';

class ZrTextFormField extends StatelessWidget {
  final TextEditingController controller;

  final String label;

  final String? Function(String?)? validator;

  const ZrTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }
}
