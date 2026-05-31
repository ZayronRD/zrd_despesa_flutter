import 'package:flutter/material.dart';

class ZrModalOpcoes extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> opcoes;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  const ZrModalOpcoes({
    super.key,
    required this.label,
    required this.value,
    required this.opcoes,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: value ?? ''),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.keyboard_arrow_down),
      ),
      onTap: () async {
        final selecionado = await showModalBottomSheet<String>(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return ListView(
              children: opcoes.map((opcao) {
                return ListTile(
                  title: Text(opcao),
                  onTap: () {
                    Navigator.pop(context, opcao);
                  },
                );
              }).toList(),
            );
          },
        );

        if (selecionado != null) {
          onChanged(selecionado);
        }
      },
    );
  }
}
