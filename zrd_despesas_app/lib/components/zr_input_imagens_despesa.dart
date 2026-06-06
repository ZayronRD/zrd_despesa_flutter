import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/components/zr_camera_capture_page.dart';
import 'package:zrd_despesas_app/models/model_despesa_imagem.dart';

class ZrInputImagensDespesa extends StatelessWidget {
  final List<ModelDespesaImagem> imagens;
  final ValueChanged<List<ModelDespesaImagem>> onChanged;

  const ZrInputImagensDespesa({
    super.key,
    required this.imagens,
    required this.onChanged,
  });

  Future<void> adicionarImagem(BuildContext context) async {
    /// no banco estou verificando tambem :/

    if (imagens.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cada despesa permite no maximo 2 imagens.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final imagem = await Navigator.push<ModelDespesaImagem>(
      context,
      MaterialPageRoute(builder: (_) => ZrCameraCapturePage()),
    );

    if (imagem == null) return;

    final novasImagens = [...imagens, imagem];
    onChanged(novasImagens);
  }

  void removerImagem(int index) {
    final novasImagens = [...imagens]..removeAt(index);
    onChanged(novasImagens);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'IMAGENS DA DESPESA',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: () => adicionarImagem(context),
                icon: const Icon(Icons.camera_alt),
                label: Text('Adicionar (${imagens.length}/2)'),
              ),
            ],
          ),
        ),
        if (imagens.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.black12,
            child: const Text('Nenhuma imagem adicionada.'),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: imagens.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final imagem = imagens[index];

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        imagem.bytes!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => removerImagem(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
