import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/components/zr_confirm.dart';
import 'package:zrd_despesas_app/components/zr_toast.dart';
import 'package:zrd_despesas_app/models/model_categoria.dart';
import 'package:zrd_despesas_app/pages/configuracao/categorias/cadastro.dart';
import 'package:zrd_despesas_app/pages/configuracao/categorias/hooks.dart';

class ListaCategoriasPage extends StatefulWidget {
  const ListaCategoriasPage({super.key});

  @override
  State<ListaCategoriasPage> createState() => _ListaCategoriasPageState();
}

class _ListaCategoriasPageState extends State<ListaCategoriasPage> {
  final HooksCategoria hooks = HooksCategoria();

  late Future<List<ModelCategoria>> _futureCategorias;

  @override
  void initState() {
    super.initState();
    _futureCategorias = hooks.get();
  }

  Future<void> deletar(String id) async {
    try {
      await hooks.delete(id);

      if (!mounted) return;

      ZrToast.success(context, "Categoria excluída!");

      setState(() {
        _futureCategorias = hooks.get();
      });
    } catch (e) {
      if (!mounted) return;

      ZrToast.error(context, e.toString(), milliseconds: 2400);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("CATEGORIAS", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            tooltip: "NOVA CATEGORIA",
            onPressed: () async {
              final atualizou = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => Cadastro()),
              );

              if (atualizou == true) {
                setState(() {
                  _futureCategorias = hooks.get();
                });
              }
            },
            icon: Icon(Icons.add, size: 40, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<ModelCategoria>>(
        future: _futureCategorias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar categorias: ${snapshot.error}"),
            );
          }

          final categorias = snapshot.data ?? [];

          if (categorias.isEmpty) {
            return const Center(child: Text('Nenhuma categoria encontrada!'));
          }

          return ListView.separated(
            itemCount: categorias.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final categoria = categorias[index];

              return Card(
                child: ListTile(
                  // leading: Text(categoria.id.toString()),
                  title: Text(categoria.descricao),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          final confirmou = await ZrConfirm.confirm(context);

                          if (confirmou) {
                            deletar(categoria.id);
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
