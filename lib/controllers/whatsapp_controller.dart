
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/whatsapp/leccion_whatsapp_model.dart';
import '../models/whatsapp/progreso_whatsapp_model.dart';
import 'progreso_general_controller.dart';

class WhatsappController extends ChangeNotifier {
  static const String _claveProgreso = 'progreso_whatsapp';

  // ========================================
  // LECCIONES DISPONIBLES
  // ========================================

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

  // ========================================
  // PROGRESO GENERAL DE SAFETAP
  // ========================================

  final ProgresoGeneralController _progresoGeneral =
      progresoGeneralController;

  WhatsappController() {
    _registrarLeccionesGenerales();
  }

  void _registrarLeccionesGenerales() {
    final nuevasLecciones = <String, String>{};

    for (final leccion in lecciones) {
      nuevasLecciones[leccion.id] = leccion.titulo;
    }

    _progresoGeneral.registrarLecciones(
      'whatsapp',
      nuevasLecciones,
    );

    _progresoGeneral.configurarTotalActividades(
      'whatsapp',
      lecciones.length,
    );
  }

  void _sincronizarProgresoGeneral() {
    for (final leccion in lecciones) {
      if (progreso.estaCompletada(leccion.id)) {
        _progresoGeneral.completarActividad(
          'whatsapp',
          leccion.id,
        );
      } else {
        _progresoGeneral.reiniciarActividad(
          'whatsapp',
          leccion.id,
        );
      }
    }
  }

  // ========================================
  // PROGRESO INDIVIDUAL
  // ========================================

  final ProgresoWhatsappModel progreso =
  ProgresoWhatsappModel();

  bool cargando = true;
  bool _disposed = false;

  Future<void>? _cargaEnProceso;

  Future<void> _colaGuardado = Future.value();

  int get totalLecciones => lecciones.length;

  int get leccionesCompletadas =>
      progreso.cantidadCompletadas;

  int get leccionesPendientes =>
      totalLecciones - leccionesCompletadas;

  double get porcentajeProgreso =>
      progreso.porcentaje(totalLecciones);

  bool estaCompletada(String id) {
    return progreso.estaCompletada(id);
  }

  void _notificar() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // ========================================
  // CARGAR PROGRESO GUARDADO
  // ========================================

  Future<void> cargarProgreso() {
    if (_cargaEnProceso != null) {
      return _cargaEnProceso!;
    }

    _cargaEnProceso = _cargarProgresoInterno();

    return _cargaEnProceso!;
  }

  Future<void> _cargarProgresoInterno() async {
    cargando = true;
    _notificar();

    try {
      final preferencias =
      await SharedPreferences.getInstance();

      final guardadas =
          preferencias.getStringList(_claveProgreso) ?? [];

      progreso.leccionesCompletadas
        ..clear()
        ..addAll(
          guardadas.where(
                (id) => lecciones.any(
                  (leccion) => leccion.id == id,
            ),
          ),
        );

      _sincronizarProgresoGeneral();

      debugPrint(
        'WhatsApp: ${progreso.cantidadCompletadas} '
            'lecciones recuperadas.',
      );
    } catch (e) {
      debugPrint(
        'Error al cargar el progreso de WhatsApp: $e',
      );
    } finally {
      cargando = false;
      _notificar();
    }
  }

  // ========================================
  // MARCAR LECCIÓN COMO COMPLETADA
  // ========================================

  Future<void> marcarCompletada(String id) async {
    final existe = lecciones.any(
          (leccion) => leccion.id == id,
    );

    if (!existe || estaCompletada(id)) {
      return;
    }

    // Actualizar progreso individual.
    progreso.marcarCompletada(id);

    // Actualizar progreso general.
    _progresoGeneral.completarActividad(
      'whatsapp',
      id,
    );

    debugPrint('Lección completada: $id');

    _notificar();

    await _guardarProgreso();
  }

  // ========================================
  // QUITAR LECCIÓN COMPLETADA
  // ========================================

  Future<void> quitarCompletada(String id) async {
    if (!estaCompletada(id)) {
      return;
    }

    progreso.quitarCompletada(id);

    _progresoGeneral.reiniciarActividad(
      'whatsapp',
      id,
    );

    _notificar();

    await _guardarProgreso();
  }

  // ========================================
  // GUARDAR PROGRESO
  // ========================================

  Future<void> _guardarProgreso() {
    final datos = progreso.leccionesCompletadas.toList();

    _colaGuardado = _colaGuardado.then((_) async {
      try {
        final preferencias =
        await SharedPreferences.getInstance();

        await preferencias.setStringList(
          _claveProgreso,
          datos,
        );

        debugPrint(
          'Progreso de WhatsApp guardado: $datos',
        );
      } catch (e) {
        debugPrint(
          'Error al guardar el progreso de WhatsApp: $e',
        );
      }
    });

    return _colaGuardado;
  }

  // ========================================
  // REINICIAR TODO EL PROGRESO
  // ========================================

  Future<void> reiniciarProgreso() async {
    progreso.leccionesCompletadas.clear();

    _progresoGeneral.reiniciarAplicacion(
      'whatsapp',
    );

    _notificar();

    await _guardarProgreso();

    debugPrint('Progreso de WhatsApp reiniciado.');
  }

  // ========================================
  // LIBERAR CONTROLADOR
  // ========================================

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
