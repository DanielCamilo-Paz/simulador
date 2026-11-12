
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/configuracion/configuracion_model.dart';

// ========================================
// CONTROLADOR DE CONFIGURACIÓN DE SAFETAP
// ========================================

class ConfiguracionController extends ChangeNotifier {
  final ConfiguracionModel _modelo = ConfiguracionModel();

  // ========================================
  // OBTENER CONFIGURACIONES ACTUALES
  // ========================================

  double get escalaTexto => _modelo.escalaTexto;

  ThemeMode get modoTema => _modelo.modoTema;

  Color get colorPrincipal => _modelo.colorPrincipal;

  bool get modoOscuro => _modelo.modoTema == ThemeMode.dark;

  // ========================================
  // CARGAR CONFIGURACIONES GUARDADAS
  // ========================================

  Future<void> cargarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();

    _modelo.escalaTexto =
        prefs.getDouble('config_escala_texto') ?? 1.0;

    final String temaGuardado =
        prefs.getString('config_modo_tema') ?? 'light';

    _modelo.modoTema = temaGuardado == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;

    final int colorGuardado =
        prefs.getInt('config_color_principal') ?? 0xFF4D67BC;

    _modelo.colorPrincipal = Color(colorGuardado);

    notifyListeners();
  }

  // ========================================
  // CAMBIAR TAMAÑO DE LETRA
  // ========================================

  Future<void> cambiarTamanoLetra(double escala) async {
    if (!ConfiguracionModel.tamanosLetra.values.contains(escala)) {
      return;
    }

    _modelo.escalaTexto = escala;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(
      'config_escala_texto',
      escala,
    );
  }

  // ========================================
  // CAMBIAR MODO CLARO / OSCURO
  // ========================================

  Future<void> cambiarModoTema(bool oscuro) async {
    _modelo.modoTema =
    oscuro ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'config_modo_tema',
      oscuro ? 'dark' : 'light',
    );
  }

  // ========================================
  // CAMBIAR COLOR PRINCIPAL
  // ========================================

  Future<void> cambiarColor(Color nuevoColor) async {
    if (!ConfiguracionModel.coloresDisponibles.values
        .contains(nuevoColor)) {
      return;
    }

    _modelo.colorPrincipal = nuevoColor;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'config_color_principal',
      nuevoColor.toARGB32(),
    );
  }

  // ========================================
  // RESTABLECER CONFIGURACIÓN ORIGINAL
  // ========================================

  Future<void> restablecerConfiguracion() async {
    _modelo.escalaTexto = 1.0;
    _modelo.modoTema = ThemeMode.light;
    _modelo.colorPrincipal = const Color(0xFF4D67BC);

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('config_escala_texto', 1.0);
    await prefs.setString('config_modo_tema', 'light');
    await prefs.setInt(
      'config_color_principal',
      0xFF4D67BC,
    );
  }
}
