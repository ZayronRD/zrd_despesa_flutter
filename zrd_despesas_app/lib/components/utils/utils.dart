double parseMoeda(String texto) {
  final textoLimpo = texto
      .replaceAll('R\$', '')
      .replaceAll(' ', '')
      .replaceAll('.', '')
      .replaceAll(',', '.');

  return double.tryParse(textoLimpo) ?? 0;
}
