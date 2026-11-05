
import 'package:flutter/material.dart';

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

class PantallaCalendarioSim extends StatefulWidget {
  const PantallaCalendarioSim({super.key});

  @override
  State<PantallaCalendarioSim> createState() =>
      _PantallaCalendarioSimState();
}

class _PantallaCalendarioSimState extends State<PantallaCalendarioSim> {
  final Color azul = const Color(0xFF92AFBC);
  final Color fondo = const Color(0xFFF7F9FA);
  final Color verde = const Color(0xFF299764);

  DateTime mesActual = DateTime.now();
  DateTime fechaSeleccionada = DateTime.now();

  final List<EventoCalendario> eventos = [];

  final List<String> meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril',
    'Mayo', 'Junio', 'Julio', 'Agosto',
    'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  final List<String> diasSemana = [
    'L', 'M', 'X', 'J', 'V', 'S', 'D'
  ];

  String formatoFecha(DateTime fecha) {
    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  bool mismaFecha(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool eventoCorresponde(EventoCalendario evento, DateTime fecha) {
    final inicio = DateTime(
      evento.fechaInicio.year,
      evento.fechaInicio.month,
      evento.fechaInicio.day,
    );

    final fin = DateTime(
      evento.fechaFin.year,
      evento.fechaFin.month,
      evento.fechaFin.day,
    );

    final dia = DateTime(fecha.year, fecha.month, fecha.day);

    if (dia.isBefore(inicio)) return false;

    switch (evento.repeticion) {
      case 'Todos los días':
        return !dia.isAfter(fin) || mismaFecha(dia, inicio);

      case 'Cada semana':
        return dia.weekday == inicio.weekday &&
            (evento.fechaFin.isAfter(evento.fechaInicio) ||
                mismaFecha(dia, inicio));

      case 'Cada mes':
        return dia.day == inicio.day &&
            (dia.year < evento.fechaFin.year ||
                (dia.year == evento.fechaFin.year &&
                    dia.month <= evento.fechaFin.month));

      case 'Cada año':
        return dia.day == inicio.day &&
            dia.month == inicio.month &&
            dia.year <= evento.fechaFin.year;

      default:
        return !dia.isBefore(inicio) && !dia.isAfter(fin);
    }
  }

  List<EventoCalendario> eventosDelDia(DateTime fecha) {
    return eventos
        .where((evento) => eventoCorresponde(evento, fecha))
        .toList();
  }

  void cambiarMes(int cantidad) {
    setState(() {
      mesActual = DateTime(
        mesActual.year,
        mesActual.month + cantidad,
        1,
      );
    });
  }

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

                    setState(() {
                      if (evento == null) {
                        eventos.add(nuevoEvento);
                      } else {
                        final indice = eventos.indexOf(evento);
                        if (indice != -1) {
                          eventos[indice] = nuevoEvento;
                        }
                      }

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

  void eliminarEvento(EventoCalendario evento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar evento'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este evento?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                eventos.remove(evento);
              });
              Navigator.pop(context);
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
    final totalCasillas = ((espaciosIniciales + diasMes) / 7).ceil() * 7;

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
              onTap: () {
                setState(() {
                  fechaSeleccionada = fecha;
                });
              },
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

  @override
  Widget build(BuildContext context) {
    final listaEventos = eventosDelDia(fechaSeleccionada);

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Calendario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Añadir evento',
            icon: const Icon(Icons.add, size: 30),
            onPressed: () => mostrarFormulario(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            onPressed: () => cambiarMes(-1),
                            icon: const Icon(Icons.chevron_left, size: 30),
                          ),
                          IconButton(
                            onPressed: () => cambiarMes(1),
                            icon: const Icon(Icons.chevron_right, size: 30),
                          ),
                        ],
                      ),
                      construirCalendario(),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              fechaSeleccionada = DateTime.now();
                              mesActual = DateTime.now();
                            });
                          },
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

              Text(
                formatoFecha(fechaSeleccionada),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                      ),
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
                  ),
                )
              else
                ...listaEventos.map(construirEvento),
            ],
          ),
        ),
      ),
    );
  }
}

