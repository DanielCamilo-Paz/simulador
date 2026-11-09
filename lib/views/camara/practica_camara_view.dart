import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../../controllers/camara_controller.dart';

class PracticaFotografiasView extends StatefulWidget {
  final CamaraController controller;

  const PracticaFotografiasView({
    super.key,
    required this.controller,
  });

  @override
  State<PracticaFotografiasView> createState() =>
      _PracticaFotografiasViewState();
}

class _PracticaFotografiasViewState
    extends State<PracticaFotografiasView> {
  CamaraController get controller => widget.controller;

  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  double _zoomInicial = 1.0;
  bool _guiaIniciada = false;
  bool _procesando = false;

  @override
  void initState() {
    super.initState();

    _iniciar();
  }

  Future<void> _iniciar() async {
    await controller.iniciarCamara();

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_guiaIniciada) {
        _guiaIniciada = true;
        _mostrarBienvenida();
      }
    });
  }

  Future<void> _mensaje({
    required String titulo,
    required String contenido,
    String textoBoton = 'Continuar',
    IconData icono = Icons.info_outline_rounded,
    VoidCallback? accion,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Icon(
            icono,
            color: azul,
            size: 38,
          ),
          title: Text(
            titulo,
            textAlign: TextAlign.center,
          ),
          content: Text(
            contenido,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                accion?.call();
              },
              child: Text(textoBoton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarBienvenida() async {
    await _mensaje(
      titulo: '¡Vamos a tomar fotografías!',
      contenido:
      'En esta práctica aprenderás a utilizar la cámara trasera '
          'y la cámara frontal de tu teléfono.\n\n'
          'Primero tomaremos una fotografía normal y después '
          'una selfie.',
      icono: Icons.camera_alt_rounded,
    );

    if (!mounted) return;

    await _mostrarPasoActual();
  }

  Future<void> _mostrarPasoActual() async {
    if (!mounted) return;

    if (!controller.estado.fotoTrasera) {
      await _mensaje(
        titulo: 'Paso 1: fotografía',
        contenido:
        'Observa la cámara trasera. Cuando estés listo, '
            'presiona el botón circular para tomar una fotografía.',
        icono: Icons.photo_camera_rounded,
      );
    } else if (!controller.estado.selfie) {
      await _mensaje(
        titulo: 'Paso 2: selfie',
        contenido:
        '¡Muy bien! Ya tomaste una fotografía.\n\n'
            'Ahora toca el botón «Cambiar cámara» para activar '
            'la cámara frontal. Después, presiona el botón circular '
            'para tomar una selfie.',
        icono: Icons.flip_camera_android_rounded,
      );
    } else {
      await _mensaje(
        titulo: '¡Práctica completada!',
        contenido:
        'Has aprendido a tomar una fotografía con la cámara '
            'trasera y una selfie con la cámara frontal.',
        textoBoton: 'Finalizar',
        icono: Icons.check_circle_rounded,
      );
    }
  }

  Future<void> _mostrarAyuda() async {
    await _mostrarPasoActual();
  }

  Future<void> _cambiarCamara() async {
    if (_procesando) return;

    _procesando = true;

    await controller.cambiarCamara();

    _procesando = false;

    if (!mounted) return;

    if (controller.errorCamara != null) {
      await _mensaje(
        titulo: 'No se pudo cambiar',
        contenido: controller.errorCamara!,
        icono: Icons.error_outline_rounded,
      );
      return;
    }

    if (controller.usaCamaraFrontal &&
        !controller.estado.selfie &&
        controller.estado.fotoTrasera) {
      await _mensaje(
        titulo: 'Cámara frontal activada',
        contenido:
        '¡Perfecto! Ahora estás usando la cámara frontal. '
            'Ubícate frente al teléfono y presiona el botón circular '
            'para tomar tu selfie.',
        icono: Icons.face_rounded,
      );
    }
  }

  Future<void> _tomarFoto() async {
    if (_procesando) return;

    _procesando = true;

    final eraFrontal = controller.usaCamaraFrontal;

    final resultado = await controller.tomarFoto();

    _procesando = false;

    if (!mounted) return;

    if (!resultado) {
      await _mensaje(
        titulo: 'No se pudo tomar la foto',
        contenido: controller.errorCamara ??
            'Ocurrió un problema al tomar la fotografía.',
        icono: Icons.error_outline_rounded,
      );
      return;
    }

    if (!eraFrontal) {
      await _mensaje(
        titulo: '¡Fotografía guardada!',
        contenido:
        'Has tomado correctamente tu primera fotografía.\n\n'
            'Ahora toca el botón «Cambiar cámara» para activar '
            'la cámara frontal y realizar una selfie.',
        icono: Icons.check_circle_rounded,
      );
    } else {
      await _mensaje(
        titulo: '¡Selfie guardada!',
        contenido:
        'Has tomado correctamente una selfie. '
            'Con esto has completado la práctica de fotografías.',
        icono: Icons.check_circle_rounded,
      );
    }
  }



  Widget _vistaCamara() {
    final camara = controller.camara;

    if (camara == null || !camara.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final previewSize = camara.value.previewSize!;

    return SizedBox(
      width: double.infinity,
      height: 420,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize.height,
            height: previewSize.width,
            child: GestureDetector(
              onScaleStart: (_) {
                _zoomInicial = controller.zoomActual;
              },
              onScaleUpdate: (details) {
                if (!controller.usaCamaraFrontal) {
                  controller.cambiarZoom(
                    _zoomInicial * details.scale,
                  );
                }
              },
              child: CameraPreview(camara),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        title: const Text(
          'Tomar fotografías',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Recordar el paso',
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: _mostrarAyuda,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.camera_alt_rounded,
                    color: verde,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      controller.usaCamaraFrontal
                          ? 'Cámara frontal'
                          : 'Cámara trasera',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${controller.estado.progresoFotografias}/2',
                    style: const TextStyle(
                      color: verde,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: _vistaCamara(),
                ),
              ),

              if (controller.errorCamara != null) ...[
                const SizedBox(height: 12),
                Text(
                  controller.errorCamara!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 20),

              if (!controller.usaCamaraFrontal &&
                  controller.camaraLista &&
                  controller.zoomMaximo > controller.zoomMinimo) ...[
                Row(
                  children: [
                    const Icon(Icons.zoom_out_rounded),
                    const SizedBox(width: 8),
                    const Text('Zoom'),
                    Expanded(
                      child: Slider(
                        value: controller.zoomActual.clamp(
                          controller.zoomMinimo,
                          controller.zoomMaximo,
                        ),
                        min: controller.zoomMinimo,
                        max: controller.zoomMaximo,
                        activeColor: verde,
                        onChanged: controller.cambiarZoom,
                      ),
                    ),
                    const Icon(Icons.zoom_in_rounded),
                  ],
                ),
                Text(
                  '${controller.zoomActual.toStringAsFixed(1)}x',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton.filledTonal(
                        onPressed:
                        controller.cargando ? null : _cambiarCamara,
                        icon: const Icon(
                          Icons.flip_camera_android_rounded,
                        ),
                        iconSize: 28,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Cambiar',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      GestureDetector(
                        onTap: controller.cargando || _procesando
                            ? null
                            : _tomarFoto,
                        child: Container(
                          height: 76,
                          width: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: verde,
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Tomar foto',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: verde,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Fotografías completadas: '
                            '${controller.estado.progresoFotografias} de 2',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.detenerCamara();
    super.dispose();
  }
}