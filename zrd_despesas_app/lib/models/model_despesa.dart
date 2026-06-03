class ModelDespesa {
  DateTime? dtemissao;
  String descricao;
  String? tipo;
  double valor;

  ModelDespesa({
    required this.dtemissao,
    required this.descricao,
    required this.tipo,
    required this.valor,
  });

  String dadosEmString() {
    return "dtemissao: $dtemissao, descricao: $descricao,tipo $tipo, valor: $valor  ";
  }

  factory ModelDespesa.fromMap({required Map<String, dynamic> map}) {
    return ModelDespesa(
      dtemissao: map["data_despesa"] != null
          ? DateTime.tryParse(map["data_despesa"].toString())
          : null,
      descricao: map["descricao"]?.toString() ?? '',
      tipo: map["categoria_id"]?.toString(),
      valor: (map["valor"] as num?)?.toDouble() ?? 0,
    );
  }
}
