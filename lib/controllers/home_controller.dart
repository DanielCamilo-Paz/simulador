
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  // Control de la opción seleccionada en el menú
  int selectedIndex = 0;

  // Cambiar la opción seleccionada
  void changePage(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // Opciones principales del simulador
  final List<String> menuOptions = [
    'Inicio',
    'Simulador',
    'Historial',
    'Configuración',
  ];

  // Título de bienvenida
  String get welcomeTitle => 'Bienvenido al simulador';

  // Descripción principal
  String get welcomeDescription =>
      'Explora las herramientas y funcionalidades disponibles.';
}
