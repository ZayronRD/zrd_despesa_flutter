import 'package:flutter/material.dart';

class ZrTextFormField extends StatelessWidget {
  final TextEditingController controller;

  final String label;

  final String? Function(String?)? validator;

  final bool obscureText;

  const ZrTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label),
    );
  }
}
