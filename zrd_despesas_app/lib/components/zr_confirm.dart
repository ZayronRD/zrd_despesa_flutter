import 'package:flutter/material.dart';

class ZrConfirm extends StatelessWidget {
  const ZrConfirm({super.key});

  static Future<bool> confirm(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => const ZrConfirm(),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
      title: const Center(),
      content: const Text('Confirmação', textAlign: TextAlign.center),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.grey.shade300,
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'NÃO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green.shade700,
                  backgroundColor: Colors.grey.shade300,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'SIM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
