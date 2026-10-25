import 'paso.dart';

class Practica {
  final int idPractica;
  final String tema;
  final String descripcion;
  List<Paso> pasos;

  Practica({
    required this.idPractica,
    required this.tema,
    required this.descripcion,
    this.pasos = const [],
  });
}