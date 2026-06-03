//DTO
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zrd_despesas_app/models/model_despesa.dart';

abstract class DtoDespesa<T> {
  Future<List<T>> get();
  // Future<T?> getById(int id);
  // Future<void> insert(T item);
  // Future<void> update(T item);
  // Future<void> delete(int id);
}

class Despesa extends DtoDespesa<ModelDespesa> {
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
}
