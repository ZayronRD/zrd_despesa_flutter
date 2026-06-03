import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<SupabaseClient> conexao() async {
    return Supabase.instance.client;
  }

  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> cadastro(
    String nomeCompleto,
    String apelido,
    String email,
    String password,
  ) async {
    return await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'nome_completo': nomeCompleto.trim(), 'apelido': apelido.trim()},
    );
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  String? emailUsuario() {
    final sessao = _supabase.auth.currentSession;
    final usuario = sessao?.user;
    return usuario?.email;
  }

  Future<String?> nomeUsuario() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    //
    //
    final data = await _supabase
        .from('usuarios')
        .select('nome')
        .eq('id_user', user.id)
        .maybeSingle();
    //

    return data?['nome'] as String?;
  }
}
