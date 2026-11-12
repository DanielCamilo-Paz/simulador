
import 'package:flutter/material.dart';

// ========================================
// MODELO DE CONFIGURACIÓN DE SAFETAP
// ========================================

class ConfiguracionModel {
  // Tamaño de letra
  double escalaTexto;

  // Apariencia de la aplicación
  ThemeMode modoTema;

  // Color principal
  Color colorPrincipal;

  ConfiguracionModel({
    this.escalaTexto = 1.0,
    this.modoTema = ThemeMode.light,
    this.colorPrincipal = const Color(0xFF4D67BC),
  });

  // ========================================
  // OPCIONES DE TAMAÑO DE LETRA
  // ========================================

  static const Map<String, double> tamanosLetra = {
    'Pequeña': 0.85,
    'Normal': 1.0,
    'Grande': 1.2,
    'Muy grande': 1.4,
  };

  // ========================================
  // PALETAS DE COLORES
  // ========================================

  static const Map<String, Color> coloresDisponibles = {
    'Azul': Color(0xFF4D67BC),
    'Verde': Color(0xFF299764),
    'Morado': Color(0xFF8757C8),
    'Naranja': Color(0xFFD97735),
  };
}
