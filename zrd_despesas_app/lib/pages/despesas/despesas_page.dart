import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/auth/auth_service.dart';
import 'package:zrd_despesas_app/components/zr_confirm.dart';
import 'package:zrd_despesas_app/models/model_despesa.dart';
import 'package:zrd_despesas_app/models/model_despesa_imagem.dart';
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
  bool _abrindoImagens = false;
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

  Future<List<ModelDespesaImagem>> gerarUrlsImagens(
    List<ModelDespesaImagem> imagens,
  ) async {
    final storage = Supabase.instance.client.storage.from('despesa-imagens');
    final imagensComUrl = <ModelDespesaImagem>[];

    for (final imagem in imagens) {
      final storagePath = imagem.storagePath;
      if (storagePath == null || storagePath.isEmpty) continue;

      try {
        final signedUrl = await storage.createSignedUrl(storagePath, 60);
        imagensComUrl.add(imagem.copyWith(signedUrl: signedUrl));
      } catch (_) {}
    }

    return imagensComUrl;
  }

  Future<void> abrirImagensDespesa(ModelDespesa despesa) async {
    if (_abrindoImagens) return;

    setState(() {
      _abrindoImagens = true;
    });

    final imagens = await gerarUrlsImagens(despesa.imagens);

    if (!mounted) return;

    if (imagens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nao foi possivel localizar as imagens desta despesa.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _abrindoImagens = false;
      });
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return SizedBox(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Imagens da despesa ${despesa.id ?? ""}'),
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
            body: imagens.isEmpty
                ? const Center(child: Text('Nenhuma imagem encontrada.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: imagens.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final imagem = imagens[index];

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imagem.signedUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) {
                            return Container(
                              height: 220,
                              color: Colors.black12,
                              alignment: Alignment.center,
                              child: const Text('Erro ao carregar imagem.'),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );

    if (!mounted) return;

    setState(() {
      _abrindoImagens = false;
    });
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("DESPESAS", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.blueGrey,
        titleTextStyle: const TextStyle(color: Colors.white),
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
                          infoBadge(
                            Icons.photo_library_outlined,
                            '${despesa.imagens.length} imagens',
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          spacing: 8,
                          children: [
                            TextButton.icon(
                              onPressed: despesa.imagens.isEmpty
                                  ? null
                                  : () => abrirImagensDespesa(despesa),
                              icon: const Icon(
                                Icons.photo_library,
                                color: Colors.blueGrey,
                              ),
                              label: const Text(
                                'Ver imagens',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
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
