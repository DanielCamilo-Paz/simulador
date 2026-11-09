import 'package:flutter/material.dart';
import '../models/llamada/llamada_model.dart';

class LlamadaController extends ChangeNotifier {
  String numeroMarcado = '';
  int pestanaActual = 0;

  final EstadoPracticaLlamada progreso = EstadoPracticaLlamada();

  final List<Contacto> contactos = const [
    Contacto(nombre: 'Hijo David', numero: '3001234567'),
    Contacto(nombre: 'Hermana', numero: '3102345678'),
    Contacto(nombre: 'Mamá', numero: '3153456789'),
    Contacto(nombre: 'Primo', numero: '3204567890'),
    Contacto(nombre: 'Nieto', numero: '3015678901'),
    Contacto(nombre: 'Cuñado', numero: '3126789012'),
  ];

  final List<Llamada> recientes = [];

  void agregarNumero(String digito) {
    numeroMarcado += digito;
    notifyListeners();
  }

  void borrarNumero() {
    if (numeroMarcado.isEmpty) return;

    numeroMarcado =
        numeroMarcado.substring(0, numeroMarcado.length - 1);

    notifyListeners();
  }

  void _guardarLlamada({
    required String nombre,
    required String numero,
  }) {
    final ahora = DateTime.now();
    final hora =
        '${ahora.hour.toString().padLeft(2, '0')}:'
        '${ahora.minute.toString().padLeft(2, '0')}';

    recientes.insert(
      0,
      Llamada(
        nombre: nombre,
        numero: numero,
        hora: hora,
        tipo: 'Llamada saliente',
      ),
    );
  }

  bool llamarNumero() {
    if (numeroMarcado.trim().isEmpty) return false;

    _guardarLlamada(
      nombre: 'Número marcado',
      numero: numeroMarcado,
    );

    numeroMarcado = '';
    progreso.numeroMarcado = true;
    pestanaActual = 1;

    notifyListeners();
    return true;
  }

  void llamarContacto(Contacto contacto) {
    _guardarLlamada(
      nombre: contacto.nombre,
      numero: contacto.numero,
    );

    progreso.contactoLlamado = true;
    pestanaActual = 2;

    notifyListeners();
  }

  bool consultarRecientes() {
    if (!progreso.contactoLlamado || recientes.isEmpty) {
      return false;
    }

    progreso.recientesConsultados = true;
    pestanaActual = 2;

    notifyListeners();
    return true;
  }

  void cambiarPestana(int indice) {
    pestanaActual = indice;
    notifyListeners();
  }

  double get porcentajeProgreso =>
      progreso.pasosCompletados / 3;
}