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
      title: const Center(
        // child: Text(
        //   'CONFIRMAR?',
        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        // ),
      ),
      content: const Text(
        'Deseja realmente continuar?',
        textAlign: TextAlign.center,
      ),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.green.shade700,
                  // shape: const RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.zero,
                  // ),
                  // minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'SIM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  // shape: const RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.zero,
                  // ),
                  // minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'NÃO',
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
