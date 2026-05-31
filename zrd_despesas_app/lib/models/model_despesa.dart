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
}
