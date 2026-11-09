import 'package:flutter/material.dart';

import '../models/calendario/evento_model.dart';

class CalendarioController extends ChangeNotifier {
  final List<EventoCalendario> _eventos = [];

  List<EventoCalendario> obtenerEventos() {
    return List.unmodifiable(_eventos);
  }

  bool mismaFecha(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool eventoCorresponde(EventoCalendario evento, DateTime fecha) {
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

    final dia = DateTime(fecha.year, fecha.month, fecha.day);

    if (dia.isBefore(inicio)) return false;

    switch (evento.repeticion) {
      case 'Todos los días':
        return !dia.isAfter(fin);

      case 'Cada semana':
        return dia.weekday == inicio.weekday &&
            !dia.isAfter(fin);

      case 'Cada mes':
        return dia.day == inicio.day &&
            !dia.isAfter(fin);

      case 'Cada año':
        return dia.day == inicio.day &&
            dia.month == inicio.month &&
            !dia.isAfter(fin);

      default:
        return !dia.isBefore(inicio) && !dia.isAfter(fin);
    }
  }

  List<EventoCalendario> eventosDelDia(DateTime fecha) {
    return _eventos
        .where((evento) => eventoCorresponde(evento, fecha))
        .toList();
  }

  void agregarEvento(EventoCalendario evento) {
    _eventos.add(evento);
    notifyListeners();
  }

  void editarEvento(
      EventoCalendario eventoAnterior,
      EventoCalendario eventoNuevo,
      ) {
    final indice = _eventos.indexOf(eventoAnterior);

    if (indice == -1) return;

    _eventos[indice] = eventoNuevo;
    notifyListeners();
  }

  void eliminarEvento(EventoCalendario evento) {
    _eventos.remove(evento);
    notifyListeners();
  }
}