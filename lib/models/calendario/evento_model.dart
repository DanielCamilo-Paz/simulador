class EventoCalendario {
  String titulo;
  DateTime fechaInicio;
  DateTime fechaFin;
  bool todoElDia;
  String repeticion;
  String recordatorio;
  String tipoRecordatorio;
  String descripcion;

  EventoCalendario({
    required this.titulo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.todoElDia,
    required this.repeticion,
    required this.recordatorio,
    required this.tipoRecordatorio,
    required this.descripcion,
  });
}