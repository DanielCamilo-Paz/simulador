import 'package:flutter/material.dart';
import '../models/practica.dart';
import '../models/paso.dart';

class PracticaController extends ChangeNotifier {
  int pasoActual = 0;

  final List<Practica> listaPracticas = [
    Practica(
      id: 'llamada',
      titulo: 'Realizar Llamada telefónica',
      descripcion: 'Aprende a realizar una llamada a algún contacto cercano',
      duracion: '5 minutos',
      nivel: 'Fácil',
      icono: Icons.phone,
      pasos: [
        Paso(numero: 1, instruccion: 'Selecciona un contacto de la lista'),
        Paso(numero: 2, instruccion: 'Presiona el botón Llamar'),
      ],
    ),
    Practica(
      id: 'foto',
      titulo: 'Realizar Foto o Video',
      descripcion: 'Aprende a tomar una foto o video, básico en opciones de cámara',
      duracion: '5 minutos',
      nivel: 'Fácil',
      icono: Icons.camera_alt,
    ),
    Practica(
      id: 'alarma',
      titulo: 'Colocar recordatorio',
      descripcion: 'Aprende a colocar un recordatorio en la fecha y hora que gustes',
      duracion: '5 minutos',
      nivel: 'Fácil',
      icono: Icons.access_time,
    ),
    Practica(
      id: 'galeria',
      titulo: 'Editar, Eliminar Foto',
      descripcion: 'Aprende a entrar a galería para mirar tus fotos y decidir eliminar o editar',
      duracion: '5 minutos',
      nivel: 'Fácil',
      icono: Icons.photo_library,
    ),
    Practica(
      id: 'whatsapp',
      titulo: 'Enviar mensaje WhatsApp',
      descripcion: 'Aprende a enviar un mensaje por WhatsApp sin necesidad de saber escribir',
      duracion: '5 minutos',
      nivel: 'Fácil',
      icono: Icons.message,
    ),
  ];

  Practica? practicaSeleccionada;

  void seleccionarPractica(Practica p) {
    practicaSeleccionada = p;
    pasoActual = 0;
    notifyListeners();
  }

  void avanzarPaso() {
    if (practicaSeleccionada != null && pasoActual < practicaSeleccionada!.pasos.length - 1) {
      pasoActual++;
      notifyListeners();
    }
  }

  bool get practicaTerminada {
    if (practicaSeleccionada == null) return false;
    return pasoActual >= practicaSeleccionada!.pasos.length - 1;
  }
}