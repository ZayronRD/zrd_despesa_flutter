import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/components/zr_appbar.dart';
import 'package:zrd_despesas_app/components/zr_confirm.dart';
import 'package:zrd_despesas_app/components/zr_toast.dart';
import 'package:zrd_despesas_app/models/model_forma_pagamento.dart';
import 'package:zrd_despesas_app/pages/configuracao/formas_pagamento/cadastro.dart';
import 'package:zrd_despesas_app/pages/configuracao/formas_pagamento/hooks.dart';

class ListaFormasPagamento extends StatefulWidget {
  const ListaFormasPagamento({super.key});

  @override
  State<ListaFormasPagamento> createState() => _ListaFormasPagamentoState();
}

class _ListaFormasPagamentoState extends State<ListaFormasPagamento> {
  final HooksFormasPagamento hooks = HooksFormasPagamento();

  late Future<List<ModelFormaPagamento>> _futureFormasDePagamento;

  @override
  void initState() {
    super.initState();
    _futureFormasDePagamento = hooks.get();
  }

  Future<void> deletar(String id) async {
    try {
      await hooks.delete(id);

      if (!mounted) return;

      ZrToast.success(context, "Forma de pagamento excluída!");

      setState(() {
        _futureFormasDePagamento = hooks.get();
      });
    } catch (e) {
      if (!mounted) return;

      ZrToast.error(context, e.toString(), milliseconds: 2400);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZrAppbar(
        title: "FORMAS DE PAGAMENTO",
        actions: [
          IconButton(
            tooltip: "NOVA FORMA DE PAGAMENTO",
            onPressed: () async {
              final atualizou = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => Cadastro()),
              );

              if (atualizou == true) {
                setState(() {
                  _futureFormasDePagamento = hooks.get();
                });
              }
            },
            icon: Icon(Icons.add, size: 40, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<ModelFormaPagamento>>(
        future: _futureFormasDePagamento,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar forma de pagamento: ${snapshot.error}",
              ),
            );
          }

          final formasPagamento = snapshot.data ?? [];

          if (formasPagamento.isEmpty) {
            return const Center(
              child: Text('Nenhuma forma de pagamento encontrada!'),
            );
          }

          return ListView.separated(
            itemCount: formasPagamento.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final formaPag = formasPagamento[index];

              return Card(
                child: ListTile(
                  title: Text(formaPag.descricao),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          final confirmou = await ZrConfirm.confirm(context);

                          if (confirmou) {
                            deletar(formaPag.id);
                          }
                          // ,
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
