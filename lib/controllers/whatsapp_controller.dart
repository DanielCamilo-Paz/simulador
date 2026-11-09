
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/whatsapp/leccion_whatsapp_model.dart';
import '../../models/whatsapp/progreso_whatsapp_model.dart';

class WhatsappController extends ChangeNotifier {
  static const String _claveProgreso = 'progreso_whatsapp';

  // --------------------------------------------------
  // LECCIONES DISPONIBLES
  // --------------------------------------------------

  final List<LeccionWhatsappModel> lecciones = const [
    LeccionWhatsappModel(
      id: 'mensajes',
      tipo: 'mensajes',
      titulo: 'Enviar mensajes',
      descripcion: 'Aprende a escribir y enviar un mensaje.',
      icono: Icons.message_rounded,
      color: Color(0xFF299D70),
    ),
    LeccionWhatsappModel(
      id: 'audios',
      tipo: 'audios',
      titulo: 'Enviar audios',
      descripcion: 'Graba y envía un mensaje de voz.',
      icono: Icons.mic_rounded,
      color: Color(0xFF4788C7),
    ),
    LeccionWhatsappModel(
      id: 'llamadas',
      tipo: 'llamadas',
      titulo: 'Hacer llamadas',
      descripcion: 'Aprende a llamar a tus contactos.',
      icono: Icons.call_rounded,
      color: Color(0xFF279B86),
    ),
    LeccionWhatsappModel(
      id: 'fotos',
      tipo: 'fotos',
      titulo: 'Enviar fotos',
      descripcion: 'Elige una foto y compártela en un chat.',
      icono: Icons.photo_camera_rounded,
      color: Color(0xFFB57BC0),
    ),
    LeccionWhatsappModel(
      id: 'estados',
      tipo: 'estados',
      titulo: 'Ver y publicar estados',
      descripcion: 'Comparte una foto o un mensaje en tu estado.',
      icono: Icons.donut_large_rounded,
      color: Color(0xFFD39B42),
    ),
    LeccionWhatsappModel(
      id: 'contactos',
      tipo: 'contactos',
      titulo: 'Buscar contactos',
      descripcion: 'Encuentra a una persona en WhatsApp.',
      icono: Icons.search_rounded,
      color: Color(0xFF5485B8),
    ),
  ];

  // --------------------------------------------------
  // PROGRESO
  // --------------------------------------------------

  final ProgresoWhatsappModel progreso = ProgresoWhatsappModel();

  bool cargando = true;

  int get totalLecciones => lecciones.length;

  int get leccionesCompletadas => progreso.cantidadCompletadas;

  int get leccionesPendientes =>
      totalLecciones - leccionesCompletadas;

  double get porcentajeProgreso =>
      progreso.porcentaje(totalLecciones);

  bool estaCompletada(String id) {
    return progreso.estaCompletada(id);
  }

  // --------------------------------------------------
  // CARGAR PROGRESO GUARDADO
  // --------------------------------------------------

  Future<void> cargarProgreso() async {
    cargando = true;
    notifyListeners();

    try {
      final preferencias = await SharedPreferences.getInstance();

      final guardadas =
          preferencias.getStringList(_claveProgreso) ?? [];

      progreso.leccionesCompletadas
        ..clear()
        ..addAll(
          guardadas.where(
                (id) => lecciones.any((leccion) => leccion.id == id),
          ),
        );
    } catch (e) {
      debugPrint('Error al cargar el progreso de WhatsApp: $e');
    }

    cargando = false;
    notifyListeners();
  }

  // --------------------------------------------------
  // MARCAR LECCIÓN COMO COMPLETADA
  // --------------------------------------------------

  Future<void> marcarCompletada(String id) async {
    final existe = lecciones.any((leccion) => leccion.id == id);

    if (!existe || estaCompletada(id)) return;

    progreso.marcarCompletada(id);
    notifyListeners();

    await _guardarProgreso();
  }

  // --------------------------------------------------
  // QUITAR UNA LECCIÓN DEL PROGRESO
  // --------------------------------------------------

  Future<void> quitarCompletada(String id) async {
    if (!estaCompletada(id)) return;

    progreso.quitarCompletada(id);
    notifyListeners();

    await _guardarProgreso();
  }

  // --------------------------------------------------
  // GUARDAR EN EL TELÉFONO
  // --------------------------------------------------

  Future<void> _guardarProgreso() async {
    try {
      final preferencias = await SharedPreferences.getInstance();

      await preferencias.setStringList(
        _claveProgreso,
        progreso.leccionesCompletadas.toList(),
      );
    } catch (e) {
      debugPrint('Error al guardar el progreso de WhatsApp: $e');
    }
  }

  // --------------------------------------------------
  // REINICIAR TODO EL PROGRESO
  // --------------------------------------------------

  Future<void> reiniciarProgreso() async {
    progreso.leccionesCompletadas.clear();

    notifyListeners();

    await _guardarProgreso();
  }
}
