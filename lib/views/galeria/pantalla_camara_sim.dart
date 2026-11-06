
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PantallaCamaraSim extends StatefulWidget {
  const PantallaCamaraSim({super.key});

  @override
  State<PantallaCamaraSim> createState() =>
      _PantallaCamaraSimState();
}

class _PantallaCamaraSimState extends State<PantallaCamaraSim>
    with WidgetsBindingObserver {
  CameraController? _controlador;
  List<CameraDescription> _camaras = [];
  final List<File> _fotos = [];

  int _pestana = 0;
  bool _iniciando = true;
  bool _tomandoFoto = false;
  bool _cargandoFotos = false;
  String? _error;

  static const Color _fondo = Color(0xFFF7F9FA);
  static const Color _verde = Color(0xFF92AFBC);
  static const Color _texto = Color(0xFF263238);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cargarFotosGuardadas();
    _iniciarCamara();
  }

  // Carga las fotos que ya están guardadas en el dispositivo.
  Future<void> _cargarFotosGuardadas() async {
    if (_cargandoFotos) return;
    _cargandoFotos = true;

    try {
      final directorio = await getApplicationDocumentsDirectory();
      final carpeta = Directory(
        path.join(directorio.path, 'fotos_camara'),
      );

      if (!await carpeta.exists()) {
        await carpeta.create(recursive: true);
      }

      final archivos = await carpeta.list().toList();

      final fotosGuardadas = archivos
          .whereType<File>()
          .where(
            (archivo) =>
            archivo.path.toLowerCase().endsWith('.jpg'),
      )
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path));

      if (!mounted) return;

      setState(() {
        _fotos
          ..clear()
          ..addAll(fotosGuardadas);
      });
    } catch (e) {
      debugPrint('Error al cargar las fotos guardadas: $e');
    } finally {
      _cargandoFotos = false;
    }
  }

  Future<void> _iniciarCamara({
    CameraDescription? camaraElegida,
  }) async {
    if (mounted) {
      setState(() {
        _iniciando = true;
        _error = null;
      });
    }

    final anterior = _controlador;
    _controlador = null;
    await anterior?.dispose();

    try {
      if (_camaras.isEmpty) {
        _camaras = await availableCameras();
      }

      if (_camaras.isEmpty) {
        throw Exception(
          'No se encontraron cámaras en el dispositivo.',
        );
      }

      final camara = camaraElegida ??
          _camaras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.back,
            orElse: () => _camaras.first,
          );

      final nuevoControlador = CameraController(
        camara,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _controlador = nuevoControlador;
      await nuevoControlador.initialize();

      if (!mounted) {
        await nuevoControlador.dispose();
        return;
      }

      setState(() {
        _iniciando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _iniciando = false;
        _error = e.toString();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      final controlador = _controlador;
      _controlador = null;
      controlador?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_pestana == 0) {
        _iniciarCamara();
      }
      _cargarFotosGuardadas();
    }
  }

  Future<void> _tomarFoto() async {
    final controlador = _controlador;

    if (controlador == null ||
        !controlador.value.isInitialized ||
        _tomandoFoto) {
      return;
    }

    setState(() => _tomandoFoto = true);

    try {
      final fotoTemporal = await controlador.takePicture();
      final directorio = await getApplicationDocumentsDirectory();

      final carpeta = Directory(
        path.join(directorio.path, 'fotos_camara'),
      );

      await carpeta.create(recursive: true);

      final destino = path.join(
        carpeta.path,
        'foto_${DateTime.now().microsecondsSinceEpoch}.jpg',
      );

      final fotoGuardada = await File(
        fotoTemporal.path,
      ).copy(destino);

      if (!mounted) return;

      setState(() {
        _fotos.insert(0, fotoGuardada);
      });
    } catch (e) {
      debugPrint('Error al tomar la foto: $e');
    } finally {
      if (mounted) {
        setState(() => _tomandoFoto = false);
      }
    }
  }

  Future<void> _cambiarCamara() async {
    if (_camaras.length < 2) return;

    final actual = _controlador?.description;
    if (actual == null) return;

    final siguiente = _camaras.firstWhere(
          (c) => c.lensDirection != actual.lensDirection,
      orElse: () => _camaras.first,
    );

    await _iniciarCamara(camaraElegida: siguiente);
  }

  void _verFoto(File foto) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _VistaFoto(foto: foto),
      ),
    );
  }

  Future<void> _eliminarFoto(File foto) async {
    try {
      if (await foto.exists()) {
        await foto.delete();
      }

      if (!mounted) return;

      setState(() {
        _fotos.remove(foto);
      });
    } catch (e) {
      debugPrint('Error al eliminar la foto: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controlador?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      appBar: AppBar(
        backgroundColor: _fondo,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Camara',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: IndexedStack(
        index: _pestana,
        children: [
          _vistaCamara(),
          _vistaGaleria(),
        ],
      ),
    );
  }

  Widget _vistaCamara() {
    final controlador = _controlador;

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(18),
            ),
            child: _iniciando
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
                : _error != null
                ? _vistaError()
                : controlador != null &&
                controlador.value.isInitialized
                ? CameraPreview(controlador)
                : const Center(
              child: Text(
                'Cámara no disponible',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                tooltip: 'Abrir galería',
                onPressed: () async {
                  setState(() => _pestana = 1);
                  await _cargarFotosGuardadas();
                },
                icon: const Icon(
                  Icons.photo_library_outlined,
                  color: _verde,
                  size: 34,
                ),
              ),
              GestureDetector(
                onTap: _tomandoFoto ? null : _tomarFoto,
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _tomandoFoto ? Colors.grey : _verde,
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Cambiar cámara',
                onPressed: _cambiarCamara,
                icon: const Icon(
                  Icons.cameraswitch_outlined,
                  color: _verde,
                  size: 34,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _vistaError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              color: Colors.white,
              size: 56,
            ),
            const SizedBox(height: 16),
            const Text(
              'No se pudo abrir la cámara',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _iniciarCamara,
              icon: const Icon(Icons.refresh),
              label: const Text('Intentar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vistaGaleria() {
    if (_fotos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 76,
              color: Color(0xFF79929E),
            ),
            const SizedBox(height: 16),
            const Text(
              'Todavía no hay fotos',
              style: TextStyle(
                color: _texto,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Las fotos que tomes aparecerán aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => setState(() => _pestana = 0),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Abrir cámara'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _verde,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _fotos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, indice) {
        final foto = _fotos[indice];

        return GestureDetector(
          onTap: () => _verFoto(foto),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  foto,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Color(0xFFE0E0E0),
                    child: Icon(Icons.broken_image),
                  ),
                ),
              ),
              Positioned(
                right: 2,
                top: 2,
                child: IconButton(
                  tooltip: 'Eliminar foto',
                  onPressed: () => _eliminarFoto(foto),
                  icon: const Icon(
                    Icons.delete_outline,
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
  }
}

class _VistaFoto extends StatelessWidget {
  const _VistaFoto({required this.foto});

  final File foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Ver foto'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(
            foto,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image,
              color: Colors.white,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
