import 'dart:async';
import 'package:flutter/material.dart';

import '../models/reloj/alarma_model.dart';
import '../models/reloj/cronometro_model.dart';

class RelojController extends ChangeNotifier {
  // ---------------- ALARMAS ----------------

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

  // ---------------- CRONÓMETRO ----------------

  final CronometroModel cronometro = CronometroModel();

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  bool get estaEnMarcha => _stopwatch.isRunning;

  Duration get tiempoTranscurrido => _stopwatch.elapsed;

  String _formatearTiempo(Duration duracion) {
    final horas = duracion.inHours.toString().padLeft(2, '0');
    final minutos = (duracion.inMinutes % 60).toString().padLeft(2, '0');
    final segundos = (duracion.inSeconds % 60).toString().padLeft(2, '0');

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

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}