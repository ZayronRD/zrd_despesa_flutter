import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/models/DTO.dart';
import 'package:zrd_despesas_app/models/model_forma_pagamento.dart';

class HooksFormasPagamento extends DTO<ModelFormaPagamento> {
  @override
  Future<List<ModelFormaPagamento>> get() async {
    final data = await Supabase.instance.client
        .from('formas_pagamento')
        .select('id,descricao')
        .order('id', ascending: true);

    return (data as List)
        .map(
          (item) =>
              ModelFormaPagamento.fromMap(map: item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> delete(String id) async {
    try {
      await Supabase.instance.client
          .from('formas_pagamento')
          .delete()
          .eq('id', id);
    } on PostgrestException catch (e) {
      if (e.code == '23503') {
        throw 'Não é possível excluir: existem despesas vinculadas.';
      }

      throw Exception('Erro ao excluir forma de pagamento');
    }
  }

  @override
  Future<void> insert(ModelFormaPagamento item, {Object? extra}) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      await Supabase.instance.client.from('formas_pagamento').insert({
        'descricao': item.descricao,
        'id_user': userId,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw 'Forma de pagamento já existe';
      }

      throw Exception('Erro ao inserir forma de pagamento');
    }
  }
}
