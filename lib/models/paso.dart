class Paso {
  final int idPaso;
  final int idPractica;
  final int numeroPaso;
  final String instruccion;
  final String accionEsperada;
  final String mensajeCorrecto;
  final String mensajeIncorrecto;

  Paso({
    required this.idPaso,
    required this.idPractica,
    required this.numeroPaso,
    required this.instruccion,
    required this.accionEsperada,
    required this.mensajeCorrecto,
    required this.mensajeIncorrecto,
  });
}