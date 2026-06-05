import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/auth/auth_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final emailUsuario = authservice.emailUsuario();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("DESPESAS", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.blueGrey,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: FutureBuilder<List<ModelDespesa>>(
        future: _futureDespesas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                child: ListTile(
                  title: Text(despesa.descricao),
                  subtitle: Text(
                    '${despesa.categoria ?? "Sem tipo"} • ${formatarData(despesa.dtemissao)}',
                  ),
                  trailing: Text(
                    'R\$ ${despesa.valor.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 15),
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
