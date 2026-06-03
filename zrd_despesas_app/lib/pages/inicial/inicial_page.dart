import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/auth/auth_service.dart';
import 'package:zrd_despesas_app/pages/despesas/insert/emitir_despesa.dart';
import 'package:zrd_despesas_app/pages/profile_page.dart';

class CardPage extends StatelessWidget {
  final String cardName;
  final VoidCallback onTap;

  const CardPage({super.key, required this.cardName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white30,
      // width: 300,
      shape: BeveledRectangleBorder(borderRadius: BorderRadiusGeometry.zero),
      margin: EdgeInsets.all(8),
      // height: 100,
      elevation: 1,
      clipBehavior: .hardEdge,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(
            child: Text(
              cardName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                // color: Colors.red,
                // fontStyle: FontStyle.italic,

                // decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InicialPage extends StatelessWidget {
  final authservice = AuthService();

  InicialPage({super.key});

  @override
  Widget build(BuildContext context) {
    void logout() async {
      await authservice.logout();
    }

    final telas = [
      (titulo: 'EMITIR DESPESA', pagina: const EmitirDespesa()),
      (titulo: 'MINHAS DESPESAS', pagina: const MinhasDespesas()),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          // Text("SAIR ->", style: TextStyle(color: Colors.white)),
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
        title: Text("HOME", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final card in telas)
              CardPage(
                cardName: card.titulo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => card.pagina),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
