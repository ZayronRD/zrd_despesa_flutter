import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/components/zr_espaco.dart';
import 'package:zrd_despesas_app/components/zr_input.dart';
import 'package:zrd_despesas_app/components/zr_toast.dart';
import 'package:zrd_despesas_app/models/model_categoria.dart';
import 'package:zrd_despesas_app/pages/configuracao/categorias/hooks.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<StatefulWidget> createState() => _Cadadastro();
}

class _Cadadastro extends State<Cadastro> {
  final HooksCategoria hooks = HooksCategoria();
  final _novaCategoria = TextEditingController();

  final categoriaNova = ModelCategoria(id: "", descricao: "");

  Future<void> salvar(String id) async {
    try {
      await hooks.insert(categoriaNova);

      if (!mounted) return;

      ZrToast.success(context, "Nova categoria incluída!");

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

    _novaCategoria.addListener(() {
      categoriaNova.descricao = _novaCategoria.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,
        title: Text("NOVA CATEGORIA", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ZrTextFormField(
              controller: _novaCategoria,
              label: "Descrição da Categoria",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  ZrToast.error(context, "Informe a descricao da categoria");
                }
                return null;
              },
            ),
            ZrEspaco(),
            TextButton(
              onPressed: () async {
                await salvar(categoriaNova.descricao);
              },
              child: Text("SALVAR"),
            ),
          ],
        ),
      ),
    );
  }
}
