import 'dart:typed_data';

class ModelDespesaImagem {
  final String? id;
  final String? storagePath;
  final String? signedUrl;
  final Uint8List? bytes;
  final String? fileName;
  final String? contentType;

  const ModelDespesaImagem({
    this.id,
    this.storagePath,
    this.signedUrl,
    this.bytes,
    this.fileName,
    this.contentType,
  });

  bool get possuiPreviewLocal => bytes != null;

  factory ModelDespesaImagem.fromMap({required Map<String, dynamic> map}) {
    return ModelDespesaImagem(
      id: map['id']?.toString(),
      storagePath: map['storage_path']?.toString(),
    );
  }

  ModelDespesaImagem copyWith({
    String? id,
    String? storagePath,
    String? signedUrl,
    Uint8List? bytes,
    String? fileName,
    String? contentType,
  }) {
    return ModelDespesaImagem(
      id: id ?? this.id,
      storagePath: storagePath ?? this.storagePath,
      signedUrl: signedUrl ?? this.signedUrl,
      bytes: bytes ?? this.bytes,
      fileName: fileName ?? this.fileName,
      contentType: contentType ?? this.contentType,
    );
  }
}
