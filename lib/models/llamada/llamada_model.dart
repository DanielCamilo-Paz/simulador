class Contacto {
  final String nombre;
  final String numero;

  const Contacto({
    required this.nombre,
    required this.numero,
  });
}

class Llamada {
  final String nombre;
  final String numero;
  final String hora;
  final String tipo;

  const Llamada({
    required this.nombre,
    required this.numero,
    required this.hora,
    required this.tipo,
  });
}

class EstadoPracticaLlamada {
  bool numeroMarcado;
  bool contactoLlamado;
  bool recientesConsultados;

  EstadoPracticaLlamada({
    this.numeroMarcado = false,
    this.contactoLlamado = false,
    this.recientesConsultados = false,
  });

  int get pasosCompletados {
    int total = 0;

    if (numeroMarcado) total++;
    if (contactoLlamado) total++;
    if (recientesConsultados) total++;

    return total;
  }

  bool get completada => pasosCompletados == 3;
}