
import 'package:flutter/material.dart';

import '../models/progreso_general/progreso_general_model.dart';

class ProgresoGeneralController extends ChangeNotifier {

  // PESO DE CADA FUNCIÓN EN EL PROGRESO GENERAL

  static const Map<String, double> pesos = {
    'llamadas': 15.0,
    'camara': 20.0,
    'reloj': 25.0,
    'calendario': 20.0,
    'whatsapp': 20.0,
  };

  // NOMBRES DE LAS FUNCIONES

  static const Map<String, String> nombres = {
    'llamadas': 'Llamadas',
    'camara': 'Cámara y Galería',
    'reloj': 'Reloj y Alarmas',
    'calendario': 'Calendario',
    'whatsapp': 'WhatsApp',
  };

  // LECCIONES REGISTRADAS EN CADA FUNCIÓN
  // Guarda el ID y el nombre visible de cada lección.

  final Map<String, Map<String, String>> _lecciones = {
    'llamadas': {},
    'camara': {},
    'reloj': {},
    'calendario': {},
    'whatsapp': {},
  };

  // IDENTIFICADORES DE LECCIONES COMPLETADAS

  final Map<String, Set<String>> _actividadesCompletadas = {
    'llamadas': <String>{},
    'camara': <String>{},
    'reloj': <String>{},
    'calendario': <String>{},
    'whatsapp': <String>{},
  };

  // TOTAL DE ACTIVIDADES POR FUNCIÓN

  final Map<String, int> _totalActividades = {
    'llamadas': 0,
    'camara': 0,
    'reloj': 0,
    'calendario': 0,
    'whatsapp': 0,
  };

  // REGISTRAR UNA LECCIÓN CON SU NOMBRE

  void registrarLeccion(
      String aplicacion,
      String idLeccion,
      String nombreLeccion,
      ) {
    if (!_lecciones.containsKey(aplicacion)) return;

    final id = idLeccion.trim();
    final nombre = nombreLeccion.trim();

    if (id.isEmpty || nombre.isEmpty) return;

    final lecciones = _lecciones[aplicacion]!;

    if (lecciones[id] == nombre) return;

    lecciones[id] = nombre;

    // Mantener el total sincronizado con las
    // lecciones registradas.
    if (lecciones.length >
        (_totalActividades[aplicacion] ?? 0)) {
      _totalActividades[aplicacion] = lecciones.length;
    }

    notifyListeners();
  }

  // REGISTRAR VARIAS LECCIONES AL MISMO TIEMPO

  void registrarLecciones(
      String aplicacion,
      Map<String, String> nuevasLecciones,
      ) {
    if (!_lecciones.containsKey(aplicacion)) return;

    final lecciones = _lecciones[aplicacion]!;

    bool huboCambios = false;

    for (final entrada in nuevasLecciones.entries) {
      final id = entrada.key.trim();
      final nombre = entrada.value.trim();

      if (id.isEmpty || nombre.isEmpty) continue;

      if (lecciones[id] != nombre) {
        lecciones[id] = nombre;
        huboCambios = true;
      }
    }

    if (!huboCambios) return;

    if (lecciones.length >
        (_totalActividades[aplicacion] ?? 0)) {
      _totalActividades[aplicacion] = lecciones.length;
    }

    notifyListeners();
  }

  // CONFIGURAR EL TOTAL DE ACTIVIDADES

  void configurarTotalActividades(
      String aplicacion,
      int total,
      ) {
    if (!pesos.containsKey(aplicacion)) return;
    if (total < 0) return;

    final cantidadRegistrada =
        _lecciones[aplicacion]?.length ?? 0;

    // El total no puede ser menor que la cantidad
    // de lecciones registradas.
    final nuevoTotal = total < cantidadRegistrada
        ? cantidadRegistrada
        : total;

    if (_totalActividades[aplicacion] == nuevoTotal) {
      return;
    }

    _totalActividades[aplicacion] = nuevoTotal;

    notifyListeners();
  }

  // MARCAR UNA LECCIÓN COMO COMPLETADA

  void completarActividad(
      String aplicacion,
      String idActividad,
      ) {
    if (!_actividadesCompletadas.containsKey(aplicacion)) {
      return;
    }

    final id = idActividad.trim();

    if (id.isEmpty) return;

    final actividades =
    _actividadesCompletadas[aplicacion]!;

    // Set evita contar dos veces una misma lección.
    if (actividades.add(id)) {
      notifyListeners();
    }
  }

  // CONSULTAR SI UNA LECCIÓN ESTÁ COMPLETADA

  bool actividadCompletada(
      String aplicacion,
      String idActividad,
      ) {
    return _actividadesCompletadas[aplicacion]
        ?.contains(idActividad) ??
        false;
  }

  // OBTENER LAS LECCIONES DE UNA FUNCIÓN
  // Incluye ID, nombre y estado de cada lección.

  List<Map<String, dynamic>> obtenerDetalleLecciones(
      String aplicacion,
      ) {
    final lecciones = _lecciones[aplicacion];

    if (lecciones == null) return [];

    return lecciones.entries.map((entrada) {
      return {
        'id': entrada.key,
        'nombre': entrada.value,
        'completada': actividadCompletada(
          aplicacion,
          entrada.key,
        ),
      };
    }).toList();
  }

  // CANTIDAD DE LECCIONES COMPLETADAS

  int obtenerCantidadCompletadas(String aplicacion) {
    final completadas =
        _actividadesCompletadas[aplicacion]?.length ?? 0;

    final total = _totalActividades[aplicacion] ?? 0;

    if (total <= 0) return 0;

    return completadas.clamp(0, total);
  }

  // CANTIDAD TOTAL DE LECCIONES

  int obtenerTotalActividades(String aplicacion) {
    return _totalActividades[aplicacion] ?? 0;
  }

  // PROGRESO INDIVIDUAL DE UNA FUNCIÓN

  ProgresoAplicacionModel obtenerProgresoAplicacion(
      String aplicacion,
      ) {
    return ProgresoAplicacionModel(
      id: aplicacion,
      nombre: nombres[aplicacion] ?? aplicacion,
      pesoMaximo: pesos[aplicacion] ?? 0,
      actividadesCompletadas:
      obtenerCantidadCompletadas(aplicacion),
      totalActividades:
      obtenerTotalActividades(aplicacion),
    );
  }

  // PROGRESO DE LAS CINCO FUNCIONES

  ProgresoGeneralModel obtenerProgresoGeneral() {
    return ProgresoGeneralModel(
      aplicaciones: pesos.keys
          .map(obtenerProgresoAplicacion)
          .toList(),
    );
  }

  // PORCENTAJE GENERAL DE SAFETAP

  double get porcentajeGeneral {
    return obtenerProgresoGeneral().porcentajeGeneral;
  }

  // TOTAL DE LECCIONES DE TODA LA APLICACIÓN

  int get totalLecciones {
    int total = 0;

    for (final cantidad in _totalActividades.values) {
      total += cantidad;
    }

    return total;
  }

  // TOTAL DE LECCIONES COMPLETADAS EN SAFETAP

  int get totalLeccionesCompletadas {
    int total = 0;

    for (final aplicacion in pesos.keys) {
      total += obtenerCantidadCompletadas(aplicacion);
    }

    return total;
  }

  // REINICIAR UNA LECCIÓN

  void reiniciarActividad(
      String aplicacion,
      String idActividad,
      ) {
    final actividades =
    _actividadesCompletadas[aplicacion];

    if (actividades == null) return;

    if (actividades.remove(idActividad)) {
      notifyListeners();
    }
  }

  // REINICIAR UNA FUNCIÓN COMPLETA

  void reiniciarAplicacion(String aplicacion) {
    final actividades =
    _actividadesCompletadas[aplicacion];

    if (actividades == null || actividades.isEmpty) {
      return;
    }

    actividades.clear();

    notifyListeners();
  }

  // REINICIAR TODO EL PROGRESO

  void reiniciarTodo() {
    for (final actividades
    in _actividadesCompletadas.values) {
      actividades.clear();
    }

    notifyListeners();
  }
}

// CONTROLADOR COMPARTIDO
// Se utilizará en InicioView, ProgresoGeneralView
// y en las pantallas de las prácticas.

final progresoGeneralController =
ProgresoGeneralController();
