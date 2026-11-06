
import 'package:flutter/material.dart';

import '../../controllers/calendario_controller.dart';
import '../../controllers/progreso_controller.dart';
import '../../models/calendario/evento_model.dart';

class PantallaCalendarioSim extends StatefulWidget {
  final ProgresoController progresoController;

  const PantallaCalendarioSim({
    super.key,
    required this.progresoController,
  });

  @override
  State<PantallaCalendarioSim> createState() =>
      _PantallaCalendarioSimState();
}

class _PantallaCalendarioSimState extends State<PantallaCalendarioSim> {
  final Color azul = const Color(0xFF92AFBC);
  final Color fondo = const Color(0xFFF7F9FA);
  final Color verde = const Color(0xFF299764);

  late final CalendarioController calendarioController;

  DateTime mesActual = DateTime.now();
  DateTime fechaSeleccionada = DateTime.now();

  int leccionActual = 0;
  int pasoActual = 0;

  final Set<String> accionesCompletadas = {};

  EventoCalendario? eventoCreado;
  EventoCalendario? eventoEditado;

  final List<String> meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril',
    'Mayo', 'Junio', 'Julio', 'Agosto',
    'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  final List<String> diasSemana = [
    'L', 'M', 'X', 'J', 'V', 'S', 'D'
  ];

  @override
  void initState() {
    super.initState();
    calendarioController = CalendarioController();
    calendarioController.addListener(actualizarPantalla);
  }

  @override
  void dispose() {
    calendarioController.removeListener(actualizarPantalla);
    calendarioController.dispose();
    super.dispose();
  }

  void actualizarPantalla() {
    if (mounted) setState(() {});
  }

  String formatoFecha(DateTime fecha) {
    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  bool mismaFecha(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  List<EventoCalendario> eventosDelDia(DateTime fecha) {
    return calendarioController.eventosDelDia(fecha);
  }

  List<EventoCalendario> obtenerTodosLosEventos() {
    return calendarioController.obtenerEventos();
  }

  void completarProgreso(String actividad) {
    widget.progresoController.completarActividadCalendario(actividad);
  }

  // ------------------------------------------------------------
  // LECCIONES Y PASOS
  // ------------------------------------------------------------

  final List<List<Map<String, String>>> lecciones = [
    [
      {
        'titulo': 'Avanza al siguiente mes',
        'mensaje':
        'Observa las flechas que aparecen junto al nombre del mes. Pulsa la flecha derecha para avanzar al siguiente mes.',
        'accion': 'Pulsa la flecha derecha del calendario.',
      },
      {
        'titulo': 'Regresa al mes anterior',
        'mensaje':
        'Ahora vamos a regresar. Busca la flecha izquierda y presiónala para volver al mes anterior.',
        'accion': 'Pulsa la flecha izquierda del calendario.',
      },
      {
        'titulo': 'Selecciona un día',
        'mensaje':
        'El calendario permite seleccionar cualquier día. Toca uno de los números que aparecen en el mes.',
        'accion': 'Selecciona un día del calendario.',
      },
      {
        'titulo': 'Regresa a la fecha de hoy',
        'mensaje':
        'Cuando quieras volver a la fecha actual, puedes utilizar el botón Ir a hoy.',
        'accion': 'Pulsa el botón Ir a hoy.',
      },
    ],
    [
      {
        'titulo': 'Crea tu primer evento',
        'mensaje':
        'Ahora aprenderás a guardar una actividad en el calendario. Puedes registrar una cita, una reunión o cualquier otro compromiso.',
        'accion': 'Pulsa el botón + y guarda un evento.',
      },
    ],
    [
      {
        'titulo': 'Consulta tus eventos',
        'mensaje':
        'Los eventos aparecen cuando seleccionas el día en el que están programados. Busca la fecha de tu evento y tócala.',
        'accion': 'Selecciona el día donde guardaste tu evento.',
      },
    ],
    [
      {
        'titulo': 'Edita un evento',
        'mensaje':
        'Si necesitas cambiar la información de un evento, puedes hacerlo desde el menú de tres puntos que aparece en su tarjeta.',
        'accion': 'Abre el menú del evento, selecciona Editar y guarda los cambios.',
      },
      {
        'titulo': 'Elimina un evento',
        'mensaje':
        'También puedes eliminar un evento que ya no necesitas. Hazlo desde el menú de tres puntos.',
        'accion': 'Abre el menú del evento y selecciona Eliminar.',
      },
    ],
  ];

  final List<String> nombresLecciones = [
    'Conocer el calendario',
    'Crear un evento',
    'Consultar eventos',
    'Editar y eliminar eventos',
  ];

  String obtenerIdProgreso() {
    switch (leccionActual) {
      case 0:
        return 'navegar_calendario';
      case 1:
        return 'crear_evento';
      case 2:
        return 'consultar_evento';
      default:
        return 'editar_eliminar_evento';
    }
  }

  String obtenerClavePaso() {
    if (leccionActual == 0) {
      return [
        'avanzar_mes',
        'retroceder_mes',
        'seleccionar_dia',
        'ir_hoy',
      ][pasoActual];
    }

    if (leccionActual == 1) return 'crear_evento';
    if (leccionActual == 2) return 'consultar_evento';

    return pasoActual == 0 ? 'editar_evento' : 'eliminar_evento';
  }

  bool pasoCompletado() {
    return accionesCompletadas.contains(obtenerClavePaso());
  }

  void registrarAccion(String accion) {
    if (accionesCompletadas.contains(accion)) return;

    setState(() {
      accionesCompletadas.add(accion);
    });
  }

  void siguientePaso() {
    if (!pasoCompletado()) return;

    if (pasoActual < lecciones[leccionActual].length - 1) {
      setState(() {
        pasoActual++;
      });
      return;
    }

    completarProgreso(obtenerIdProgreso());

    if (leccionActual < lecciones.length - 1) {
      setState(() {
        leccionActual++;
        pasoActual = 0;
      });
    } else {
      mostrarFinalizacion();
    }
  }

  void pasoAnterior() {
    if (pasoActual > 0) {
      setState(() {
        pasoActual--;
      });
    } else if (leccionActual > 0) {
      setState(() {
        leccionActual--;
        pasoActual = lecciones[leccionActual].length - 1;
      });
    }
  }

  void mostrarFinalizacion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '¡Felicitaciones!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration,
              color: Color(0xFF299764),
              size: 65,
            ),
            SizedBox(height: 15),
            Text(
              'Has terminado las prácticas del calendario. ¡Muy buen trabajo!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: verde,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // NAVEGACIÓN DEL CALENDARIO
  // ------------------------------------------------------------

  void cambiarMes(int cantidad) {
    setState(() {
      mesActual = DateTime(
        mesActual.year,
        mesActual.month + cantidad,
        1,
      );
    });

    if (leccionActual == 0) {
      if (cantidad > 0 && pasoActual == 0) {
        registrarAccion('avanzar_mes');
      } else if (cantidad < 0 && pasoActual == 1) {
        registrarAccion('retroceder_mes');
      }
    }
  }

  void seleccionarDia(DateTime fecha) {
    setState(() {
      fechaSeleccionada = fecha;
    });

    if (leccionActual == 0 && pasoActual == 2) {
      registrarAccion('seleccionar_dia');
    }

    if (leccionActual == 2 && eventosDelDia(fecha).isNotEmpty) {
      registrarAccion('consultar_evento');
    }
  }

  void irHoy() {
    setState(() {
      fechaSeleccionada = DateTime.now();
      mesActual = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      );
    });

    if (leccionActual == 0 && pasoActual == 3) {
      registrarAccion('ir_hoy');
    }
  }

  // ------------------------------------------------------------
  // SELECTORES DE FECHA Y HORA
  // ------------------------------------------------------------

  Future<void> seleccionarFecha(
      BuildContext context,
      DateTime fecha,
      Function(DateTime) actualizar,
      ) async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Seleccionar fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (elegida != null) {
      actualizar(elegida);
    }
  }

  Future<void> seleccionarHora(
      BuildContext context,
      TimeOfDay hora,
      Function(TimeOfDay) actualizar,
      ) async {
    final elegida = await showTimePicker(
      context: context,
      initialTime: hora,
      helpText: 'Seleccionar hora',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (elegida != null) {
      actualizar(elegida);
    }
  }

  // ------------------------------------------------------------
  // FORMULARIO PARA CREAR Y EDITAR EVENTOS
  // ------------------------------------------------------------

  Future<void> mostrarFormulario({EventoCalendario? evento}) async {
    final tituloController = TextEditingController(
      text: evento?.titulo ?? '',
    );

    final descripcionController = TextEditingController(
      text: evento?.descripcion ?? '',
    );

    bool todoElDia = evento?.todoElDia ?? false;

    DateTime fechaInicio = evento?.fechaInicio ?? fechaSeleccionada;

    DateTime fechaFin = evento?.fechaFin ??
        DateTime(
          fechaSeleccionada.year,
          fechaSeleccionada.month,
          fechaSeleccionada.day,
          10,
        );

    TimeOfDay horaInicio = TimeOfDay.fromDateTime(fechaInicio);
    TimeOfDay horaFin = TimeOfDay.fromDateTime(fechaFin);

    String repeticion = evento?.repeticion ?? 'Nunca';
    String recordatorio = evento?.recordatorio ?? '10 minutos antes';

    String tipoRecordatorio =
        evento?.tipoRecordatorio ?? 'Alarma';

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            Widget campoFecha(
                String titulo,
                DateTime fecha,
                VoidCallback accion,
                ) {
              return InkWell(
                onTap: accion,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: fondo,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: azul),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month, color: azul),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titulo,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatoFecha(fecha),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.edit, size: 20),
                    ],
                  ),
                ),
              );
            }

            Widget campoHora(
                String titulo,
                TimeOfDay hora,
                VoidCallback accion,
                ) {
              return InkWell(
                onTap: accion,
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: fondo,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: azul),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: azul),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$titulo: ${hora.format(context)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.edit, size: 18),
                    ],
                  ),
                ),
              );
            }

            return AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.event, color: azul, size: 27),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      evento == null ? 'Añadir evento' : 'Editar evento',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Título del evento',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: tituloController,
                        decoration: InputDecoration(
                          hintText: 'Ej. Cita médica',
                          filled: true,
                          fillColor: fondo,
                          prefixIcon: const Icon(Icons.edit_note),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Todo el día',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: todoElDia,
                        activeColor: verde,
                        onChanged: (valor) {
                          actualizarDialogo(() {
                            todoElDia = valor;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Fecha de inicio',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      campoFecha('Comienza', fechaInicio, () async {
                        await seleccionarFecha(
                          context,
                          fechaInicio,
                              (fecha) {
                            actualizarDialogo(() {
                              fechaInicio = DateTime(
                                fecha.year,
                                fecha.month,
                                fecha.day,
                                horaInicio.hour,
                                horaInicio.minute,
                              );

                              if (fechaFin.isBefore(fechaInicio)) {
                                fechaFin = fechaInicio;
                                horaFin = horaInicio;
                              }
                            });
                          },
                        );
                      }),
                      if (!todoElDia) ...[
                        const SizedBox(height: 10),
                        campoHora('Hora de inicio', horaInicio, () async {
                          await seleccionarHora(
                            context,
                            horaInicio,
                                (hora) {
                              actualizarDialogo(() {
                                horaInicio = hora;
                                fechaInicio = DateTime(
                                  fechaInicio.year,
                                  fechaInicio.month,
                                  fechaInicio.day,
                                  hora.hour,
                                  hora.minute,
                                );

                                if (fechaFin.isBefore(fechaInicio)) {
                                  fechaFin = fechaInicio;
                                  horaFin = hora;
                                }
                              });
                            },
                          );
                        }),
                      ],
                      const SizedBox(height: 18),
                      const Text(
                        'Fecha de finalización',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      campoFecha('Termina', fechaFin, () async {
                        await seleccionarFecha(
                          context,
                          fechaFin,
                              (fecha) {
                            actualizarDialogo(() {
                              fechaFin = DateTime(
                                fecha.year,
                                fecha.month,
                                fecha.day,
                                horaFin.hour,
                                horaFin.minute,
                              );
                            });
                          },
                        );
                      }),
                      if (!todoElDia) ...[
                        const SizedBox(height: 10),
                        campoHora('Hora de finalización', horaFin, () async {
                          await seleccionarHora(
                            context,
                            horaFin,
                                (hora) {
                              actualizarDialogo(() {
                                horaFin = hora;
                                fechaFin = DateTime(
                                  fechaFin.year,
                                  fechaFin.month,
                                  fechaFin.day,
                                  hora.hour,
                                  hora.minute,
                                );
                              });
                            },
                          );
                        }),
                      ],
                      const SizedBox(height: 20),
                      const Text(
                        'Repetir',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: repeticion,
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: fondo,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          'Nunca',
                          'Todos los días',
                          'Cada semana',
                          'Cada mes',
                          'Cada año',
                        ].map((opcion) {
                          return DropdownMenuItem(
                            value: opcion,
                            child: Text(opcion),
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
                      const SizedBox(height: 20),
                      const Text(
                        'Recordatorio',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: recordatorio,
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: fondo,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          'Sin recordatorio',
                          'A la hora del evento',
                          '5 minutos antes',
                          '10 minutos antes',
                          '20 minutos antes',
                          '30 minutos antes',
                          '1 hora antes',
                          '1 día antes',
                        ].map((opcion) {
                          return DropdownMenuItem(
                              value: opcion,
                              child: Text(opcion),
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
                      if (recordatorio != 'Sin recordatorio') ...[
                        const SizedBox(height: 15),
                        const Text(
                          'Tipo de recordatorio',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: tipoRecordatorio,
                          isExpanded: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: fondo,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: ['Alarma', 'Cuenta atrás'].map((opcion) {
                            return DropdownMenuItem(
                              value: opcion,
                              child: Text(opcion),
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
                      ],
                      const SizedBox(height: 20),
                      const Text(
                        'Descripción',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descripcionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Añade una pequeña descripción...',
                          filled: true,
                          fillColor: fondo,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Este recordatorio es una práctica simulada dentro de la aplicación.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    if (tituloController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Escribe el título del evento'),
                        ),
                      );
                      return;
                    }

                    if (fechaFin.isBefore(fechaInicio)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'La fecha de finalización no puede ser anterior al inicio',
                          ),
                        ),
                      );
                      return;
                    }

                    final nuevoEvento = EventoCalendario(
                      titulo: tituloController.text.trim(),
                      fechaInicio: fechaInicio,
                      fechaFin: fechaFin,
                      todoElDia: todoElDia,
                      repeticion: repeticion,
                      recordatorio: recordatorio,
                      tipoRecordatorio: tipoRecordatorio,
                      descripcion: descripcionController.text.trim(),
                    );

                    if (evento == null) {
                      calendarioController.agregarEvento(nuevoEvento);
                      eventoCreado = nuevoEvento;

                      if (leccionActual == 1) {
                        registrarAccion('crear_evento');
                      }
                    } else {
                      calendarioController.editarEvento(
                        evento,
                        nuevoEvento,
                      );

                      eventoEditado = nuevoEvento;

                      if (leccionActual == 3 && pasoActual == 0) {
                        registrarAccion('editar_evento');
                      }
                    }

                    setState(() {
                      fechaSeleccionada = fechaInicio;
                      mesActual = DateTime(
                        fechaInicio.year,
                        fechaInicio.month,
                        1,
                      );
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Listo',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    tituloController.dispose();
    descripcionController.dispose();
  }

  // ------------------------------------------------------------
  // ELIMINAR EVENTOS
  // ------------------------------------------------------------

  void eliminarEvento(EventoCalendario evento) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar evento'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este evento?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              calendarioController.eliminarEvento(evento);

              if (leccionActual == 3 && pasoActual == 1) {
                registrarAccion('eliminar_evento');
              }

              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CALENDARIO VISUAL
  // ------------------------------------------------------------

  Widget construirCalendario() {
    final primerDia = DateTime(
      mesActual.year,
      mesActual.month,
      1,
    );

    final diasMes = DateTime(
      mesActual.year,
      mesActual.month + 1,
      0,
    ).day;

    final espaciosIniciales = primerDia.weekday - 1;

    final totalCasillas =
        ((espaciosIniciales + diasMes) / 7).ceil() * 7;

    return Column(
      children: [
        Row(
          children: diasSemana.map((dia) {
            return Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    dia,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCasillas,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, indice) {
            final numeroDia = indice - espaciosIniciales + 1;

            if (numeroDia < 1 || numeroDia > diasMes) {
              return const SizedBox();
            }

            final fecha = DateTime(
              mesActual.year,
              mesActual.month,
              numeroDia,
            );

            final seleccionado = mismaFecha(fecha, fechaSeleccionada);
            final hoy = mismaFecha(fecha, DateTime.now());
            final tieneEventos = eventosDelDia(fecha).isNotEmpty;

            return InkWell(
              onTap: () => seleccionarDia(fecha),
              borderRadius: BorderRadius.circular(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 37,
                    height: 37,
                    decoration: BoxDecoration(
                      color: seleccionado ? azul : Colors.transparent,
                      shape: BoxShape.circle,
                      border: hoy && !seleccionado
                          ? Border.all(color: verde, width: 1.8)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$numeroDia',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: seleccionado || hoy
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: seleccionado ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: tieneEventos ? verde : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // TARJETAS DE EVENTOS
  // ------------------------------------------------------------

  Widget construirEvento(EventoCalendario evento) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 65,
              decoration: BoxDecoration(
                color: verde,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.titulo,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    evento.todoElDia
                        ? 'Todo el día'
                        : '${TimeOfDay.fromDateTime(evento.fechaInicio).format(context)} - ${TimeOfDay.fromDateTime(evento.fechaFin).format(context)}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  if (evento.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      evento.descripcion,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  if (evento.repeticion != 'Nunca')
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Se repite: ${evento.repeticion}',
                        style: TextStyle(
                          color: azul,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (evento.recordatorio != 'Sin recordatorio')
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Recordatorio: ${evento.recordatorio}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (valor) {
                if (valor == 'editar') {
                  mostrarFormulario(evento: evento);
                } else if (valor == 'eliminar') {
                  eliminarEvento(evento);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'editar',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'eliminar',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Eliminar'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PANEL DE INSTRUCCIONES
  // ------------------------------------------------------------

  Widget construirPanelInstrucciones() {
    final paso = lecciones[leccionActual][pasoActual];
    final completado = pasoCompletado();

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: azul.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: verde, size: 27),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Lección ${leccionActual + 1} de ${lecciones.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '${pasoActual + 1}/${lecciones[leccionActual].length}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (pasoActual + 1) /
                    lecciones[leccionActual].length,
                minHeight: 7,
                backgroundColor: fondo,
                valueColor: AlwaysStoppedAnimation<Color>(verde),
              ),
            ),
            const SizedBox(height: 17),
            Text(
              nombresLecciones[leccionActual],
              style: TextStyle(
                fontSize: 14,
                color: verde,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              paso['titulo']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              paso['mensaje']!,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: fondo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.touch_app, color: azul, size: 25),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      paso['accion']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  completado ? Icons.check_circle : Icons.pending_actions,
                  color: completado ? verde : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    completado
                        ? '¡Muy bien! Has completado este paso.'
                        : 'Realiza la acción indicada para continuar.',
                    style: TextStyle(
                      color: completado ? verde : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: leccionActual == 0 && pasoActual == 0
                        ? null
                        : pasoAnterior,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Anterior'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: azul,
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: completado ? siguientePaso : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(
                      leccionActual == 3 &&
                          pasoActual == 1
                          ? 'Finalizar'
                          : 'Siguiente',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verde,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PANTALLA PRINCIPAL
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final listaEventos = eventosDelDia(fechaSeleccionada);

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Regresar',
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Práctica de calendario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              construirPanelInstrucciones(),
              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${meses[mesActual.month - 1]} ${mesActual.year}',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Mes anterior',
                            onPressed: () => cambiarMes(-1),
                            icon: const Icon(
                              Icons.chevron_left,
                              size: 30,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Mes siguiente',
                            onPressed: () => cambiarMes(1),
                            icon: const Icon(
                              Icons.chevron_right,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      construirCalendario(),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: irHoy,
                          icon: const Icon(Icons.today, size: 18),
                          label: const Text('Ir a hoy'),
                          style: TextButton.styleFrom(
                            foregroundColor: verde,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      formatoFecha(fechaSeleccionada),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (leccionActual == 1)
                    IconButton(
                      tooltip: 'Añadir evento',
                      onPressed: () => mostrarFormulario(),
                      icon: Icon(
                        Icons.add_circle,
                        color: verde,
                        size: 34,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 14),

              if (listaEventos.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_available,
                        color: azul,
                        size: 45,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'No hay eventos para este día',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (leccionActual == 1) ...[
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => mostrarFormulario(),
                          icon: const Icon(Icons.add),
                          label: const Text('Añadir evento'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: azul,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              else
                ...listaEventos.map(construirEvento),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
