//DTO
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/models/DTO.dart';
import 'package:zrd_despesas_app/models/model_despesa.dart';

class Despesa extends DTO<ModelDespesa> {
  @override
  Future<List<ModelDespesa>> get() async {
    final data = await Supabase.instance.client
        .from('despesas')
        .select(
          'id, data_despesa, categoria_id, pagamento_id, valor, created_at, descricao',
        )
        .order('data_despesa', ascending: false);

    return (data as List)
        .map((item) => ModelDespesa.fromMap(map: item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert(ModelDespesa item) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      await Supabase.instance.client.from('despesas').insert({
        'descricao': item.descricao.toString(),
        'data_despesa': item.dtemissao?.toIso8601String(),
        'categoria_id': item.categoria,
        'pagamento_id': item.formaPagamento,
        'valor': item.valor,
        'id_user': userId,
      });

      ///////
    } on PostgrestException catch (e) {
      throw Exception('Erro ao inserir despesa $e');
    }
  }
}
