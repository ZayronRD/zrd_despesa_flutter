import 'package:flutter/material.dart';

class ZrToast {
  static void error(
    BuildContext context,
    String mensagem, {
    int milliseconds = 1000,
  }) {
    _show(context, mensagem, Colors.red, milliseconds);
  }

  static void success(
    BuildContext context,
    String mensagem, {
    int milliseconds = 2000,
  }) {
    _show(context, mensagem, Colors.green, milliseconds);
  }

  static void info(
    BuildContext context,
    String mensagem, {
    int milliseconds = 1000,
  }) {
    _show(context, mensagem, Colors.blue, milliseconds);
  }

  static void _show(
    BuildContext context,
    String mensagem,
    Color color,
    int milliseconds,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: color,
          duration: Duration(milliseconds: milliseconds),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
