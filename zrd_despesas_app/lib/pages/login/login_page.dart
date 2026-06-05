import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/auth/auth_service.dart';
import 'package:zrd_despesas_app/pages/cadastro/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();

  final _senhaController = TextEditingController();

  String _mensagemErroLogin(Object erro) {
    if (erro is AuthException) {
      final mensagem = erro.message.toLowerCase();

      // print("mensagem aqui $mensagem");

      if (mensagem.contains('invalid login credentials')) {
        return 'Email ou senha invalidos.';
      }

      if (mensagem.contains('email not confirmed')) {
        return 'Confirme seu email antes de entrar.';
      }

      if (mensagem.contains('too many requests')) {
        return 'Muitas tentativas. Aguarde um momento e tente novamente.';
      }

      if (mensagem.contains('network') || mensagem.contains('socket')) {
        return 'Falha de conexao. Verifique sua internet.';
      }

      return erro.message;
    }

    return 'Falha inesperada ao realizar login.';
  }

  void login() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(
      context,
    );

    if (email.isEmpty || senha.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Informe e-mail e senha!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!email.contains('@')) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Informe um e-mail valido!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // `signInWithPassword` retorna sessao e usuario quando login conclui.
      final resposta = await authService.login(email, senha);

      // Se auth nao devolver usuario ou sessao, fluxo nao autenticou.
      if (resposta.user == null || resposta.session == null) {
        throw const AuthException('Login nao retornou sessao valida.');
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(_mensagemErroLogin(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: SizedBox(
            // width: 100,
            // height: 100,
            child: Text(
              "ZR DESPESAS",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
                // fontStyle: FontStyle.italic,

                // decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.blueGrey,
        titleTextStyle: const TextStyle(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          // SizedBox(
          //   width: 100,
          //   height: 100,
          //   child: Image.asset("assets/imagens/logo.png"),
          // ),
          Center(
            child: SizedBox(
              // width: 100,
              // height: 100,
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  // color: Colors.red,
                  // fontStyle: FontStyle.italic,

                  // decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          // email
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "E-mail"),
          ),

          //senha
          TextField(
            obscureText: true,
            controller: _senhaController,
            decoration: InputDecoration(labelText: "Senha"),
          ),

          SizedBox(height: 12),

          // botao login
          ElevatedButton(onPressed: login, child: Text("Login")),

          SizedBox(height: 12),

          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            ),
            child: Container(
              // height: 60.0,
              // width: 120.0,
              padding: EdgeInsets.all(5.0),
              // decoration: BoxDecoration(
              //   color: Colors.grey,
              //   borderRadius: BorderRadius.circular(4.0),
              // ),
              child: Center(child: Text("Não tem uma conta? Clique Aqui")),
            ),
          ),
        ],
      ),
    );
  }
}
