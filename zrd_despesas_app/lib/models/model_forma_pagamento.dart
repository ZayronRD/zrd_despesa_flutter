class ModelFormaPagamento {
  String id;
  String descricao;

  ModelFormaPagamento({required this.id, required this.descricao});

  factory ModelFormaPagamento.fromMap({required Map<String, dynamic> map}) {
    return ModelFormaPagamento(
      id: map["id"].toString(),
      descricao: map["descricao"].toString(),
    );
  }
}
