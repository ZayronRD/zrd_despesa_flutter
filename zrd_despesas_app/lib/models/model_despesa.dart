class ModelDespesa {
  DateTime? dtemissao;
  String descricao;
  String? categoria;
  String? formaPagamento;
  double valor;

  ModelDespesa({
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
    return ModelDespesa(
      dtemissao: map["data_despesa"] != null
          ? DateTime.tryParse(map["data_despesa"].toString())
          : null,
      descricao: map["descricao"]?.toString() ?? '',
      categoria: map["categoria_id"]?.toString(),
      valor: (map["valor"] as num?)?.toDouble() ?? 0,
      formaPagamento: map["pagamento_id"]?.toString(),
    );
  }
}
