import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/components/utils/utils.dart';
import 'package:zrd_despesas_app/components/zr_espaco.dart';
import 'package:zrd_despesas_app/components/zr_input.dart';
import 'package:zrd_despesas_app/components/zr_input_number.dart';
import 'package:zrd_despesas_app/components/zr_inputdata.dart';
import 'package:zrd_despesas_app/components/zr_modal_opcoes.dart';
import 'package:zrd_despesas_app/models/model_despesa.dart';

class EmitirDespesa extends StatefulWidget {
  const EmitirDespesa({super.key});

  @override
  State<EmitirDespesa> createState() => _EmitirDespesaState();
}

class _EmitirDespesaState extends State<EmitirDespesa> {
  final descricao = TextEditingController();
  final valor = TextEditingController();

  final despesa = ModelDespesa(
    dtemissao: null,
    descricao: '',
    idCategoria: null,
    valor: 0,
  );

  @override
  void dispose() {
    descricao.dispose();
    valor.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    descricao.addListener(() {
      despesa.descricao = descricao.text;
      setState(() {});
    });

    valor.addListener(() {
      despesa.valor = parseMoeda(valor.text);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          children: [
            ZrShowDatePicker(
              label: 'DATA',
              value: despesa.dtemissao,
              onChanged: (novadata) {
                setState(() {
                  despesa.dtemissao = novadata;
                });
              },
            ),
            ZrTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'informe a descricao';
                }

                return null;
              },
              controller: descricao,
              label: 'DESCRICAO',
            ),
            const ZrEspaco(),
            ZrInputNumber(
              label: 'VALOR',
              controller: valor,
              validator: (value) {
                final valorNumero = parseMoeda(value ?? '');

                if (valorNumero <= 0) {
                  return 'valor precisa ser informado';
                }

                return null;
              },
            ),
            const ZrEspaco(),
            Text(despesa.dadosEmString()),
            const ZrEspaco(),
            ZrModalOpcoes(
              label: 'Tipo de despesa',
              value: despesa.idCategoria,
              opcoes: const ['Alimentacao', 'Transporte', 'Hospedagem'],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'selecione o tipo de despesa';
                }

                return null;
              },
              onChanged: (novoValor) {
                setState(() {
                  despesa.idCategoria = novoValor;
                });
              },
            ),
            const ZrEspaco(),
            TextButton(
              onPressed: () => setState(() {}),
              child: const Text('Incluir Despesa'),
            ),
          ],
        ),
      ),
    );
  }
}
