import 'package:flutter/material.dart';  // ← Para IconData
import 'paso.dart';                      // ← Para la clase Paso

class Practica {
  final String id;
  final String titulo;
  final String descripcion;
  final String duracion;
  final String nivel;
  final IconData icono;
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