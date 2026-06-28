import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/components/zr_appbar.dart';
import 'package:zrd_despesas_app/components/zr_espaco.dart';
import 'package:zrd_despesas_app/components/zr_input.dart';
import 'package:zrd_despesas_app/components/zr_toast.dart';
import 'package:zrd_despesas_app/models/model_forma_pagamento.dart';
import 'package:zrd_despesas_app/pages/configuracao/formas_pagamento/hooks.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<StatefulWidget> createState() => _Cadastro();
}

class _Cadastro extends State<Cadastro> {
  final HooksFormasPagamento hooks = HooksFormasPagamento();
  final _novaFormaDePagamento = TextEditingController();

  final formaDePagamentoNova = ModelFormaPagamento(id: "", descricao: "");

  Future<void> salvar(String id) async {
    try {
      await hooks.insert(formaDePagamentoNova);

      if (!mounted) return;

      ZrToast.success(context, "Nova forma de pagamento incluída!");

      // await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ZrToast.error(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    _novaFormaDePagamento.addListener(() {
      formaDePagamentoNova.descricao = _novaFormaDePagamento.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZrAppbar(title: "NOVA FORMA DE PAGAMENTO"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ZrTextFormField(
              controller: _novaFormaDePagamento,
              label: "Descrição da forma de pagamento",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  ZrToast.error(
                    context,
                    "Informe a descrição da forma de pagamento",
                  );
                }
                return null;
              },
            ),
            ZrEspaco(),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey.shade300,
              ),
              onPressed: () async {
                await salvar(formaDePagamentoNova.descricao);
              },
              child: Text("SALVAR"),
            ),
          ],
        ),
      ),
    );
  }
}
