
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

  late DateTime mesActual;
  late DateTime fechaSeleccionada;

  @override
  void initState() {
    super.initState();

    final hoy = DateTime.now();
    mesActual = DateTime(hoy.year, hoy.month);
    fechaSeleccionada = hoy;
  }

  String nombreMes(int mes) {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril',
      'Mayo', 'Junio', 'Julio', 'Agosto',
      'Septiembre', 'Octubre', 'Noviembre',
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

  // EDITAR EVENTO

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
        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            Future<void> elegirFecha(bool inicio) async {
              final actual = inicio ? fechaInicio : fechaFin;

              final elegida = await showDatePicker(
                context: context,
                initialDate: actual,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );

              if (elegida == null || !context.mounted) return;

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

            Future<void> elegirHora(bool inicio) async {
              final actual = inicio ? fechaInicio : fechaFin;

              final elegida = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(actual),
              );

              if (elegida == null || !context.mounted) return;

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
                  ),
                ),
                subtitle: Text(valor),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                ),
                onTap: accion,
              );
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Editar evento'),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título del evento',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Todo el día'),
                        value: todoElDia,
                        onChanged: (valor) {
                          actualizarDialogo(() {
                            todoElDia = valor;
                          });
                        },
                      ),

                      selector(
                        'Fecha de inicio',
                        formatoFecha(fechaInicio),
                            () => elegirFecha(true),
                      ),

                      if (!todoElDia)
                        selector(
                          'Hora de inicio',
                          formatoHora(fechaInicio),
                              () => elegirHora(true),
                        ),

                      selector(
                        'Fecha de finalización',
                        formatoFecha(fechaFin),
                            () => elegirFecha(false),
                      ),

                      if (!todoElDia)
                        selector(
                          'Hora de finalización',
                          formatoHora(fechaFin),
                              () => elegirHora(false),
                        ),

                      DropdownButtonFormField<String>(
                        value: repeticion,
                        decoration: const InputDecoration(
                          labelText: 'Repetir',
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

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: recordatorio,
                        decoration: const InputDecoration(
                          labelText: 'Recordatorio',
                        ),
                        items: [
                          'Sin recordatorio',
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

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: tipoRecordatorio,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de recordatorio',
                        ),
                        items: [
                          'Notificación',
                          'Alarma',
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

                      const SizedBox(height: 12),

                      TextField(
                        controller: descripcionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (tituloController.text.trim().isEmpty) {
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
                        titulo: tituloController.text.trim(),
                        fechaInicio: fechaInicio,
                        fechaFin: fechaFin,
                        todoElDia: todoElDia,
                        repeticion: repeticion,
                        recordatorio: recordatorio,
                        tipoRecordatorio: tipoRecordatorio,
                        descripcion:
                        descripcionController.text.trim(),
                      ),
                    );
                  },
                  child: const Text('Guardar cambios'),
                ),
              ],
            );
          },
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

    widget.controller.completarActividad('editar_evento');

    setState(() {
      fechaSeleccionada = actualizado.fechaInicio;
      mesActual = DateTime(
        actualizado.fechaInicio.year,
        actualizado.fechaInicio.month,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Evento actualizado correctamente!'),
        backgroundColor: verde,
      ),
    );
  }

  // ELIMINAR EVENTO

  Future<void> eliminarEvento(EventoCalendario evento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar evento'),
          content: Text(
            '¿Deseas eliminar el evento "${evento.titulo}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
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
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    widget.controller.eliminarEvento(evento);
    widget.controller.completarActividad('eliminar_evento');

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Evento eliminado correctamente.'),
        backgroundColor: verde,
      ),
    );
  }

  // CALENDARIO INTERACTIVO

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
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => cambiarMes(-1),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 34,
                ),
              ),
              Text(
                '${nombreMes(mesActual.month)} ${mesActual.year}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => cambiarMes(1),
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  size: 34,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Row(
            children: [
              Expanded(child: Center(child: Text('L'))),
              Expanded(child: Center(child: Text('M'))),
              Expanded(child: Center(child: Text('M'))),
              Expanded(child: Center(child: Text('J'))),
              Expanded(child: Center(child: Text('V'))),
              Expanded(child: Center(child: Text('S'))),
              Expanded(child: Center(child: Text('D'))),
            ],
          ),

          const SizedBox(height: 10),

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
                              : Colors.black87,
                        ),
                      ),
                      if (tieneEventos)
                        Container(
                          margin: const EdgeInsets.only(top: 3),
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

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: volverHoy,
              icon: const Icon(Icons.today_rounded),
              label: const Text('Hoy'),
            ),
          ),
        ],
      ),
    );
  }

  // LISTA DE EVENTOS

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
                ),
                SizedBox(height: 8),
                Text(
                  'Selecciona una fecha que tenga eventos '
                      'marcados con un punto verde.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          )
        else
          ...eventos.map(
                (evento) => Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
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
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: debeEditar
                                ? () => editarEvento(evento)
                                : null,
                            icon: const Icon(
                              Icons.edit_rounded,
                            ),
                            label: const Text('Editar'),
                          ),
                        ),

                        const SizedBox(width: 10),

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

  // PANTALLA PRINCIPAL

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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Aprende a organizar tus eventos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
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

          // INSTRUCCIÓN PASO A PASO

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

          construirCalendario(),

          const SizedBox(height: 24),

          construirEventos(),

          const SizedBox(height: 25),

          if (completada)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.check_circle_rounded,
                ),
                label: const Text(
                  'Finalizar práctica',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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
