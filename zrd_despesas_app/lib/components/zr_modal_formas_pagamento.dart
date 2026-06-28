import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/components/zr_appbar.dart';
import 'package:zrd_despesas_app/models/model_forma_pagamento.dart';

class ZrModalFormasPagamento extends StatelessWidget {
  final String label;
  final String? value;
  final List<ModelFormaPagamento> opcoes;
  final ValueChanged<ModelFormaPagamento> onChanged;
  final String? Function(String?)? validator;

  const ZrModalFormasPagamento({
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
        final selecionado = await showModalBottomSheet<ModelFormaPagamento>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.white,
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                appBar: ZrAppbar(title: "FORMAS DE PAGAMENTO"),
                body: opcoes.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma forma de pagamento foi encontrada!',
                        ),
                      )
                    : ListView.separated(
                        itemCount: opcoes.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final opcao = opcoes[index];

                          return ListTile(
                            title: Text(opcao.descricao),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pop(context, opcao);
                            },
                          );
                        },
                      ),
              ),
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
