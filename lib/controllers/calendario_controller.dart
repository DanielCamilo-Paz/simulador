
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/calendario/calendario_model.dart';

class CalendarioController extends ChangeNotifier {
  static const String _claveProgreso = 'progreso_calendario';
  static const String _claveEventos = 'eventos_calendario';

  EstadoPracticaCalendario estado = EstadoPracticaCalendario();

  final List<EventoCalendario> _eventos = [];

  bool cargando = true;

  // INICIAR CONTROLADOR

  Future<void> iniciar() async {
    await cargarDatos();
  }

  // CARGAR PROGRESO Y EVENTOS

  Future<void> cargarDatos() async {
    cargando = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final progresoGuardado = prefs.getString(_claveProgreso);

      if (progresoGuardado != null) {
        estado = EstadoPracticaCalendario.fromJson(
          Map<String, dynamic>.from(
            jsonDecode(progresoGuardado),
          ),
        );
      }

      final eventosGuardados = prefs.getString(_claveEventos);

      _eventos.clear();

      if (eventosGuardados != null) {
        final lista = jsonDecode(eventosGuardados) as List;

        _eventos.addAll(
          lista.map(
                (evento) => EventoCalendario.fromJson(
              Map<String, dynamic>.from(evento),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error al cargar calendario: $e');
    }

    cargando = false;
    notifyListeners();
  }

  // GUARDAR PROGRESO

  Future<void> _guardarProgreso() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _claveProgreso,
      jsonEncode(estado.toJson()),
    );
  }

  // GUARDAR EVENTOS

  Future<void> _guardarEventos() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _claveEventos,
      jsonEncode(
        _eventos.map((evento) => evento.toJson()).toList(),
      ),
    );
  }

  // OBTENER EVENTOS

  List<EventoCalendario> obtenerEventos() {
    return List.unmodifiable(_eventos);
  }

  // COMPARAR FECHAS

  bool mismaFecha(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  // COMPROBAR SI UN EVENTO CORRESPONDE A UNA FECHA

  bool eventoCorresponde(
      EventoCalendario evento,
      DateTime fecha,
      ) {
    final inicio = DateTime(
      evento.fechaInicio.year,
      evento.fechaInicio.month,
      evento.fechaInicio.day,
    );

    final fin = DateTime(
      evento.fechaFin.year,
      evento.fechaFin.month,
      evento.fechaFin.day,
    );

    final dia = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
    );

    return !dia.isBefore(inicio) && !dia.isAfter(fin);
  }

  // OBTENER EVENTOS DE UN DÍA

  List<EventoCalendario> obtenerEventosPorFecha(
      DateTime fecha,
      ) {
    return _eventos
        .where((evento) => eventoCorresponde(evento, fecha))
        .toList();
  }

  // AGREGAR EVENTO

  Future<void> agregarEvento(EventoCalendario evento) async {
    _eventos.add(evento);

    await _guardarEventos();

    notifyListeners();
  }

  // EDITAR EVENTO

  Future<void> editarEvento({
    required EventoCalendario eventoOriginal,
    required EventoCalendario eventoActualizado,
  }) async {
    final indice = _eventos.indexOf(eventoOriginal);

    if (indice == -1) return;

    _eventos[indice] = eventoActualizado;

    await _guardarEventos();

    notifyListeners();
  }

  // ELIMINAR EVENTO

  Future<void> eliminarEvento(
      EventoCalendario evento,
      ) async {
    _eventos.remove(evento);

    await _guardarEventos();

    notifyListeners();
  }

  // REGISTRAR UNA ACTIVIDAD COMPLETADA

  Future<void> completarActividad(String actividad) async {
    bool cambio = false;

    switch (actividad) {
    // PRÁCTICA 1: CONOCER CALENDARIO

      case 'avanzar_mes':
        if (!estado.avanzarMes) {
          estado.avanzarMes = true;
          cambio = true;
        }
        break;

      case 'retroceder_mes':
        if (!estado.retrocederMes) {
          estado.retrocederMes = true;
          cambio = true;
        }
        break;

      case 'seleccionar_dia':
        if (!estado.seleccionarDia) {
          estado.seleccionarDia = true;
          cambio = true;
        }
        break;

      case 'ir_hoy':
        if (!estado.irHoy) {
          estado.irHoy = true;
          cambio = true;
        }
        break;

    // PRÁCTICA 2: CREAR EVENTO

      case 'crear_evento':
        if (!estado.crearEvento) {
          estado.crearEvento = true;
          cambio = true;
        }
        break;

    // PRÁCTICA 3: CONSULTAR EVENTOS

      case 'consultar_evento':
        if (!estado.consultarEvento) {
          estado.consultarEvento = true;
          cambio = true;
        }
        break;

    // PRÁCTICA 4: EDITAR Y ELIMINAR

      case 'editar_evento':
        if (!estado.editarEvento) {
          estado.editarEvento = true;
          cambio = true;
        }
        break;

      case 'eliminar_evento':
        if (!estado.eliminarEvento) {
          estado.eliminarEvento = true;
          cambio = true;
        }
        break;
    }

    if (cambio) {
      notifyListeners();
      await _guardarProgreso();
    }
  }

  // CONSULTAR PROGRESO GENERAL

  int get progresoGeneral => estado.progresoGeneral;

  // REINICIAR TODO EL CALENDARIO

  Future<void> reiniciarTodo() async {
    estado = EstadoPracticaCalendario();
    _eventos.clear();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_claveProgreso);
    await prefs.remove(_claveEventos);

    notifyListeners();
  }
}
