class ModelCategoria {
  String id;
  String descricao;

  ModelCategoria({required this.id, required this.descricao});

  factory ModelCategoria.fromMap({required Map<String, dynamic> map}) {
    return ModelCategoria(
      id: map["id"].toString(),
      descricao: map["descricao"].toString(),
    );
  }
}
