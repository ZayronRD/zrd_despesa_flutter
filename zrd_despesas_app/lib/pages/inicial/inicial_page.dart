import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/auth/auth_service.dart';

class CardPage extends StatelessWidget {
  final String cardName;

  const CardPage({super.key, required this.cardName});

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
        // splashColor: Colors.black,
        onTap: () {
          debugPrint('Card tapped.');
        },
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
  // const InicialPage({super.key});

  final authservice = AuthService();

  InicialPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> dados = ["EMITIR DESPESA", "DESPESAS", "TESTES DEV_"];

    void logout() async {
      await authservice.logout();
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Text("SAIR ->"),

          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
        title: Text("HOME", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [for (var dado in dados) CardPage(cardName: dado)],
        ),
      ),
    );
  }
}
