//DTO
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/models/DTO.dart';
import 'package:zrd_despesas_app/models/model_despesa.dart';

class Despesa extends DTO<ModelDespesa> {
  @override
  Future<List<ModelDespesa>> get() async {
    final data = await Supabase.instance.client
        .from('despesas')
        .select('''
          id,
          data_despesa,
          categoria_id,
          categorias (
            descricao
          ),
          pagamento_id,
          formas_pagamento (
            descricao
          ),
          valor,
          created_at,
          descricao
        ''')
        .order('data_despesa', ascending: false);

    return (data as List)
        .map((item) => ModelDespesa.fromMap(map: item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> delete(String id) async {
    try {
      await Supabase.instance.client.from('despesas').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao excluir despesa: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao excluir despesa e imagens: $e');
    }
  }

  @override
  Future<void> insert(ModelDespesa item, {Object? extra}) async {
    dynamic despesaId;

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      final despesaCriada = await Supabase.instance.client
          .from('despesas')
          .insert({
            'descricao': item.descricao.toString(),
            'data_despesa': item.dtemissao?.toIso8601String(),
            'categoria_id': item.categoria,
            'pagamento_id': item.formaPagamento,
            'valor': item.valor,
            'id_user': userId,
          })
          .select('id')
          .single();

      despesaId = despesaCriada['id'];
    } on PostgrestException catch (e) {
      if (despesaId != null) {
        await Supabase.instance.client
            .from('despesas')
            .delete()
            .eq('id', despesaId);
      }

      throw Exception('Erro ao inserir despesa $e');
    } catch (e) {
      if (despesaId != null) {
        await Supabase.instance.client
            .from('despesas')
            .delete()
            .eq('id', despesaId);
      }

      throw Exception('Erro ao salvar despesa $e');
    }
  }
}
