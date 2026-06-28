class ModelDespesa {
  String? id;
  DateTime? dtemissao;
  String descricao;
  String? categoria;
  String? formaPagamento;
  double valor;

  ModelDespesa({
    this.id,
    required this.dtemissao,
    required this.descricao,
    required this.categoria,
    required this.formaPagamento,
    required this.valor,
  });

  String dadosEmString() {
    return "Vai ir para o banco [dtemissao: $dtemissao, descricao: $descricao,tipo $categoria, valor: $valor, forma de pagamento: $formaPagamento]";
  }

  factory ModelDespesa.fromMap({required Map<String, dynamic> map}) {
    final categoriaMap = map['categorias'] as Map<String, dynamic>?;
    final formaPagamentoMap = map['formas_pagamento'] as Map<String, dynamic>?;

    return ModelDespesa(
      id: map["id"]?.toString(),
      dtemissao: map["data_despesa"] != null
          ? DateTime.tryParse(map["data_despesa"].toString())
          : null,
      descricao: map["descricao"]?.toString() ?? '',
      categoria:
          categoriaMap?["descricao"]?.toString() ??
          map["categoria_id"]?.toString(),
      valor: (map["valor"] as num?)?.toDouble() ?? 0,
      formaPagamento:
          formaPagamentoMap?["descricao"]?.toString() ??
          map["pagamento_id"]?.toString(),
    );
  }
}
