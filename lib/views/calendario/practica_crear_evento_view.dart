
import 'package:flutter/material.dart';

import '../../controllers/calendario_controller.dart';
import '../../models/calendario/calendario_model.dart';

class PracticaCrearEventoView extends StatefulWidget {
  final CalendarioController controller;

  const PracticaCrearEventoView({
    super.key,
    required this.controller,
  });

  @override
  State<PracticaCrearEventoView> createState() =>
      _PracticaCrearEventoViewState();
}

class _PracticaCrearEventoViewState
    extends State<PracticaCrearEventoView> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  final TextEditingController tituloController =
  TextEditingController();

  final TextEditingController descripcionController =
  TextEditingController();

  late DateTime fechaInicio;
  late DateTime fechaFin;

  bool todoElDia = false;
  bool guardando = false;
  bool eventoGuardado = false;

  String repeticion = 'Nunca';
  String recordatorio = '10 minutos antes';
  String tipoRecordatorio = 'Notificación';

  @override
  void initState() {
    super.initState();

    fechaInicio = DateTime.now();
    fechaFin = fechaInicio.add(const Duration(hours: 1));

    eventoGuardado = widget.controller.estado.crearEvento;
  }

  @override
  void dispose() {
    tituloController.dispose();
    descripcionController.dispose();
    super.dispose();
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

  Future<void> seleccionarFecha(bool inicio) async {
    final fechaActual = inicio ? fechaInicio : fechaFin;

    final seleccionada = await showDatePicker(
      context: context,
      initialDate: fechaActual,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Selecciona una fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (seleccionada == null || !mounted) return;

    setState(() {
      final nuevaFecha = DateTime(
        seleccionada.year,
        seleccionada.month,
        seleccionada.day,
        fechaActual.hour,
        fechaActual.minute,
      );

      if (inicio) {
        fechaInicio = nuevaFecha;

        if (fechaFin.isBefore(fechaInicio)) {
          fechaFin = fechaInicio.add(
            const Duration(hours: 1),
          );
        }
      } else {
        fechaFin = nuevaFecha;
      }
    });
  }

  Future<void> seleccionarHora(bool inicio) async {
    final fechaActual = inicio ? fechaInicio : fechaFin;

    final seleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(fechaActual),
      helpText: 'Selecciona una hora',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (seleccionada == null || !mounted) return;

    setState(() {
      final nuevaFecha = DateTime(
        fechaActual.year,
        fechaActual.month,
        fechaActual.day,
        seleccionada.hour,
        seleccionada.minute,
      );

      if (inicio) {
        fechaInicio = nuevaFecha;

        if (fechaFin.isBefore(fechaInicio)) {
          fechaFin = fechaInicio.add(
            const Duration(hours: 1),
          );
        }
      } else {
        fechaFin = nuevaFecha;
      }
    });
  }

  Future<void> guardarEvento() async {
    if (guardando) return;

    if (tituloController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Escribe un título para el evento.',
          ),
        ),
      );
      return;
    }

    if (fechaFin.isBefore(fechaInicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La fecha de finalización no puede '
                'ser anterior a la fecha de inicio.',
          ),
        ),
      );
      return;
    }

    setState(() {
      guardando = true;
    });

    try {
      final evento = EventoCalendario(
        titulo: tituloController.text.trim(),
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        todoElDia: todoElDia,
        repeticion: repeticion,
        recordatorio: recordatorio,
        tipoRecordatorio: tipoRecordatorio,
        descripcion: descripcionController.text.trim(),
      );

      await widget.controller.agregarEvento(evento);

      await widget.controller.completarActividad(
        'crear_evento',
      );

      if (!mounted) return;

      setState(() {
        eventoGuardado = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '¡Evento guardado correctamente!',
          ),
          backgroundColor: verde,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo guardar el evento. Inténtalo de nuevo.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  Widget construirSelector({
    required String titulo,
    required String valor,
    required IconData icono,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icono,
        color: azul,
        size: 28,
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        valor,
        style: const TextStyle(fontSize: 15),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
      ),
      onTap: onTap,
    );
  }

  Future<void> seleccionarOpcion({
    required String titulo,
    required List<String> opciones,
    required ValueChanged<String> onSeleccionar,
  }) async {
    final seleccion = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                ...opciones.map(
                      (opcion) => ListTile(
                    title: Text(opcion),
                    onTap: () {
                      Navigator.pop(context, opcion);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (seleccion != null && mounted) {
      setState(() {
        onSeleccionar(seleccion);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Crear un evento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Aprende a crear un evento',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Aprende a organizar tus actividades '
                'registrando eventos en el calendario.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // INSTRUCCIÓN

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: azul.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventoGuardado
                      ? '¡Práctica completada!'
                      : 'PASO 1 DE 1',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  eventoGuardado
                      ? '¡Felicitaciones! Has aprendido '
                      'a crear y guardar un evento.'
                      : 'Completa los datos del evento '
                      'y pulsa el botón "Guardar evento".',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: eventoGuardado ? 1 : 0,
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

          // FORMULARIO DEL EVENTO

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                TextField(
                  controller: tituloController,
                  textCapitalization:
                  TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Título del evento',
                    hintText: 'Ejemplo: Cita médica',
                    prefixIcon:
                    Icon(Icons.edit_note_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Todo el día',
                    style: TextStyle(fontSize: 16),
                  ),
                  value: todoElDia,
                  activeColor: verde,
                  onChanged: (valor) {
                    setState(() {
                      todoElDia = valor;
                    });
                  },
                ),

                const Divider(),

                construirSelector(
                  titulo: 'Fecha de inicio',
                  valor: formatoFecha(fechaInicio),
                  icono: Icons.event_rounded,
                  onTap: () => seleccionarFecha(true),
                ),

                if (!todoElDia)
                  construirSelector(
                    titulo: 'Hora de inicio',
                    valor: formatoHora(fechaInicio),
                    icono: Icons.access_time_rounded,
                    onTap: () => seleccionarHora(true),
                  ),

                const Divider(),

                construirSelector(
                  titulo: 'Fecha de finalización',
                  valor: formatoFecha(fechaFin),
                  icono: Icons.event_available_rounded,
                  onTap: () => seleccionarFecha(false),
                ),

                if (!todoElDia)
                  construirSelector(
                    titulo: 'Hora de finalización',
                    valor: formatoHora(fechaFin),
                    icono: Icons.access_time_rounded,
                    onTap: () => seleccionarHora(false),
                  ),

                const Divider(),

                construirSelector(
                  titulo: 'Repetir',
                  valor: repeticion,
                  icono: Icons.repeat_rounded,
                  onTap: () => seleccionarOpcion(
                    titulo: 'Repetir evento',
                    opciones: const [
                      'Nunca',
                      'Todos los días',
                      'Cada semana',
                      'Cada mes',
                      'Cada año',
                    ],
                    onSeleccionar: (valor) {
                      repeticion = valor;
                    },
                  ),
                ),

                const Divider(),

                construirSelector(
                  titulo: 'Recordatorio',
                  valor: recordatorio,
                  icono: Icons.notifications_rounded,
                  onTap: () => seleccionarOpcion(
                    titulo: 'Selecciona un recordatorio',
                    opciones: const [
                      'Sin recordatorio',
                      '10 minutos antes',
                      '20 minutos antes',
                      '30 minutos antes',
                      '1 hora antes',
                      '1 día antes',
                    ],
                    onSeleccionar: (valor) {
                      recordatorio = valor;
                    },
                  ),
                ),

                const Divider(),

                construirSelector(
                  titulo: 'Tipo de recordatorio',
                  valor: tipoRecordatorio,
                  icono: Icons.alarm_rounded,
                  onTap: () => seleccionarOpcion(
                    titulo: 'Tipo de recordatorio',
                    opciones: const [
                      'Notificación',
                      'Alarma',
                    ],
                    onSeleccionar: (valor) {
                      tipoRecordatorio = valor;
                    },
                  ),
                ),

                const Divider(),

                const SizedBox(height: 12),

                TextField(
                  controller: descripcionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText:
                    'Escribe información adicional',
                    prefixIcon:
                    Icon(Icons.description_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          if (!eventoGuardado)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: guardando ? null : guardarEvento,
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  guardando
                      ? 'Guardando...'
                      : 'Guardar evento',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: azul,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          if (eventoGuardado)
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

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
