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
  ZROpcoes? tipoSelecionado;

  final despesa = ModelDespesa(
    dtemissao: null,
    descricao: '',
    tipo: null,
    valor: 0,
  );

  final List<ZROpcoes> opcoes = [
    ZROpcoes(id: '1', descricao: 'ALIMENTAÇÃO'),
    ZROpcoes(id: '2', descricao: 'TRANSPORTE'),
    ZROpcoes(id: '3', descricao: 'LAZER'),
    ZROpcoes(id: '4', descricao: 'CONTAS'),
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: Text("EMITIR DESPESA"),
        backgroundColor: Colors.grey.shade300,
        // actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              children: [
                ZrShowDatePicker(
                  label: "DATA",
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
                      return "informe a descricao";
                    }
                    return null;
                  },
                  controller: descricao,
                  label: "DESCRIÇÃO",
                ),
                ZrEspaco(),

                ZrModalOpcoes(
                  label: 'TIPO',
                  value: tipoSelecionado?.descricao,
                  opcoes: opcoes,
                  onChanged: (novoValor) {
                    setState(() {
                      tipoSelecionado = novoValor;
                      despesa.tipo = novoValor.id;
                    });
                  },
                ),

                ZrEspaco(),

                ZrInputNumber(
                  label: "VALOR",
                  controller: valor,
                  validator: (value) {
                    final valorNumero = parseMoeda(value ?? '');

                    if (valorNumero <= 0) {
                      return "valor precisa ser informado";
                    }

                    return null;
                  },
                ),
                ZrEspaco(),
                TextButton(
                  onPressed: () => setState(() {}),
                  child: Text("Incluir Despesa"),
                ),
                ZrEspaco(),

                Text(despesa.dadosEmString()),

                ZrEspaco(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
