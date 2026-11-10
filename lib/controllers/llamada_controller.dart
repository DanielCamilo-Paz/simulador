
import 'package:flutter/material.dart';

import '../models/llamada/llamada_model.dart';
import 'progreso_general_controller.dart';

class LlamadaController extends ChangeNotifier {
  String numeroMarcado = '';
  int pestanaActual = 0;

  // PROGRESO INDIVIDUAL DE LLAMADAS
  final EstadoPracticaLlamada progreso =
  EstadoPracticaLlamada();

  // CONTROLADOR GENERAL COMPARTIDO
  final ProgresoGeneralController progresoGeneral =
      progresoGeneralController;

  final List<Contacto> contactos = const [
    Contacto(nombre: 'Hijo David', numero: '3001234567'),
    Contacto(nombre: 'Hermana', numero: '3102345678'),
    Contacto(nombre: 'Mamá', numero: '3153456789'),
    Contacto(nombre: 'Primo', numero: '3204567890'),
    Contacto(nombre: 'Nieto', numero: '3015678901'),
    Contacto(nombre: 'Cuñado', numero: '3126789012'),
  ];

  final List<Llamada> recientes = [];

  // REGISTRAR LAS TRES LECCIONES
  LlamadaController() {
    progresoGeneral.registrarLecciones(
      'llamadas',
      {
        'marcar_numero': 'Marcar un número',
        'llamar_contacto': 'Llamar a un contacto',
        'consultar_recientes':
        'Consultar llamadas recientes',
      },
    );

    progresoGeneral.configurarTotalActividades(
      'llamadas',
      3,
    );
  }

  // AGREGAR NÚMERO
  void agregarNumero(String digito) {
    numeroMarcado += digito;
    notifyListeners();
  }

  // BORRAR NÚMERO
  void borrarNumero() {
    if (numeroMarcado.isEmpty) return;

    numeroMarcado =
        numeroMarcado.substring(
          0,
          numeroMarcado.length - 1,
        );

    notifyListeners();
  }

  // GUARDAR LLAMADA EN RECIENTES
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

  // ACTIVIDAD 1: MARCAR UN NÚMERO
  bool llamarNumero() {
    if (numeroMarcado.trim().isEmpty) {
      return false;
    }

    _guardarLlamada(
      nombre: 'Número marcado',
      numero: numeroMarcado,
    );

    numeroMarcado = '';

    // PROGRESO INDIVIDUAL
    progreso.numeroMarcado = true;

    // PROGRESO GENERAL
    progresoGeneral.completarActividad(
      'llamadas',
      'marcar_numero',
    );

    pestanaActual = 1;

    notifyListeners();
    return true;
  }

  // ACTIVIDAD 2: LLAMAR A UN CONTACTO
  void llamarContacto(Contacto contacto) {
    _guardarLlamada(
      nombre: contacto.nombre,
      numero: contacto.numero,
    );

    // PROGRESO INDIVIDUAL
    progreso.contactoLlamado = true;

    // PROGRESO GENERAL
    progresoGeneral.completarActividad(
      'llamadas',
      'llamar_contacto',
    );

    pestanaActual = 2;

    notifyListeners();
  }

  // ACTIVIDAD 3: CONSULTAR RECIENTES
  bool consultarRecientes() {
    if (!progreso.contactoLlamado ||
        recientes.isEmpty) {
      return false;
    }

    // PROGRESO INDIVIDUAL
    progreso.recientesConsultados = true;

    // PROGRESO GENERAL
    progresoGeneral.completarActividad(
      'llamadas',
      'consultar_recientes',
    );

    pestanaActual = 2;

    notifyListeners();
    return true;
  }

  // CAMBIAR PESTAÑA
  void cambiarPestana(int indice) {
    pestanaActual = indice;
    notifyListeners();
  }

  // PORCENTAJE INDIVIDUAL DE LLAMADAS
  double get porcentajeProgreso =>
      progreso.pasosCompletados / 3;
}
