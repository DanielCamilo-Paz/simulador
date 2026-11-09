import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/camara/camara_model.dart';

class CamaraController extends ChangeNotifier {
  CameraController? camara;

  final ImagePicker _picker = ImagePicker();

  final List<Foto> fotos = [];

  EstadoPracticaCamara estado = EstadoPracticaCamara();

  bool cargando = false;
  bool camaraLista = false;

  String? errorCamara;

  double zoomActual = 1.0;
  double zoomMinimo = 1.0;
  double zoomMaximo = 1.0;

  bool get usaCamaraFrontal =>
      camara?.description.lensDirection == CameraLensDirection.front;

  int get progresoGeneral => estado.progresoGeneral;

  // --------------------------------------------------
  // ALMACENAMIENTO
  // --------------------------------------------------

  Future<Directory> _directorioFotos() async {
    final directorio = await getApplicationDocumentsDirectory();

    final carpeta = Directory(
      p.join(directorio.path, 'fotografias_camara'),
    );

    if (!await carpeta.exists()) {
      await carpeta.create(recursive: true);
    }

    return carpeta;
  }

  Future<void> iniciar() async {
    await cargarProgreso();
    await cargarFotosGuardadas();
  }

  Future<void> cargarProgreso() async {
    final preferencias = await SharedPreferences.getInstance();

    final datos = preferencias.getString('progreso_camara');

    if (datos != null) {
      try {
        estado = EstadoPracticaCamara.fromJson(
          jsonDecode(datos) as Map<String, dynamic>,
        );
      } catch (_) {
        estado = EstadoPracticaCamara();
      }
    }

    notifyListeners();
  }

  Future<void> _guardarProgreso() async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setString(
      'progreso_camara',
      jsonEncode(estado.toJson()),
    );

    notifyListeners();
  }

  Future<void> cargarFotosGuardadas() async {
    final carpeta = await _directorioFotos();

    fotos.clear();

    if (await carpeta.exists()) {
      final archivos = carpeta.listSync();

      for (final archivo in archivos) {
        if (archivo is! File) continue;

        final extension = p.extension(archivo.path).toLowerCase();

        if (!['.jpg', '.jpeg', '.png', '.webp'].contains(extension)) {
          continue;
        }

        try {
          final nombre = p.basenameWithoutExtension(archivo.path);

          fotos.add(
            Foto(
              ruta: archivo.path,
              fecha: archivo.lastModifiedSync(),
              importada: nombre.startsWith('importada_'),
            ),
          );
        } catch (_) {}
      }
    }

    fotos.sort((a, b) => b.fecha.compareTo(a.fecha));

    notifyListeners();
  }

  // --------------------------------------------------
  // CÁMARA
  // --------------------------------------------------

  Future<void> iniciarCamara() async {
    if (cargando) return;

    cargando = true;
    errorCamara = null;
    notifyListeners();

    try {
      final disponibles = await availableCameras();

      if (disponibles.isEmpty) {
        throw Exception('No se encontraron cámaras disponibles.');
      }

      final trasera = disponibles.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => disponibles.first,
      );

      await _configurarCamara(trasera);
    } catch (e) {
      errorCamara = 'No se pudo iniciar la cámara: $e';
      camaraLista = false;
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> _configurarCamara(
      CameraDescription descripcion,
      ) async {
    await detenerCamara();

    final nuevaCamara = CameraController(
      descripcion,
      ResolutionPreset.high,
      enableAudio: false,
    );

    camara = nuevaCamara;

    await nuevaCamara.initialize();

    await nuevaCamara.setFlashMode(FlashMode.off);

    zoomMinimo = await nuevaCamara.getMinZoomLevel();
    zoomMaximo = await nuevaCamara.getMaxZoomLevel();

    zoomActual = zoomMinimo;

    await nuevaCamara.setZoomLevel(zoomActual);

    camaraLista = true;
    errorCamara = null;

    notifyListeners();
  }

  Future<void> detenerCamara() async {
    final anterior = camara;

    camara = null;
    camaraLista = false;

    if (anterior != null) {
      await anterior.dispose();
    }
  }

  Future<void> cambiarCamara() async {
    if (cargando) return;

    try {
      final disponibles = await availableCameras();

      final destino = usaCamaraFrontal
          ? CameraLensDirection.back
          : CameraLensDirection.front;

      final camaraDestino = disponibles.firstWhere(
            (camera) => camera.lensDirection == destino,
        orElse: () => throw Exception('No se encontró esa cámara.'),
      );

      cargando = true;
      notifyListeners();

      await _configurarCamara(camaraDestino);
    } catch (e) {
      errorCamara = 'No se pudo cambiar de cámara: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> cambiarZoom(double valor) async {
    if (camara == null || !camaraLista || usaCamaraFrontal) return;

    final nuevoZoom = valor.clamp(
      zoomMinimo,
      zoomMaximo,
    ).toDouble();

    zoomActual = nuevoZoom;

    try {
      await camara!.setZoomLevel(nuevoZoom);
    } catch (_) {
      errorCamara = 'No se pudo ajustar el zoom.';
    }

    notifyListeners();
  }

  Future<bool> tomarFoto() async {
    if (camara == null ||
        !camaraLista ||
        camara!.value.isTakingPicture) {
      return false;
    }

    try {
      final imagen = await camara!.takePicture();

      final carpeta = await _directorioFotos();

      final nombre =
          'foto_${DateTime.now().microsecondsSinceEpoch}.jpg';

      final destino = p.join(carpeta.path, nombre);

      await File(imagen.path).copy(destino);

      fotos.insert(
        0,
        Foto(
          ruta: destino,
          fecha: DateTime.now(),
        ),
      );

      if (usaCamaraFrontal) {
        estado.selfie = true;
      } else {
        estado.fotoTrasera = true;
      }

      errorCamara = null;

      await _guardarProgreso();

      return true;
    } catch (e) {
      errorCamara = 'No se pudo tomar la fotografía: $e';
      notifyListeners();
      return false;
    }
  }

  // --------------------------------------------------
  // GALERÍA
  // --------------------------------------------------

  Future<void> abrirGaleria() async {
    estado.galeriaAbierta = true;

    await cargarFotosGuardadas();
    await _guardarProgreso();
  }

  Future<void> visualizarFoto(Foto foto) async {
    estado.fotoVisualizada = true;
    await _guardarProgreso();
  }

  Future<bool> importarFoto() async {
    errorCamara = null;

    try {
      final imagen = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );

      if (imagen == null) return false;

      final carpeta = await _directorioFotos();

      final extension = p.extension(imagen.path).isEmpty
          ? '.jpg'
          : p.extension(imagen.path);

      final nombre =
          'importada_${DateTime.now().microsecondsSinceEpoch}$extension';

      final destino = p.join(carpeta.path, nombre);

      await File(imagen.path).copy(destino);

      fotos.insert(
        0,
        Foto(
          ruta: destino,
          fecha: DateTime.now(),
          importada: true,
        ),
      );

      estado.fotoImportada = true;

      errorCamara = null;

      await _guardarProgreso();

      return true;
    } catch (e) {
      errorCamara = 'No se pudo importar la fotografía: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarFoto(Foto foto) async {
    try {
      final archivo = File(foto.ruta);

      if (await archivo.exists()) {
        await archivo.delete();
      }

      fotos.removeWhere(
            (elemento) => elemento.ruta == foto.ruta,
      );

      estado.fotoEliminada = true;

      errorCamara = null;

      await _guardarProgreso();

      return true;
    } catch (e) {
      errorCamara = 'No se pudo eliminar la fotografía: $e';
      notifyListeners();
      return false;
    }
  }

  // --------------------------------------------------
  // ÚNICO REINICIO: TODO EL MÓDULO
  // --------------------------------------------------

  Future<void> reiniciarTodo() async {
    await detenerCamara();

    final carpeta = await _directorioFotos();

    if (await carpeta.exists()) {
      await for (final archivo in carpeta.list()) {
        await archivo.delete(recursive: true);
      }
    }

    fotos.clear();

    estado = EstadoPracticaCamara();

    final preferencias = await SharedPreferences.getInstance();

    await preferencias.remove('progreso_camara');

    errorCamara = null;
    zoomActual = 1.0;

    notifyListeners();
  }

  @override
  void dispose() {
    camara?.dispose();
    camara = null;
    super.dispose();
  }
}