
import 'package:flutter/material.dart';
import '../models/progreso_model.dart';

class ProgresoController extends ChangeNotifier {
  final ProgresoModel _modelo = ProgresoModel();

  // PROGRESO DE RELOJ

  void completarActividadReloj(String actividad) {
    final cantidadAnterior =
        _modelo.actividadesRelojCompletadas;

    _modelo.completarActividadReloj(actividad);

    if (_modelo.actividadesRelojCompletadas != cantidadAnterior) {
      notifyListeners();
    }
  }

  int obtenerPorcentajeReloj() {
    return _modelo.obtenerPorcentajeReloj();
  }

  int obtenerActividadesRelojCompletadas() {
    return _modelo.actividadesRelojCompletadas;
  }

  Set<String> obtenerActividadesReloj() {
    return _modelo.obtenerActividadesReloj();
  }

  void reiniciarProgresoReloj() {
    _modelo.reiniciarProgresoReloj();
    notifyListeners();
  }

  // PROGRESO DE CALENDARIO

  void completarActividadCalendario(String actividad) {
    final cantidadAnterior =
        _modelo.actividadesCalendarioCompletadas;

    _modelo.completarActividadCalendario(actividad);

    if (_modelo.actividadesCalendarioCompletadas != cantidadAnterior) {
      notifyListeners();
    }
  }

  int obtenerPorcentajeCalendario() {
    return _modelo.obtenerPorcentajeCalendario();
  }

  int obtenerActividadesCalendarioCompletadas() {
    return _modelo.actividadesCalendarioCompletadas;
  }

  Set<String> obtenerActividadesCalendario() {
    return _modelo.obtenerActividadesCalendario();
  }

  void reiniciarProgresoCalendario() {
    _modelo.reiniciarProgresoCalendario();
    notifyListeners();
  }
}
