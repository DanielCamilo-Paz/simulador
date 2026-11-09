import 'dart:io';

import 'package:flutter/material.dart';

import '../../controllers/camara_controller.dart';
import '../../models/camara/camara_model.dart';

class PracticaGaleriaView extends StatefulWidget {
  final CamaraController controller;

  const PracticaGaleriaView({
    super.key,
    required this.controller,
  });

  @override
  State<PracticaGaleriaView> createState() =>
      _PracticaGaleriaViewState();
}

class _PracticaGaleriaViewState extends State<PracticaGaleriaView> {
  CamaraController get controller => widget.controller;

  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  bool _guiaIniciada = false;
  bool _procesando = false;

  @override
  void initState() {
    super.initState();

    _iniciarGaleria();
  }

  Future<void> _iniciarGaleria() async {
    await controller.abrirGaleria();

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
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(textoBoton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarBienvenida() async {
    await _mensaje(
      titulo: '¡Bienvenido a la galería!',
      contenido:
      'Ya has abierto la galería de fotografías.\n\n'
          'Aquí aprenderás a visualizar una foto, importar una imagen '
          'y eliminar una fotografía.',
      icono: Icons.photo_library_rounded,
    );

    if (!mounted) return;

    await _mostrarSiguientePaso();
  }

  Future<void> _mostrarSiguientePaso() async {
    if (!mounted) return;

    if (!controller.estado.fotoVisualizada) {
      if (controller.fotos.isEmpty) {
        await _mensaje(
          titulo: 'No hay fotografías',
          contenido:
          'Todavía no hay fotografías guardadas.\n\n'
              'Puedes regresar a la práctica de cámara para tomar fotos '
              'o utilizar el botón «Importar foto» para seleccionar '
              'una imagen de tu teléfono.',
          icono: Icons.photo_library_outlined,
        );
      } else {
        await _mensaje(
          titulo: 'Paso 1: visualizar una foto',
          contenido:
          'Observa las fotografías que aparecen en la pantalla. '
              'Toca cualquiera de ellas para abrirla y verla en grande.',
          icono: Icons.touch_app_rounded,
        );
      }
      return;
    }

    if (!controller.estado.fotoImportada) {
      await _mensaje(
        titulo: 'Paso 2: importar una fotografía',
        contenido:
        '¡Muy bien! Ya visualizaste una fotografía.\n\n'
            'Ahora presiona el botón «Importar foto» y selecciona '
            'una imagen de tu teléfono.',
        icono: Icons.add_photo_alternate_rounded,
      );
      return;
    }

    if (!controller.estado.fotoEliminada) {
      await _mensaje(
        titulo: 'Paso 3: eliminar una fotografía',
        contenido:
        '¡Excelente! Ya importaste una fotografía.\n\n'
            'Ahora selecciona el símbolo de la papelera que aparece '
            'sobre alguna foto y confirma su eliminación.',
        icono: Icons.delete_outline_rounded,
      );
      return;
    }

    await _mensaje(
      titulo: '¡Práctica completada!',
      contenido:
      'Has aprendido a abrir la galería, visualizar fotografías, '
          'importar imágenes y eliminar fotos.\n\n'
          '¡Felicitaciones!',
      textoBoton: 'Finalizar',
      icono: Icons.check_circle_rounded,
    );
  }

  Future<void> _mostrarAyuda() async {
    await _mostrarSiguientePaso();
  }

  Future<void> _abrirFoto(Foto foto) async {
    await controller.visualizarFoto(foto);

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  child: Center(
                    child: Image.file(
                      File(foto.ruta),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            'No se pudo cargar esta fotografía.',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    if (!controller.estado.fotoVisualizada) return;

    await _mensaje(
      titulo: '¡Fotografía visualizada!',
      contenido:
      'Has abierto correctamente una fotografía. '
          'Puedes ampliarla utilizando dos dedos sobre la imagen.\n\n'
          'Ahora continuaremos con la importación de una foto.',
      icono: Icons.check_circle_rounded,
    );

    if (!mounted) return;

    await _mostrarSiguientePaso();
  }

  Future<void> _importarFoto() async {
    if (_procesando) return;

    await _mensaje(
      titulo: 'Importar fotografía',
      contenido:
      'Se abrirá el selector de imágenes de tu teléfono. '
          'Elige una fotografía para guardarla en esta galería.',
      icono: Icons.add_photo_alternate_rounded,
    );

    if (!mounted) return;

    _procesando = true;

    final resultado = await controller.importarFoto();

    _procesando = false;

    if (!mounted) return;

    if (!resultado) {
      if (controller.errorCamara != null) {
        await _mensaje(
          titulo: 'No se pudo importar',
          contenido: controller.errorCamara!,
          icono: Icons.error_outline_rounded,
        );
      }
      return;
    }

    await _mensaje(
      titulo: '¡Fotografía importada!',
      contenido:
      'La imagen se guardó correctamente en la galería '
          'del simulador.',
      icono: Icons.check_circle_rounded,
    );

    if (!mounted) return;

    await _mostrarSiguientePaso();
  }

  Future<void> _eliminarFoto(Foto foto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            '¿Eliminar fotografía?',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Esta fotografía se eliminará de la galería del simulador.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    final resultado = await controller.eliminarFoto(foto);

    if (!mounted) return;

    if (!resultado) {
      await _mensaje(
        titulo: 'No se pudo eliminar',
        contenido: controller.errorCamara ??
            'Ocurrió un problema al eliminar la fotografía.',
        icono: Icons.error_outline_rounded,
      );
      return;
    }

    await _mensaje(
      titulo: '¡Fotografía eliminada!',
      contenido:
      'La fotografía se eliminó correctamente de la galería.',
      icono: Icons.check_circle_rounded,
    );

    if (!mounted) return;

    await _mostrarSiguientePaso();
  }

  Widget _fotoItem(Foto foto) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Material(
            color: Colors.grey.shade200,
            child: InkWell(
              onTap: () => _abrirFoto(foto),
              child: Image.file(
                File(foto.ruta),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 38,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            top: 6,
            right: 6,
            child: Material(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => _eliminarFoto(foto),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ],
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
          'Galería de fotografías',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Recordar el paso',
            onPressed: _mostrarAyuda,
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Mis fotografías',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${controller.estado.progresoGaleria}/4',
                      style: const TextStyle(
                        color: verde,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _procesando ? null : _importarFoto,
                    icon: const Icon(
                      Icons.add_photo_alternate_rounded,
                    ),
                    label: const Text('Importar foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verde,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: controller.fotos.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 75,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No hay fotografías guardadas',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
                    : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: controller.fotos.length,
                  itemBuilder: (context, index) {
                    return _fotoItem(
                      controller.fotos[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}