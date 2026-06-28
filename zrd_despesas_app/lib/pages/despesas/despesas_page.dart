import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zrd_despesas_app/auth/auth_service.dart';
import 'package:zrd_despesas_app/components/zr_appbar.dart';
import 'package:zrd_despesas_app/components/zr_confirm.dart';
import 'package:zrd_despesas_app/models/model_despesa.dart';
import 'package:zrd_despesas_app/pages/despesas/hooks_despesa.dart';

class MinhasDespesas extends StatefulWidget {
  const MinhasDespesas({super.key});

  @override
  State<StatefulWidget> createState() => _MinhasDespesasState();
}

class _MinhasDespesasState extends State<MinhasDespesas> {
  final authservice = AuthService();
  final dtoDespesa = Despesa();
  late Future<List<ModelDespesa>> _futureDespesas;
  final moeda = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    _futureDespesas = dtoDespesa.get();
  }

  void recarregarDespesas() {
    setState(() {
      _futureDespesas = dtoDespesa.get();
    });
  }

  String formatarData(DateTime? data) {
    if (data == null) return '--/--/----';

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();
    return '$dia/$mes/$ano';
  }

  String formatarMoeda(double valor) {
    final formatado = moeda.format(valor);
    if (formatado.endsWith(',00')) {
      return formatado.substring(0, formatado.length - 3);
    }
    return formatado;
  }

  Widget infoBadge(IconData icon, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              // color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> excluirDespesa(ModelDespesa despesa) async {
    final id = despesa.id;
    if (id == null) return;

    final confirmou = await ZrConfirm.confirm(context);
    if (!confirmou) return;

    try {
      await dtoDespesa.delete(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Despesa excluida com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );

      recarregarDespesas();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir despesa: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailUsuario = authservice.emailUsuario();

    return Scaffold(
      appBar: ZrAppbar(
        title: "DESPESAS",

        actions: [
          IconButton(
            onPressed: recarregarDespesas,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<ModelDespesa>>(
        future: _futureDespesas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar despesas: ${snapshot.error}'),
            );
          }

          final despesas = snapshot.data ?? [];
          if (despesas.isEmpty) {
            return Center(
              child: Text(
                'Nenhuma despesa cadastrada para ${emailUsuario ?? "usuario"}.',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: despesas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final despesa = despesas[index];

              return Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          infoBadge(
                            Icons.calendar_month_outlined,
                            formatarData(despesa.dtemissao),
                          ),
                          const Spacer(),
                          Text(
                            formatarMoeda(despesa.valor),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              // color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          infoBadge(
                            Icons.category_outlined,
                            despesa.categoria ?? 'Sem categoria',
                          ),
                          infoBadge(
                            Icons.receipt_long_outlined,
                            despesa.formaPagamento ?? 'Sem tipo',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'DESCRIÇÃO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        despesa.descricao,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 12),

                      TextButton.icon(
                        onPressed: () => excluirDespesa(despesa),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red),
                        ),
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
