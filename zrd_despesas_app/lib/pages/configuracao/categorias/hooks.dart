import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/models/DTO.dart';
import 'package:zrd_despesas_app/models/model_categoria.dart';

class HooksCategoria extends DTO<ModelCategoria> {
  @override
  Future<List<ModelCategoria>> get() async {
    final data = await Supabase.instance.client
        .from('categorias')
        .select('id,descricao')
        .order('id', ascending: true);

    return (data as List)
        .map(
          (item) => ModelCategoria.fromMap(map: item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> delete(String id) async {
    try {
      await Supabase.instance.client.from('categorias').delete().eq('id', id);
    } on PostgrestException catch (e) {
      if (e.code == '23503') {
        throw 'Não é possível excluir: existem despesas vinculadas.';
      }

      throw Exception('Erro ao excluir categoria');
    }
  }

  @override
  Future<void> insert(ModelCategoria item) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      await Supabase.instance.client.from('categorias').insert({
        'descricao': item.descricao,
        'id_user': userId,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw 'Categoria já existe';
      }

      throw Exception('Erro ao inserir categoria');
    }
  }
}
