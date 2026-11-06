import 'package:flutter/material.dart';

class AlarmaModel {
  TimeOfDay hora;
  String nombre;
  bool activa;

  AlarmaModel({
    required this.hora,
    required this.nombre,
    this.activa = true,
  });

  String obtenerHoraFormateada() {
    return '${hora.hour.toString().padLeft(2, '0')}:'
        '${hora.minute.toString().padLeft(2, '0')}';
  }
}