
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/reloj/alarma_model.dart';
import '../models/reloj/cronometro_model.dart';

class RelojController extends ChangeNotifier {
  // ==============================
  // ALARMAS
  // ==============================

  final List<AlarmaModel> alarmas = [];

  void agregarAlarma({
    required TimeOfDay hora,
    required String nombre,
    bool activa = true,
  }) {
    alarmas.add(
      AlarmaModel(
        hora: hora,
        nombre: nombre,
        activa: activa,
      ),
    );
    notifyListeners();
  }

  void editarAlarma({
    required int indice,
    required TimeOfDay hora,
    required String nombre,
    required bool activa,
  }) {
    if (indice < 0 || indice >= alarmas.length) return;

    alarmas[indice].hora = hora;
    alarmas[indice].nombre = nombre;
    alarmas[indice].activa = activa;
    notifyListeners();
  }

  void eliminarAlarma(int indice) {
    if (indice < 0 || indice >= alarmas.length) return;

    alarmas.removeAt(indice);
    notifyListeners();
  }

  void cambiarEstadoAlarma(int indice, bool activa) {
    if (indice < 0 || indice >= alarmas.length) return;

    alarmas[indice].activa = activa;
    notifyListeners();
  }

  AlarmaModel? obtenerProximaAlarma() {
    final activas = alarmas.where((alarma) => alarma.activa).toList();

    if (activas.isEmpty) return null;

    activas.sort((a, b) {
      final minutosA = a.hora.hour * 60 + a.hora.minute;
      final minutosB = b.hora.hour * 60 + b.hora.minute;
      return minutosA.compareTo(minutosB);
    });

    final ahora = TimeOfDay.now();
    final minutosActuales = ahora.hour * 60 + ahora.minute;

    for (final alarma in activas) {
      final minutos = alarma.hora.hour * 60 + alarma.hora.minute;

      if (minutos > minutosActuales) {
        return alarma;
      }
    }

    return activas.first;
  }

  // ==============================
  // CRONÓMETRO
  // ==============================

  final CronometroModel cronometro = CronometroModel();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  bool get estaEnMarcha => _stopwatch.isRunning;
  Duration get tiempoTranscurrido => _stopwatch.elapsed;

  String _formatearTiempo(Duration duracion) {
    final horas = duracion.inHours.toString().padLeft(2, '0');
    final minutos =
    (duracion.inMinutes % 60).toString().padLeft(2, '0');
    final segundos =
    (duracion.inSeconds % 60).toString().padLeft(2, '0');

    return '$horas:$minutos:$segundos';
  }

  void iniciarCronometro() {
    if (_stopwatch.isRunning) return;

    _stopwatch.start();
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
          (_) {
        cronometro.actualizarTiempo(
          _formatearTiempo(_stopwatch.elapsed),
        );
        notifyListeners();
      },
    );

    notifyListeners();
  }

  void pausarCronometro() {
    _stopwatch.stop();
    _timer?.cancel();

    cronometro.actualizarTiempo(
      _formatearTiempo(_stopwatch.elapsed),
    );
    notifyListeners();
  }

  void reiniciarCronometro() {
    _stopwatch
      ..stop()
      ..reset();

    _timer?.cancel();
    cronometro.reiniciar();
    notifyListeners();
  }

  void guardarVuelta() {
    if (_stopwatch.elapsedMilliseconds <= 0) return;

    cronometro.actualizarTiempo(
      _formatearTiempo(_stopwatch.elapsed),
    );

    cronometro.guardarVuelta();
    notifyListeners();
  }

  // ==============================
  // PROGRESO DE LAS PRÁCTICAS
  // ==============================

  static const Map<String, List<String>> actividades = {
    'alarmas': [
      'crear_alarma',
      'editar_alarma',
      'cambiar_estado_alarma',
      'eliminar_alarma',
    ],
    'mundial': [
      'consultar_ciudad',
    ],
    'cronometro': [
      'iniciar_cronometro',
      'pausar_cronometro',
      'guardar_vuelta',
      'reiniciar_cronometro',
    ],
  };

  final Set<String> _actividadesCompletadas = {};

  bool cargandoProgreso = true;

  Future<void> iniciarProgreso() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final guardadas = prefs.getStringList(
        'reloj_actividades_completadas',
      ) ?? [];

      final validas = actividades.values
          .expand((lista) => lista)
          .toSet();

      _actividadesCompletadas
        ..clear()
        ..addAll(
          guardadas.where(validas.contains),
        );
    } catch (e) {
      debugPrint('Error al cargar progreso de Reloj: $e');
    } finally {
      cargandoProgreso = false;
      notifyListeners();
    }
  }

  bool actividadCompletada(String actividad) {
    return _actividadesCompletadas.contains(actividad);
  }

  int actividadesRealizadas(String practica) {
    final lista = actividades[practica] ?? [];

    return lista
        .where(_actividadesCompletadas.contains)
        .length;
  }

  int totalActividades(String practica) {
    return actividades[practica]?.length ?? 0;
  }

  double porcentajePractica(String practica) {
    final total = totalActividades(practica);

    if (total == 0) return 0;

    return actividadesRealizadas(practica) / total * 100;
  }

  bool practicaCompletada(String practica) {
    final total = totalActividades(practica);

    return total > 0 &&
        actividadesRealizadas(practica) == total;
  }

  int get practicasCompletadas {
    return actividades.keys
        .where(practicaCompletada)
        .length;
  }

  double get porcentajeGeneral {
    final porcentajes = actividades.keys
        .map(porcentajePractica)
        .toList();

    if (porcentajes.isEmpty) return 0;

    return porcentajes.reduce((a, b) => a + b) /
        porcentajes.length;
  }

  Future<void> completarActividad(String actividad) async {
    final validas = actividades.values
        .expand((lista) => lista)
        .toSet();

    if (!validas.contains(actividad)) return;

    final agregada = _actividadesCompletadas.add(actividad);

    if (!agregada) return;

    notifyListeners();
    await _guardarProgreso();
  }

  Future<void> _guardarProgreso() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setStringList(
        'reloj_actividades_completadas',
        _actividadesCompletadas.toList(),
      );
    } catch (e) {
      debugPrint('Error al guardar progreso de Reloj: $e');
    }
  }

  Future<void> reiniciarProgreso() async {
    _actividadesCompletadas.clear();
    notifyListeners();
    await _guardarProgreso();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}
