// lib/views/calendario/pantalla_calendario_sim.dart

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

  late CalendarioController calendarioController;

  DateTime mesActual = DateTime.now();
  DateTime fechaSeleccionada = DateTime.now();

  int leccionActual = 0;
  int pasoActual = 0;

  final Set<String> accionesCompletadas = {};

  final List<Map<String, dynamic>> lecciones = [
    {
      'titulo': 'Conocer el calendario',
      'descripcion': 'Aprende a moverte por los meses y seleccionar fechas.',
      'id': 'navegar_calendario',
      'pasos': [
        {
          'clave': 'avanzar_mes',
          'titulo': 'Avanzar al siguiente mes',
          'instruccion':
          'Observa las flechas que aparecen junto al nombre del mes. Pulsa la flecha hacia la derecha para avanzar al siguiente mes.',
          'exito': '¡Muy bien! Has avanzado al siguiente mes.',
        },
        {
          'clave': 'retroceder_mes',
          'titulo': 'Regresar al mes anterior',
          'instruccion':
          'Ahora pulsa la flecha hacia la izquierda para regresar al mes anterior.',
          'exito': '¡Excelente! Has regresado al mes anterior.',
        },
        {
          'clave': 'seleccionar_dia',
          'titulo': 'Seleccionar un día',
          'instruccion':
          'Pulsa cualquier número del calendario para seleccionar una fecha. El día seleccionado quedará resaltado.',
          'exito': '¡Perfecto! Ya sabes seleccionar una fecha.',
        },
        {
          'clave': 'ir_hoy',
          'titulo': 'Volver al día de hoy',
          'instruccion':
          'Pulsa el botón Hoy para regresar rápidamente a la fecha actual.',
          'exito': '¡Muy bien! Ya sabes volver al día de hoy.',
        },
      ],
    },
    {
      'titulo': 'Crear un evento',
      'descripcion': 'Aprende a guardar una actividad en el calendario.',
      'id': 'crear_evento',
      'pasos': [
        {
          'clave': 'crear_evento',
          'titulo': 'Crear un evento',
          'instruccion':
          'Pulsa el botón de agregar. Escribe un título para tu evento, selecciona la fecha y la hora, y guarda la actividad.',
          'exito':
          '¡Evento creado! Tu actividad ya aparece en el calendario.',
        },
      ],
    },
    {
      'titulo': 'Consultar eventos',
      'descripcion': 'Aprende a revisar las actividades guardadas.',
      'id': 'consultar_evento',
      'pasos': [
        {
          'clave': 'consultar_evento',
          'titulo': 'Consultar un evento',
          'instruccion':
          'Selecciona en el calendario el día en el que guardaste el evento. Después revisa la información que aparece debajo del calendario.',
          'exito':
          '¡Muy bien! Has consultado correctamente los eventos de una fecha.',
        },
      ],
    },
    {
      'titulo': 'Editar y eliminar eventos',
      'descripcion': 'Aprende a modificar o borrar una actividad.',
      'id': 'editar_eliminar_evento',
      'pasos': [
        {
          'clave': 'editar_evento',
          'titulo': 'Editar un evento',
          'instruccion':
          'Busca el evento que creaste. Pulsa los tres puntos que aparecen a su lado, selecciona Editar, modifica algún dato y guarda los cambios.',
          'exito': '¡Cambios guardados! Has editado correctamente tu evento.',
        },
        {
          'clave': 'eliminar_evento',
          'titulo': 'Eliminar un evento',
          'instruccion':
          'Pulsa nuevamente los tres puntos del evento, selecciona Eliminar y confirma que deseas borrarlo.',
          'exito': '¡Listo! Has eliminado correctamente el evento.',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();

    calendarioController = CalendarioController();
    calendarioController.addListener(_actualizarPantalla);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) mostrarInstruccion();
    });
  }

  @override
  void dispose() {
    calendarioController.removeListener(_actualizarPantalla);
    calendarioController.dispose();
    super.dispose();
  }

  void _actualizarPantalla() {
    if (mounted) setState(() {});
  }

  Map<String, dynamic> get pasoActualData {
    return lecciones[leccionActual]['pasos'][pasoActual];
  }

  String obtenerIdProgreso() {
    return lecciones[leccionActual]['id'] as String;
  }

  void mostrarInstruccion() {
    if (!mounted) return;

    final paso = pasoActualData;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Icon(
            Icons.calendar_month_rounded,
            color: azul,
            size: 42,
          ),
          title: Text(
            paso['titulo'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            paso['instruccion'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Entendido',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void registrarAccion(String accion) {
    if (!mounted) return;

    final claveEsperada = pasoActualData['clave'] as String;

    if (accion != claveEsperada ||
        accionesCompletadas.contains(accion)) {
      return;
    }

    setState(() {
      accionesCompletadas.add(accion);
    });

    mostrarConfirmacionAccion();
  }

  void mostrarConfirmacionAccion() {
    final paso = pasoActualData;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Icon(
            Icons.check_circle_rounded,
            color: verde,
            size: 48,
          ),
          title: const Text(
            '¡Muy bien!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            paso['exito'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                avanzarDespuesDeAccion();
              },
              child: const Text(
                'Continuar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void avanzarDespuesDeAccion() {
    if (!mounted) return;

    final cantidadPasos =
        (lecciones[leccionActual]['pasos'] as List).length;

    if (pasoActual < cantidadPasos - 1) {
      setState(() {
        pasoActual++;
      });
      mostrarInstruccion();
      return;
    }

    widget.progresoController.completarActividadCalendario(
      obtenerIdProgreso(),
    );

    if (leccionActual < lecciones.length - 1) {
      setState(() {
        leccionActual++;
        pasoActual = 0;
      });
      mostrarInstruccion();
    } else {
      mostrarFinalizacion();
    }
  }

  void mostrarFinalizacion() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Icon(
            Icons.emoji_events_rounded,
            color: verde,
            size: 52,
          ),
          title: const Text(
            '¡Felicitaciones!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Has completado todas las prácticas del calendario. Ahora sabes consultar fechas, crear eventos y administrar tus actividades.',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.5),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
    );
  }

  void cambiarMes(int cantidad) {
    setState(() {
      mesActual = DateTime(
        mesActual.year,
        mesActual.month + cantidad,
        1,
      );
    });

    if (leccionActual == 0 && cantidad > 0) {
      registrarAccion('avanzar_mes');
    } else if (leccionActual == 0 && cantidad < 0) {
      registrarAccion('retroceder_mes');
    }
  }

  void seleccionarFecha(DateTime fecha) {
    setState(() {
      fechaSeleccionada = fecha;
      mesActual = DateTime(fecha.year, fecha.month, 1);
    });

    if (leccionActual == 0 && pasoActual == 2) {
      registrarAccion('seleccionar_dia');
    } else if (leccionActual == 2 &&
        calendarioController.eventosDelDia(fecha).isNotEmpty) {
      registrarAccion('consultar_evento');
    }
  }

  void irHoy() {
    final hoy = DateTime.now();

    setState(() {
      fechaSeleccionada = hoy;
      mesActual = DateTime(hoy.year, hoy.month, 1);
    });

    if (leccionActual == 0 && pasoActual == 3) {
      registrarAccion('ir_hoy');
    }
  }

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
    return '${fecha.day} de ${nombreMes(fecha.month)} de ${fecha.year}';
  }

  Future<DateTime?> seleccionarDia(
      DateTime fechaInicial,
      ) async {
    return showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'CO'),
    );
  }

  Future<TimeOfDay?> seleccionarHora(
      TimeOfDay horaInicial,
      ) async {
    return showTimePicker(
      context: context,
      initialTime: horaInicial,
    );
  }

  Future<EventoCalendario?> mostrarFormularioEvento([
    EventoCalendario? evento,
  ]) async {
    final esEdicion = evento != null;

    final tituloController = TextEditingController(
      text: evento?.titulo ?? '',
    );
    final descripcionController = TextEditingController(
      text: evento?.descripcion ?? '',
    );

    DateTime fechaInicio =
        evento?.fechaInicio ?? fechaSeleccionada;
    DateTime fechaFin =
        evento?.fechaFin ?? fechaSeleccionada;

    TimeOfDay horaInicio = evento != null
        ? TimeOfDay.fromDateTime(evento.fechaInicio)
        : const TimeOfDay(hour: 9, minute: 0);

    TimeOfDay horaFin = evento != null
        ? TimeOfDay.fromDateTime(evento.fechaFin)
        : const TimeOfDay(hour: 10, minute: 0);

    bool todoElDia = evento?.todoElDia ?? false;
    String repeticion = evento?.repeticion ?? 'Nunca';
    String recordatorio =
        evento?.recordatorio ?? 'Sin recordatorio';
    String tipoRecordatorio =
        evento?.tipoRecordatorio ?? 'Alarma';

    final resultado = await showDialog<EventoCalendario>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contextDialog, actualizarDialogo) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                esEdicion ? 'Editar evento' : 'Nuevo evento',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: tituloController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del evento',
                          prefixIcon: const Icon(Icons.event),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: descripcionController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Descripción (opcional)',
                          prefixIcon: const Icon(Icons.notes),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Todo el día'),
                        value: todoElDia,
                        activeColor: verde,
                        onChanged: (valor) {
                          actualizarDialogo(() {
                            todoElDia = valor;
                          });
                        },
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.calendar_today, color: azul),
                        title: const Text('Fecha de inicio'),
                        subtitle: Text(formatoFecha(fechaInicio)),
                        onTap: () async {
                          final fecha = await seleccionarDia(fechaInicio);
                          if (fecha != null) {
                            actualizarDialogo(() {
                              fechaInicio = fecha;
                              if (fechaFin.isBefore(fechaInicio)) {
                                fechaFin = fechaInicio;
                              }
                            });
                          }
                        },
                      ),
                      if (!todoElDia)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.access_time, color: azul),
                          title: const Text('Hora de inicio'),
                          subtitle: Text(horaInicio.format(contextDialog)),
                          onTap: () async {
                            final hora = await seleccionarHora(horaInicio);
                            if (hora != null) {
                              actualizarDialogo(() {
                                horaInicio = hora;
                              });
                            }
                          },
                        ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.event_available, color: azul),
                        title: const Text('Fecha de finalización'),
                        subtitle: Text(formatoFecha(fechaFin)),
                        onTap: () async {
                          final fecha = await seleccionarDia(fechaFin);
                          if (fecha != null) {
                            actualizarDialogo(() {
                              fechaFin = fecha.isBefore(fechaInicio)
                                  ? fechaInicio
                                  : fecha;
                            });
                          }
                        },
                      ),
                      if (!todoElDia)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.schedule, color: azul),
                          title: const Text('Hora de finalización'),
                          subtitle: Text(horaFin.format(contextDialog)),
                          onTap: () async {
                            final hora = await seleccionarHora(horaFin);
                            if (hora != null) {
                              actualizarDialogo(() {
                                horaFin = hora;
                              });
                            }
                          },
                        ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: repeticion,
                        decoration: const InputDecoration(
                          labelText: 'Repetición',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
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
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: recordatorio,
                        decoration: const InputDecoration(
                          labelText: 'Recordatorio',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
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
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: tipoRecordatorio,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de recordatorio',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            'Alarma',
                            'Cuenta atrás',
                          ].map((opcion) {
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
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final titulo = tituloController.text.trim();

                    if (titulo.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Escribe el nombre del evento.'),
                        ),
                      );
                      return;
                    }

                    final inicio = DateTime(
                      fechaInicio.year,
                      fechaInicio.month,
                      fechaInicio.day,
                      todoElDia ? 0 : horaInicio.hour,
                      todoElDia ? 0 : horaInicio.minute,
                    );

                    final fin = DateTime(
                      fechaFin.year,
                      fechaFin.month,
                      fechaFin.day,
                      todoElDia ? 23 : horaFin.hour,
                      todoElDia ? 59 : horaFin.minute,
                    );

                    if (fin.isBefore(inicio)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'La fecha final no puede ser anterior a la inicial.',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                      EventoCalendario(
                        titulo: titulo,
                        fechaInicio: inicio,
                        fechaFin: fin,
                        todoElDia: todoElDia,
                        repeticion: repeticion,
                        recordatorio: recordatorio,
                        tipoRecordatorio: tipoRecordatorio,
                        descripcion: descripcionController.text.trim(),
                      ),
                    );
                  },
                  child: Text(esEdicion ? 'Guardar cambios' : 'Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    tituloController.dispose();
    descripcionController.dispose();

    return resultado;
  }

  Future<void> agregarEvento() async {
    final nuevoEvento = await mostrarFormularioEvento();

    if (nuevoEvento == null || !mounted) return;

    calendarioController.agregarEvento(nuevoEvento);

    setState(() {
      fechaSeleccionada = nuevoEvento.fechaInicio;
      mesActual = DateTime(
        nuevoEvento.fechaInicio.year,
        nuevoEvento.fechaInicio.month,
        1,
      );
    });

    if (leccionActual == 1 && pasoActual == 0) {
      registrarAccion('crear_evento');
    }
  }

  Future<void> editarEvento(EventoCalendario evento) async {
    final eventoEditado = await mostrarFormularioEvento(evento);

    if (eventoEditado == null || !mounted) return;

    calendarioController.editarEvento(evento, eventoEditado);

    if (leccionActual == 3 && pasoActual == 0) {
      registrarAccion('editar_evento');
    }
  }

  Future<void> eliminarEvento(EventoCalendario evento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Eliminar evento'),
          content: Text(
            '¿Estás seguro de que deseas eliminar "${evento.titulo}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    calendarioController.eliminarEvento(evento);

    if (leccionActual == 3 && pasoActual == 1) {
      registrarAccion('eliminar_evento');
    }
  }

  Widget construirEncabezadoMes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Mes anterior',
          onPressed: () => cambiarMes(-1),
          icon: const Icon(Icons.chevron_left_rounded, size: 30),
        ),
        Expanded(
          child: Text(
            '${nombreMes(mesActual.month)} ${mesActual.year}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Mes siguiente',
          onPressed: () => cambiarMes(1),
          icon: const Icon(Icons.chevron_right_rounded, size: 30),
        ),
      ],
    );
  }

  Widget construirCalendario() {
    final primerDia = DateTime(mesActual.year, mesActual.month, 1);
    final diasMes = DateTime(mesActual.year, mesActual.month + 1, 0).day;
    final desplazamiento = primerDia.weekday - 1;
    final totalCeldas = ((desplazamiento + diasMes) / 7).ceil() * 7;

    const diasSemana = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Column(
      children: [
        Row(
          children: diasSemana.map((dia) {
            return Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Text(
                    dia,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
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
          itemCount: totalCeldas,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, indice) {
            final numeroDia = indice - desplazamiento + 1;

            if (numeroDia < 1 || numeroDia > diasMes) {
              return const SizedBox.shrink();
            }

            final fecha = DateTime(
              mesActual.year,
              mesActual.month,
              numeroDia,
            );

            final seleccionado =
            calendarioController.mismaFecha(
              fecha,
              fechaSeleccionada,
            );

            final hoy = calendarioController.mismaFecha(
              fecha,
              DateTime.now(),
            );

            final tieneEventos =
                calendarioController.eventosDelDia(fecha).isNotEmpty;

            return InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => seleccionarFecha(fecha),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: seleccionado
                          ? azul
                          : hoy
                          ? azul.withOpacity(0.18)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: hoy && !seleccionado
                          ? Border.all(color: azul, width: 1.5)
                          : null,
                    ),
                    child: Text(
                      '$numeroDia',
                      style: TextStyle(
                        color: seleccionado
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: seleccionado || hoy
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: tieneEventos
                          ? verde
                          : Colors.transparent,
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

  Widget construirEvento(EventoCalendario evento) {
    final hora = evento.todoElDia
        ? 'Todo el día'
        : '${TimeOfDay.fromDateTime(evento.fechaInicio).format(context)} - '
        '${TimeOfDay.fromDateTime(evento.fechaFin).format(context)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: azul.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 55,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hora,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
                if (evento.descripcion.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    evento.descripcion,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (evento.repeticion != 'Nunca')
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Se repite: ${evento.repeticion}',
                      style: TextStyle(
                        color: azul,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (evento.recordatorio != 'Sin recordatorio')
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      'Recordatorio: ${evento.recordatorio}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Opciones del evento',
            onSelected: (opcion) {
              if (opcion == 'editar') {
                editarEvento(evento);
              } else if (opcion == 'eliminar') {
                eliminarEvento(evento);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 10),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'eliminar',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Eliminar'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget construirListaEventos() {
    final eventos =
    calendarioController.eventosDelDia(fechaSeleccionada);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eventos del ${formatoFecha(fechaSeleccionada)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        if (eventos.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.event_busy_rounded,
                  size: 35,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  'No hay eventos para este día.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        else
          ...eventos.map(construirEvento),
      ],
    );
  }

  Widget construirResumenLeccion() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: azul.withOpacity(0.13),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.school_outlined, color: azul, size: 27),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Práctica ${leccionActual + 1} de ${lecciones.length}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lecciones[leccionActual]['titulo'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Aprende a usar el calendario',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Recordar el paso',
            icon: const Icon(
              Icons.help_outline_rounded,
              size: 27,
            ),
            onPressed: mostrarInstruccion,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              construirResumenLeccion(),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    construirEncabezadoMes(),
                    const Divider(height: 15),
                    construirCalendario(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: irHoy,
                        icon: const Icon(Icons.today_rounded),
                        label: const Text('Hoy'),
                        style: TextButton.styleFrom(
                          foregroundColor: verde,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mis actividades',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (leccionActual == 1)
                    ElevatedButton.icon(
                      onPressed: agregarEvento,
                      icon: const Icon(Icons.add, size: 19),
                      label: const Text('Agregar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: verde,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 13),
              construirListaEventos(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}