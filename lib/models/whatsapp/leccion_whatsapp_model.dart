
import 'package:flutter/material.dart';

class LeccionWhatsappModel {
  final String id;
  final String tipo;
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Color color;

  const LeccionWhatsappModel({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
  });
}
