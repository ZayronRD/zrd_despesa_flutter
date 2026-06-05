import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
  final _apelidoController = TextEditingController();
  final _nomeCompletoController = TextEditingController();

  void registrarUsuario() async {
    final email = _emailController.text;
    final senha = _senhaController.text;
    final confirmaSenha = _confirmaSenhaController.text;
    final apelido = _apelidoController.text;
    final nomeCompleto = _nomeCompletoController.text;

    if (senha != confirmaSenha) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("As senhas não são iguais!")));
      return;
    }

    try {
      await authService.cadastro(nomeCompleto, apelido, email, senha);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("error $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar")),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          // nome completo
          TextField(
            controller: _nomeCompletoController,
            decoration: InputDecoration(labelText: "Nome completo"),
          ),
          //nome
          TextField(
            controller: _apelidoController,
            decoration: InputDecoration(labelText: "Apelido"),
          ),

          // email
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "E-mail"),
          ),

          //senha
          TextField(
            controller: _senhaController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Senha"),
          ),
          SizedBox(height: 12),

          // confirma a senha
          TextField(
            controller: _confirmaSenhaController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Confirmar senha"),
          ),

          SizedBox(height: 12),

          // botao login
          ElevatedButton(onPressed: registrarUsuario, child: Text("Registrar")),

          SizedBox(height: 12),
        ],
      ),
    );
  }
}
