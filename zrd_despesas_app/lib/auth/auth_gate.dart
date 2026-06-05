import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/pages/inicial/inicial_page.dart';
import 'package:zrd_despesas_app/pages/login/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        //carregando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final sessao = snapshot.hasData ? snapshot.data!.session : null;

        if (sessao != null) {
          return InicialPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
