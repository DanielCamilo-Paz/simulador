
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'paso.dart';

class Practica {
  final String id;
  final String titulo;
  final String descripcion;
  final String duracion;
  final String nivel;
  final Object icono;
  final List<Paso> pasos;

  Practica({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.duracion,
    required this.nivel,
    required this.icono,
    this.pasos = const [],
  });
}
