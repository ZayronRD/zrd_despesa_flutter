//DTO
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/models/DTO.dart';
import 'package:zrd_despesas_app/models/model_despesa.dart';
import 'package:zrd_despesas_app/models/model_despesa_imagem.dart';

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
          descricao,
          despesa_imagens (
            id,
            storage_path,
            created_at
          )
        ''')
        .order('data_despesa', ascending: false);

    return (data as List)
        .map((item) => ModelDespesa.fromMap(map: item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> delete(String id) async {
    try {
      final imagens =
          await Supabase.instance.client
              .from('despesa_imagens')
              .select('storage_path')
              .eq('despesa_id', id);

      final storagePaths =
          (imagens as List)
              .map((item) => item['storage_path']?.toString())
              .whereType<String>()
              .where((item) => item.isNotEmpty)
              .toList();

      if (storagePaths.isNotEmpty) {
        await Supabase.instance.client.storage
            .from('despesa-imagens')
            .remove(storagePaths);
      }

      await Supabase.instance.client
          .from('despesa_imagens')
          .delete()
          .eq('despesa_id', id);

      await Supabase.instance.client.from('despesas').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao excluir despesa: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao excluir despesa e imagens: $e');
    }
  }

  @override
  Future<void> insert(ModelDespesa item, {Object? extra}) async {
    final imagens = extra is List<ModelDespesaImagem>
        ? extra
        : const <ModelDespesaImagem>[];
    final uploadedPaths = <String>[];
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

      for (final imagem in imagens) {
        final fileName = imagem.fileName;
        final bytes = imagem.bytes;
        final contentType = imagem.contentType;

        if (fileName == null || bytes == null || contentType == null) {
          throw Exception('Imagem da despesa sem dados suficientes para upload.');
        }

        final storagePath = '$userId/$despesaId/$fileName';

        await Supabase.instance.client.storage
            .from('despesa-imagens')
            .uploadBinary(
              storagePath,
              bytes,
              fileOptions: FileOptions(contentType: contentType),
            );

        uploadedPaths.add(storagePath);

        await Supabase.instance.client.from('despesa_imagens').insert({
          'despesa_id': despesaId,
          'storage_path': storagePath,
        });
      }
    } on PostgrestException catch (e) {
      if (uploadedPaths.isNotEmpty) {
        await Supabase.instance.client.storage
            .from('despesa-imagens')
            .remove(uploadedPaths);
      }

      if (despesaId != null) {
        await Supabase.instance.client
            .from('despesas')
            .delete()
            .eq('id', despesaId);
      }

      throw Exception('Erro ao inserir despesa $e');
    } catch (e) {
      if (uploadedPaths.isNotEmpty) {
        await Supabase.instance.client.storage
            .from('despesa-imagens')
            .remove(uploadedPaths);
      }

      if (despesaId != null) {
        await Supabase.instance.client
            .from('despesas')
            .delete()
            .eq('id', despesaId);
      }

      throw Exception('Erro ao salvar despesa e imagens: $e');
    }
  }
}
