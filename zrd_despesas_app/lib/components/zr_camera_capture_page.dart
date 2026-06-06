import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:zrd_despesas_app/models/model_despesa_imagem.dart';

class ZrCameraCapturePage extends StatefulWidget {
  const ZrCameraCapturePage({super.key});

  @override
  State<ZrCameraCapturePage> createState() => _ZrCameraCapturePageState();
}

class _ZrCameraCapturePageState extends State<ZrCameraCapturePage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  Uint8List? _imagemBytes;
  String? _erroCamera;

  @override
  void initState() {
    super.initState();
    iniciarCamera();
  }

  Future<void> iniciarCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _erroCamera = 'nenhuma camera disponivel!';
        });
        return;
      }

      /// trativa so para validar a camera... tipo no note pega normal.. a primeria que aparecer
      /// ja no telefone vai atras da primeira camera traseira pra que nao saia uma selfie kkkk

      final camerasTraseiras = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList();

      final cameraEscolhida = camerasTraseiras.isNotEmpty
          ? camerasTraseiras.first
          : cameras.first;

      final controller = CameraController(
        cameraEscolhida,
        ResolutionPreset.medium,
      );

      final future = controller.initialize();

      setState(() {
        _controller = controller;
        _initializeControllerFuture = future;
        _erroCamera = null;
      });

      await future;

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erroCamera = 'erro ao iniciar camera: $e';
      });
    }
  }

  Future<void> tirarFoto() async {
    try {
      final initializeFuture = _initializeControllerFuture;
      final controller = _controller;

      if (initializeFuture == null || controller == null) {
        throw Exception('Camera nao inicializada.');
      }

      await initializeFuture;

      final imagem = await controller.takePicture();
      final bytes = await imagem.readAsBytes();

      if (!mounted) return;

      setState(() {
        _imagemBytes = bytes;
      });

      _imagemBytes == null ? null : confirmarImagem();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao capturar imagem: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void confirmarImagem() {
    final bytes = _imagemBytes;
    if (bytes == null) return;

    final imagem = ModelDespesaImagem(
      bytes: bytes,
      fileName: 'despesa_${DateTime.now().millisecondsSinceEpoch}.jpg',
      contentType: 'image/jpeg',
    );

    Navigator.pop(context, imagem);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initializeFuture = _initializeControllerFuture;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CAPTURAR IMAGEM'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: tirarFoto,
        child: const Icon(Icons.camera_alt),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.black12,
                child: _erroCamera != null
                    ? Center(child: Text(_erroCamera!))
                    : initializeFuture == null
                    ? const Center(child: CircularProgressIndicator())
                    : FutureBuilder<void>(
                        future: initializeFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              _controller != null) {
                            return CameraPreview(_controller!);
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Erro ao carregar preview da camera: ${snapshot.error}',
                              ),
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
              ),
            ),
            // const SizedBox(height: 16),
            // Expanded(
            //   child: Container(
            //     // width: double.tryParse('230'),
            //     // height: double.tryParse('20'),
            //     color: Colors.black12,
            //     child: _imagemBytes == null
            //         ? const Center(
            //             child: Text('Nenhuma imagem capturada ainda.'),
            //           )
            //         : Image.memory(_imagemBytes!, fit: BoxFit.contain),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
