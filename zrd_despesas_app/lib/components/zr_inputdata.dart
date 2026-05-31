import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ZrShowDatePicker extends StatelessWidget {
  final String label; // nome do campo

  final DateTime? value; // data atual do campo

  final Function(DateTime?) onChanged; //função para devolver data escolhida

  const ZrShowDatePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: value != null ? DateFormat('dd/MM/yy').format(value!) : '',
      ),
      decoration: InputDecoration(labelText: label),
      onTap: () async {
        final dataEscolhida = await showDatePicker(
          context: context,
          locale: const Locale('pt', 'BR'),
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          helpText: 'Selecione a data',
          cancelText: 'Cancelar',
          confirmText: 'Confirmar',
        );
        if (dataEscolhida != null) {
          onChanged(dataEscolhida);
        }
      },
    );
  }
}
