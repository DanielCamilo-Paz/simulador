
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

  // CONVERTIR EVENTO A JSON

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'todoElDia': todoElDia,
      'repeticion': repeticion,
      'recordatorio': recordatorio,
      'tipoRecordatorio': tipoRecordatorio,
      'descripcion': descripcion,
    };
  }

  // RECUPERAR EVENTO GUARDADO

  factory EventoCalendario.fromJson(
      Map<String, dynamic> json,
      ) {
    return EventoCalendario(
      titulo: json['titulo'] ?? '',
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: DateTime.parse(json['fechaFin']),
      todoElDia: json['todoElDia'] == true,
      repeticion: json['repeticion'] ?? 'Nunca',
      recordatorio: json['recordatorio'] ?? 'Sin recordatorio',
      tipoRecordatorio: json['tipoRecordatorio'] ?? 'Notificación',
      descripcion: json['descripcion'] ?? '',
    );
  }
}

// ESTADO DE LAS PRÁCTICAS DEL CALENDARIO

class EstadoPracticaCalendario {
  // PRÁCTICA 1: CONOCER EL CALENDARIO

  bool avanzarMes;
  bool retrocederMes;
  bool seleccionarDia;
  bool irHoy;

  // PRÁCTICA 2: CREAR UN EVENTO

  bool crearEvento;

  // PRÁCTICA 3: CONSULTAR EVENTOS

  bool consultarEvento;

  // PRÁCTICA 4: EDITAR Y ELIMINAR EVENTOS

  bool editarEvento;
  bool eliminarEvento;

  EstadoPracticaCalendario({
    this.avanzarMes = false,
    this.retrocederMes = false,
    this.seleccionarDia = false,
    this.irHoy = false,
    this.crearEvento = false,
    this.consultarEvento = false,
    this.editarEvento = false,
    this.eliminarEvento = false,
  });

  // VERIFICAR PRÁCTICAS COMPLETADAS

  bool get practicaConocerCompletada =>
      avanzarMes &&
          retrocederMes &&
          seleccionarDia &&
          irHoy;

  bool get practicaCrearCompletada => crearEvento;

  bool get practicaConsultarCompletada => consultarEvento;

  bool get practicaEditarEliminarCompletada =>
      editarEvento && eliminarEvento;

  // CONTAR ACTIVIDADES COMPLETADAS

  int get progresoConocer =>
      (avanzarMes ? 1 : 0) +
          (retrocederMes ? 1 : 0) +
          (seleccionarDia ? 1 : 0) +
          (irHoy ? 1 : 0);

  int get progresoCrear =>
      crearEvento ? 1 : 0;

  int get progresoConsultar =>
      consultarEvento ? 1 : 0;

  int get progresoEditarEliminar =>
      (editarEvento ? 1 : 0) +
          (eliminarEvento ? 1 : 0);

  // PROGRESO GENERAL
  // CADA PRÁCTICA COMPLETA VALE 25%

  int get progresoGeneral =>
      (practicaConocerCompletada ? 25 : 0) +
          (practicaCrearCompletada ? 25 : 0) +
          (practicaConsultarCompletada ? 25 : 0) +
          (practicaEditarEliminarCompletada ? 25 : 0);

  // TOTAL DE PRÁCTICAS COMPLETADAS

  int get practicasCompletadas =>
      (practicaConocerCompletada ? 1 : 0) +
          (practicaCrearCompletada ? 1 : 0) +
          (practicaConsultarCompletada ? 1 : 0) +
          (practicaEditarEliminarCompletada ? 1 : 0);

  bool get todasCompletadas =>
      practicasCompletadas == 4;

  // GUARDAR PROGRESO EN JSON

  Map<String, dynamic> toJson() {
    return {
      'avanzarMes': avanzarMes,
      'retrocederMes': retrocederMes,
      'seleccionarDia': seleccionarDia,
      'irHoy': irHoy,
      'crearEvento': crearEvento,
      'consultarEvento': consultarEvento,
      'editarEvento': editarEvento,
      'eliminarEvento': eliminarEvento,
    };
  }

  // RECUPERAR PROGRESO GUARDADO

  factory EstadoPracticaCalendario.fromJson(
      Map<String, dynamic> json,
      ) {
    return EstadoPracticaCalendario(
      avanzarMes: json['avanzarMes'] == true,
      retrocederMes: json['retrocederMes'] == true,
      seleccionarDia: json['seleccionarDia'] == true,
      irHoy: json['irHoy'] == true,
      crearEvento: json['crearEvento'] == true,
      consultarEvento: json['consultarEvento'] == true,
      editarEvento: json['editarEvento'] == true,
      eliminarEvento: json['eliminarEvento'] == true,
    );
  }
}
