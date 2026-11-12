
import 'package:flutter/material.dart';

import '../../controllers/calendario_controller.dart';
import '../../models/calendario/calendario_model.dart';

class PracticaEditarEliminarView extends StatefulWidget {
  final CalendarioController controller;

  const PracticaEditarEliminarView({
    super.key,
    required this.controller,
  });

  @override
  State<PracticaEditarEliminarView> createState() =>
      _PracticaEditarEliminarViewState();
}

class _PracticaEditarEliminarViewState
    extends State<PracticaEditarEliminarView> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);
  static const Color azulBoton = Color(0xFF4D67BC);
  static const Color textoOscuro = Color(0xFF202C33);

  late DateTime mesActual;
  late DateTime fechaSeleccionada;

  // ==========================================
  // TEMA CLARO PARA VENTANAS
  // ==========================================

  ThemeData get temaClaro {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: fondo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: azulBoton,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: textoOscuro),
        bodyLarge: TextStyle(color: textoOscuro),
        titleMedium: TextStyle(color: textoOscuro),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final hoy = DateTime.now();

    mesActual = DateTime(hoy.year, hoy.month);
    fechaSeleccionada = hoy;
  }

  // ==========================================
  // FORMATO DE FECHAS Y HORAS
  // ==========================================

  String nombreMes(int mes) {
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return meses[mes - 1];
  }

  String formatoFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');

    return '$dia/$mes/${fecha.year}';
  }

  String formatoHora(DateTime fecha) {
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
  }

  // ==========================================
  // NAVEGACIÓN DEL CALENDARIO
  // ==========================================

  void cambiarMes(int cantidad) {
    setState(() {
      mesActual = DateTime(
        mesActual.year,
        mesActual.month + cantidad,
      );
    });
  }

  void seleccionarFecha(DateTime fecha) {
    setState(() {
      fechaSeleccionada = fecha;
    });
  }

  void volverHoy() {
    final hoy = DateTime.now();

    setState(() {
      mesActual = DateTime(hoy.year, hoy.month);
      fechaSeleccionada = hoy;
    });
  }

  // ==========================================
  // DECORACIÓN DE CAMPOS
  // ==========================================

  InputDecoration decoracionCampo(String etiqueta) {
    return InputDecoration(
      labelText: etiqueta,
      labelStyle: const TextStyle(
        color: textoOscuro,
      ),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF9AA9B3),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: azulBoton,
          width: 2,
        ),
      ),
    );
  }

  // ==========================================
  // EDITAR EVENTO
  // ==========================================

  Future<void> editarEvento(EventoCalendario evento) async {
    final tituloController = TextEditingController(
      text: evento.titulo,
    );

    final descripcionController = TextEditingController(
      text: evento.descripcion,
    );

    DateTime fechaInicio = evento.fechaInicio;
    DateTime fechaFin = evento.fechaFin;

    bool todoElDia = evento.todoElDia;

    String repeticion = evento.repeticion;
    String recordatorio = evento.recordatorio;
    String tipoRecordatorio = evento.tipoRecordatorio;

    final actualizado = await showDialog<EventoCalendario>(
      context: context,
      builder: (dialogContext) {
        return Theme(
          data: temaClaro,
          child: StatefulBuilder(
            builder: (context, actualizarDialogo) {
              // ==================================
              // ELEGIR FECHA
              // ==================================

              Future<void> elegirFecha(bool inicio) async {
                final actual =
                inicio ? fechaInicio : fechaFin;

                final elegida = await showDatePicker(
                  context: context,
                  initialDate: actual,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  helpText: 'Selecciona una fecha',
                  cancelText: 'Cancelar',
                  confirmText: 'Aceptar',
                  builder: (context, child) {
                    return Theme(
                      data: temaClaro,
                      child:
                      child ?? const SizedBox.shrink(),
                    );
                  },
                );

                if (elegida == null || !context.mounted) {
                  return;
                }

                actualizarDialogo(() {
                  final nueva = DateTime(
                    elegida.year,
                    elegida.month,
                    elegida.day,
                    actual.hour,
                    actual.minute,
                  );

                  if (inicio) {
                    fechaInicio = nueva;

                    if (fechaFin.isBefore(fechaInicio)) {
                      fechaFin = fechaInicio.add(
                        const Duration(hours: 1),
                      );
                    }
                  } else {
                    fechaFin = nueva;
                  }
                });
              }

              // ==================================
              // ELEGIR HORA
              // ==================================

              Future<void> elegirHora(bool inicio) async {
                final actual =
                inicio ? fechaInicio : fechaFin;

                final elegida = await showTimePicker(
                  context: context,
                  initialTime:
                  TimeOfDay.fromDateTime(actual),
                  helpText: 'Selecciona una hora',
                  cancelText: 'Cancelar',
                  confirmText: 'Aceptar',
                  builder: (context, child) {
                    return Theme(
                      data: temaClaro,
                      child:
                      child ?? const SizedBox.shrink(),
                    );
                  },
                );

                if (elegida == null || !context.mounted) {
                  return;
                }

                actualizarDialogo(() {
                  final nueva = DateTime(
                    actual.year,
                    actual.month,
                    actual.day,
                    elegida.hour,
                    elegida.minute,
                  );

                  if (inicio) {
                    fechaInicio = nueva;

                    if (fechaFin.isBefore(fechaInicio)) {
                      fechaFin = fechaInicio.add(
                        const Duration(hours: 1),
                      );
                    }
                  } else {
                    fechaFin = nueva;
                  }
                });
              }

              // ==================================
              // SELECTOR DE FECHA Y HORA
              // ==================================

              Widget selector(
                  String titulo,
                  String valor,
                  VoidCallback accion,
                  ) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textoOscuro,
                    ),
                  ),
                  subtitle: Text(
                    valor,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: textoOscuro,
                  ),
                  onTap: accion,
                );
              }

              // ==================================
              // FORMULARIO DE EDICIÓN
              // ==================================

              return AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'Editar evento',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textoOscuro,
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ==========================
                        // TÍTULO
                        // ==========================

                        TextField(
                          controller: tituloController,
                          style: const TextStyle(
                            color: textoOscuro,
                          ),
                          cursorColor: azulBoton,
                          decoration: decoracionCampo(
                            'Título del evento',
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ==========================
                        // TODO EL DÍA
                        // ==========================

                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Todo el día',
                            style: TextStyle(
                              color: textoOscuro,
                            ),
                          ),
                          value: todoElDia,
                          activeColor: verde,
                          onChanged: (valor) {
                            actualizarDialogo(() {
                              todoElDia = valor;
                            });
                          },
                        ),

                        // ==========================
                        // FECHA DE INICIO
                        // ==========================

                        selector(
                          'Fecha de inicio',
                          formatoFecha(fechaInicio),
                              () => elegirFecha(true),
                        ),

                        // ==========================
                        // HORA DE INICIO
                        // ==========================

                        if (!todoElDia)
                          selector(
                            'Hora de inicio',
                            formatoHora(fechaInicio),
                                () => elegirHora(true),
                          ),

                        // ==========================
                        // FECHA FINAL
                        // ==========================

                        selector(
                          'Fecha de finalización',
                          formatoFecha(fechaFin),
                              () => elegirFecha(false),
                        ),

                        // ==========================
                        // HORA FINAL
                        // ==========================

                        if (!todoElDia)
                          selector(
                            'Hora de finalización',
                            formatoHora(fechaFin),
                                () => elegirHora(false),
                          ),

                        const SizedBox(height: 12),

                        // ==========================
                        // REPETICIÓN
                        // ==========================

                        DropdownButtonFormField<String>(
                          value: repeticion,
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            color: textoOscuro,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Repetir',
                            labelStyle: TextStyle(
                              color: textoOscuro,
                            ),
                          ),
                          items: [
                            'Nunca',
                            'Todos los días',
                            'Cada semana',
                            'Cada mes',
                            'Cada año',
                          ].map((opcion) {
                            return DropdownMenuItem<String>(
                              value: opcion,
                              child: Text(
                                opcion,
                                style: const TextStyle(
                                  color: textoOscuro,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            if (valor != null) {
                              actualizarDialogo(() {
                                repeticion = valor;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        // ==========================
                        // RECORDATORIO
                        // ==========================

                        DropdownButtonFormField<String>(
                          value: recordatorio,
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            color: textoOscuro,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Recordatorio',
                            labelStyle: TextStyle(
                              color: textoOscuro,
                            ),
                          ),
                          items: [
                            'Sin recordatorio',
                            '10 minutos antes',
                            '20 minutos antes',
                            '30 minutos antes',
                            '1 hora antes',
                            '1 día antes',
                          ].map((opcion) {
                            return DropdownMenuItem<String>(
                              value: opcion,
                              child: Text(
                                opcion,
                                style: const TextStyle(
                                  color: textoOscuro,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            if (valor != null) {
                              actualizarDialogo(() {
                                recordatorio = valor;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        // ==========================
                        // TIPO DE RECORDATORIO
                        // ==========================

                        DropdownButtonFormField<String>(
                          value: tipoRecordatorio,
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            color: textoOscuro,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Tipo de recordatorio',
                            labelStyle: TextStyle(
                              color: textoOscuro,
                            ),
                          ),
                          items: [
                            'Notificación',
                            'Alarma',
                          ].map((opcion) {
                            return DropdownMenuItem<String>(
                              value: opcion,
                              child: Text(
                                opcion,
                                style: const TextStyle(
                                  color: textoOscuro,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            if (valor != null) {
                              actualizarDialogo(() {
                                tipoRecordatorio = valor;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        // ==========================
                        // DESCRIPCIÓN
                        // ==========================

                        TextField(
                          controller: descripcionController,
                          maxLines: 3,
                          style: const TextStyle(
                            color: textoOscuro,
                          ),
                          cursorColor: azulBoton,
                          decoration: decoracionCampo(
                            'Descripción',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==============================
                // BOTONES DEL FORMULARIO
                // ==============================

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: azulBoton,
                    ),
                    child: const Text('Cancelar'),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azulBoton,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (tituloController.text
                          .trim()
                          .isEmpty) {
                        ScaffoldMessenger.of(this.context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Escribe un título para el evento.',
                            ),
                          ),
                        );
                        return;
                      }

                      if (fechaFin.isBefore(fechaInicio)) {
                        ScaffoldMessenger.of(this.context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'La fecha final no puede ser '
                                  'anterior a la inicial.',
                            ),
                          ),
                        );
                        return;
                      }

                      Navigator.pop(
                        dialogContext,
                        EventoCalendario(
                          titulo:
                          tituloController.text.trim(),
                          fechaInicio: fechaInicio,
                          fechaFin: fechaFin,
                          todoElDia: todoElDia,
                          repeticion: repeticion,
                          recordatorio: recordatorio,
                          tipoRecordatorio:
                          tipoRecordatorio,
                          descripcion:
                          descripcionController.text
                              .trim(),
                        ),
                      );
                    },
                    child: const Text(
                      'Guardar cambios',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    tituloController.dispose();
    descripcionController.dispose();

    if (actualizado == null || !mounted) return;

    widget.controller.editarEvento(
      eventoOriginal: evento,
      eventoActualizado: actualizado,
    );

    widget.controller.completarActividad(
      'editar_evento',
    );

    setState(() {
      fechaSeleccionada = actualizado.fechaInicio;

      mesActual = DateTime(
        actualizado.fechaInicio.year,
        actualizado.fechaInicio.month,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '¡Evento actualizado correctamente!',
        ),
        backgroundColor: verde,
      ),
    );
  }

  // ==========================================
  // ELIMINAR EVENTO
  // ==========================================

  Future<void> eliminarEvento(EventoCalendario evento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Theme(
          data: temaClaro,
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Eliminar evento',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textoOscuro,
              ),
            ),
            content: Text(
              '¿Deseas eliminar el evento "${evento.titulo}"?',
              style: const TextStyle(
                color: textoOscuro,
                fontSize: 15,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                style: TextButton.styleFrom(
                  foregroundColor: azulBoton,
                ),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirmar != true || !mounted) return;

    widget.controller.eliminarEvento(evento);

    widget.controller.completarActividad(
      'eliminar_evento',
    );

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Evento eliminado correctamente.',
        ),
        backgroundColor: verde,
      ),
    );
  }

  // ==========================================
  // CALENDARIO INTERACTIVO
  // ==========================================

  Widget construirCalendario() {
    final primerDia = DateTime(
      mesActual.year,
      mesActual.month,
      1,
    );

    final diasEnMes = DateTime(
      mesActual.year,
      mesActual.month + 1,
      0,
    ).day;

    final espaciosIniciales = primerDia.weekday - 1;
    final totalCeldas = espaciosIniciales + diasEnMes;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // ======================================
          // NAVEGACIÓN ENTRE MESES
          // ======================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => cambiarMes(-1),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 34,
                  color: textoOscuro,
                ),
              ),

              Text(
                '${nombreMes(mesActual.month)} ${mesActual.year}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: textoOscuro,
                ),
              ),

              IconButton(
                onPressed: () => cambiarMes(1),
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  size: 34,
                  color: textoOscuro,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ======================================
          // DÍAS DE LA SEMANA
          // ======================================

          const Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'L',
                    style: TextStyle(color: textoOscuro),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'M',
                    style: TextStyle(color: textoOscuro),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'M',
                    style: TextStyle(color: textoOscuro),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'J',
                    style: TextStyle(color: textoOscuro),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'V',
                    style: TextStyle(color: textoOscuro),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'S',
                    style: TextStyle(color: textoOscuro),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'D',
                    style: TextStyle(color: textoOscuro),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ======================================
          // CUADRÍCULA DEL CALENDARIO
          // ======================================

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCeldas,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final numeroDia =
                  index - espaciosIniciales + 1;

              if (numeroDia <= 0 ||
                  numeroDia > diasEnMes) {
                return const SizedBox();
              }

              final fecha = DateTime(
                mesActual.year,
                mesActual.month,
                numeroDia,
              );

              final seleccionado =
              widget.controller.mismaFecha(
                fecha,
                fechaSeleccionada,
              );

              final tieneEventos = widget.controller
                  .obtenerEventosPorFecha(fecha)
                  .isNotEmpty;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => seleccionarFecha(fecha),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: seleccionado
                        ? azul
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        '$numeroDia',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: seleccionado
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: seleccionado
                              ? Colors.white
                              : textoOscuro,
                        ),
                      ),

                      if (tieneEventos)
                        Container(
                          margin: const EdgeInsets.only(
                            top: 3,
                          ),
                          height: 5,
                          width: 5,
                          decoration: BoxDecoration(
                            color: seleccionado
                                ? Colors.white
                                : verde,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          // ======================================
          // BOTÓN HOY
          // ======================================

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: volverHoy,
              icon: const Icon(
                Icons.today_rounded,
              ),
              label: const Text('Hoy'),
              style: OutlinedButton.styleFrom(
                foregroundColor: azulBoton,
                side: const BorderSide(
                  color: azulBoton,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // LISTA DE EVENTOS
  // ==========================================

  Widget construirEventos() {
    final eventos = widget.controller
        .obtenerEventosPorFecha(fechaSeleccionada);

    final estado = widget.controller.estado;

    final debeEditar = !estado.editarEvento;

    final debeEliminar =
        estado.editarEvento && !estado.eliminarEvento;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eventos del ${formatoFecha(fechaSeleccionada)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textoOscuro,
          ),
        ),

        const SizedBox(height: 12),

        if (eventos.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.event_busy_rounded,
                  size: 42,
                  color: azul,
                ),

                SizedBox(height: 10),

                Text(
                  'No hay eventos para esta fecha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textoOscuro,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Selecciona una fecha que tenga eventos '
                      'marcados con un punto verde.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          )
        else
          ...eventos.map(
                (evento) => Card(
              color: Colors.white,
              margin: const EdgeInsets.only(
                bottom: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textoOscuro,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      evento.todoElDia
                          ? 'Todo el día'
                          : formatoHora(evento.fechaInicio),
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        // ==========================
                        // BOTÓN EDITAR
                        // ==========================

                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: debeEditar
                                ? () => editarEvento(evento)
                                : null,
                            icon: const Icon(
                              Icons.edit_rounded,
                            ),
                            label: const Text('Editar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: azulBoton,
                              disabledForegroundColor:
                              Colors.grey,
                              side: const BorderSide(
                                color: azulBoton,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // ==========================
                        // BOTÓN ELIMINAR
                        // ==========================

                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: debeEliminar
                                ? () => eliminarEvento(evento)
                                : null,
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                            ),
                            label: const Text('Eliminar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              disabledForegroundColor:
                              Colors.grey,
                              side: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ==========================================
  // PANTALLA PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final estado = widget.controller.estado;

    final completada =
        estado.editarEvento && estado.eliminarEvento;

    final paso = !estado.editarEvento ? 1 : 2;

    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Editar y eliminar eventos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ======================================
          // ENCABEZADO
          // ======================================

          const Text(
            'Aprende a organizar tus eventos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textoOscuro,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Practica modificando y eliminando '
                'eventos que hayas guardado en el calendario.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // ======================================
          // GUÍA PASO A PASO
          // ======================================

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: azul.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  completada
                      ? '¡Práctica completada!'
                      : 'PASO $paso DE 2',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textoOscuro,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  completada
                      ? '¡Felicitaciones! Has aprendido '
                      'a editar y eliminar eventos.'
                      : paso == 1
                      ? 'Busca un evento guardado, '
                      'pulsa "Editar", modifica '
                      'sus datos y guarda los cambios.'
                      : 'Ahora selecciona un evento, '
                      'pulsa "Eliminar" y confirma '
                      'la eliminación.',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: textoOscuro,
                  ),
                ),

                const SizedBox(height: 14),

                LinearProgressIndicator(
                  value: estado.progresoEditarEliminar / 2,
                  minHeight: 9,
                  backgroundColor: Colors.white,
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(
                    verde,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ======================================
          // CALENDARIO
          // ======================================

          construirCalendario(),

          const SizedBox(height: 24),

          // ======================================
          // EVENTOS GUARDADOS
          // ======================================

          construirEventos(),

          const SizedBox(height: 25),

          // ======================================
          // FINALIZAR PRÁCTICA
          // ======================================

          if (completada)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.check_circle_rounded,
                ),
                label: const Text(
                  'Finalizar práctica',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
