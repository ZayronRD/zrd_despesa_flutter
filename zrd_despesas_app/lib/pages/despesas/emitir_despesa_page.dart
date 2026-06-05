import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/components/utils/utils.dart';
import 'package:zrd_despesas_app/components/zr_confirm.dart';
import 'package:zrd_despesas_app/components/zr_espaco.dart';
import 'package:zrd_despesas_app/components/zr_input.dart';
import 'package:zrd_despesas_app/components/zr_input_number.dart';
import 'package:zrd_despesas_app/components/zr_inputdata.dart';
import 'package:zrd_despesas_app/components/zr_modal_categorias.dart';
import 'package:zrd_despesas_app/components/zr_modal_formas_pagamento.dart';
import 'package:zrd_despesas_app/components/zr_toast.dart';
import 'package:zrd_despesas_app/models/model_categoria.dart';
import 'package:zrd_despesas_app/models/model_despesa.dart';
import 'package:zrd_despesas_app/models/model_forma_pagamento.dart';
import 'package:zrd_despesas_app/pages/configuracao/categorias/hooks.dart'
    show HooksCategoria;
import 'package:zrd_despesas_app/pages/configuracao/formas_pagamento/hooks.dart';
import 'package:zrd_despesas_app/pages/despesas/hooks_despesa.dart';

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
    categoria: null,
    valor: 0,
    formaPagamento: null,
  );

  bool despesaValida(ModelDespesa d) {
    return d.categoria != null &&
        d.formaPagamento != null &&
        d.descricao.trim().isNotEmpty &&
        d.valor > 0;
  }

  ModelCategoria? categoriaSelecionada;
  List<ModelCategoria> categorias = [];
  bool carregandoCategorias = false;
  final HooksCategoria hookCategoria = HooksCategoria();

  ModelFormaPagamento? formaPagamentoSelecionada;
  List<ModelFormaPagamento> formasPagamento = [];
  bool carregandoFormasPagamento = false;
  final HooksFormasPagamento hookFormasPagamento = HooksFormasPagamento();

  @override
  void dispose() {
    descricao.dispose();
    valor.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    carregarCategorias();
    carregarFormasPagamento();

    descricao.addListener(() {
      despesa.descricao = descricao.text;
      setState(() {});
    });

    valor.addListener(() {
      despesa.valor = parseMoeda(valor.text);
      setState(() {});
    });
  }

  Future<void> carregarCategorias() async {
    setState(() {
      carregandoCategorias = true;
    });

    try {
      final resultado = await hookCategoria.get();

      if (!mounted) return;

      setState(() {
        categorias = resultado;
      });
    } finally {
      if (mounted) {
        setState(() {
          carregandoCategorias = false;
        });
      }
    }
  }

  Future<void> carregarFormasPagamento() async {
    setState(() {
      carregandoFormasPagamento = true;
    });

    try {
      final resultado = await hookFormasPagamento.get();

      if (!mounted) return;

      setState(() {
        formasPagamento = resultado;
      });
    } finally {
      if (mounted) {
        setState(() {
          carregandoFormasPagamento = false;
        });
      }
    }
  }

  final Despesa hookDespesa = Despesa();

  Future<void> salvar(ModelDespesa d) async {
    try {
      if (!despesaValida(d)) {
        ZrToast.error(context, "Todos os campos devem ser preenchidos!");
        return;
      }
      await hookDespesa.insert(d);

      if (!mounted) return;

      ZrToast.success(context, "Despesa Lançada!");

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ZrToast.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("EMITIR DESPESA", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
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
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return "informe a descricao";
                  //   }
                  //   return null;
                  // },
                  controller: descricao,
                  label: "DESCRIÇÃO",
                ),
                ZrEspaco(),

                if (carregandoCategorias)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: CircularProgressIndicator(),
                  )
                else
                  ZrModalCategorias(
                    label: 'CATEGORIA',
                    value: categoriaSelecionada?.descricao,
                    opcoes: categorias,
                    onChanged: (novoValor) {
                      setState(() {
                        categoriaSelecionada = novoValor;
                        despesa.categoria = novoValor.id;
                      });
                    },
                  ),

                ZrEspaco(),

                if (carregandoFormasPagamento)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: CircularProgressIndicator(),
                  )
                else
                  ZrModalFormasPagamento(
                    label: 'FORMA DE PAGAMENTO',
                    value: formaPagamentoSelecionada?.descricao,
                    opcoes: formasPagamento,
                    onChanged: (novoValor) {
                      setState(() {
                        formaPagamentoSelecionada = novoValor;
                        despesa.formaPagamento = novoValor.id;
                      });
                    },
                  ),
                ZrEspaco(),

                ZrInputNumber(
                  label: "VALOR",
                  controller: valor,
                  // validator: (value) {
                  //   final valorNumero = parseMoeda(value ?? '');

                  //   if (valorNumero <= 0) {
                  //     return "valor precisa ser informado";
                  //   }

                  //   return null;
                  // },
                ),
                ZrEspaco(),
                TextButton(
                  onPressed: () async {
                    final confirmou = await ZrConfirm.confirm(context);

                    if (confirmou) {
                      salvar(despesa);
                    }
                  },
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
