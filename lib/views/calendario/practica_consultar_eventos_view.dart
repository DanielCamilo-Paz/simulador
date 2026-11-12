
import 'package:flutter/material.dart';

import '../../controllers/calendario_controller.dart';
import '../../models/calendario/calendario_model.dart';

class PracticaConsultarEventosView extends StatefulWidget {
  final CalendarioController controller;

  const PracticaConsultarEventosView({
    super.key,
    required this.controller,
  });

  @override
  State<PracticaConsultarEventosView> createState() =>
      _PracticaConsultarEventosViewState();
}

class _PracticaConsultarEventosViewState
    extends State<PracticaConsultarEventosView> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);
  static const Color textoOscuro = Color(0xFF202C33);

  late DateTime mesActual;
  late DateTime fechaSeleccionada;

  bool practicaCompletada = false;

  @override
  void initState() {
    super.initState();

    final hoy = DateTime.now();

    mesActual = DateTime(hoy.year, hoy.month);
    fechaSeleccionada = hoy;

    practicaCompletada =
        widget.controller.estado.consultarEvento;
  }

  // ==========================================
  // FORMATOS DE FECHA Y HORA
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
  // CONSULTAR EVENTO
  // ==========================================

  Future<void> consultarEvento(
      EventoCalendario evento,
      ) async {
    await widget.controller.completarActividad(
      'consultar_evento',
    );

    if (!mounted) return;

    setState(() {
      practicaCompletada = true;
    });

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: azul,
              brightness: Brightness.light,
            ),
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              evento.titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textoOscuro,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detalle(
                    Icons.event_rounded,
                    'Fecha de inicio',
                    formatoFecha(evento.fechaInicio),
                  ),

                  if (!evento.todoElDia)
                    _detalle(
                      Icons.access_time_rounded,
                      'Hora de inicio',
                      formatoHora(evento.fechaInicio),
                    ),

                  const SizedBox(height: 12),

                  _detalle(
                    Icons.event_available_rounded,
                    'Fecha de finalización',
                    formatoFecha(evento.fechaFin),
                  ),

                  if (!evento.todoElDia)
                    _detalle(
                      Icons.access_time_rounded,
                      'Hora de finalización',
                      formatoHora(evento.fechaFin),
                    ),

                  const SizedBox(height: 12),

                  _detalle(
                    Icons.repeat_rounded,
                    'Repetición',
                    evento.repeticion,
                  ),

                  const SizedBox(height: 12),

                  _detalle(
                    Icons.notifications_rounded,
                    'Recordatorio',
                    evento.recordatorio,
                  ),

                  const SizedBox(height: 12),

                  _detalle(
                    Icons.alarm_rounded,
                    'Tipo de recordatorio',
                    evento.tipoRecordatorio,
                  ),

                  if (evento.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _detalle(
                      Icons.description_rounded,
                      'Descripción',
                      evento.descripcion,
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'Entendido',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // DETALLE DE INFORMACIÓN DEL EVENTO
  // ==========================================

  Widget _detalle(
      IconData icono,
      String titulo,
      String valor,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icono,
          color: azul,
          size: 23,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textoOscuro,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                valor,
                style: const TextStyle(
                  fontSize: 15,
                  color: textoOscuro,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // CONSTRUIR CALENDARIO
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

              final esHoy = widget.controller.mismaFecha(
                fecha,
                DateTime.now(),
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
                    border: esHoy
                        ? Border.all(
                      color: verde,
                      width: 2,
                    )
                        : null,
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
              label: const Text(
                'Hoy',
                style: TextStyle(fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF496A79),
                side: const BorderSide(color: azul),
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
  // CONSTRUIR LISTA DE EVENTOS
  // ==========================================

  Widget construirListaEventos() {
    final eventos = widget.controller
        .obtenerEventosPorFecha(fechaSeleccionada);

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
                    fontSize: 15,
                    color: textoOscuro,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Selecciona otro día que tenga '
                      'un punto verde debajo del número.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
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
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE2ECEF),
                  child: Icon(
                    Icons.event_note_rounded,
                    color: azul,
                  ),
                ),
                title: Text(
                  evento.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textoOscuro,
                  ),
                ),
                subtitle: Text(
                  evento.todoElDia
                      ? 'Todo el día'
                      : formatoHora(evento.fechaInicio),
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: textoOscuro,
                ),
                onTap: () => consultarEvento(evento),
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
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Consultar eventos',
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
            'Aprende a consultar eventos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textoOscuro,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Selecciona una fecha del calendario '
                'para consultar tus eventos guardados.',
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
                  practicaCompletada
                      ? '¡Práctica completada!'
                      : 'PASO 1 DE 1',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textoOscuro,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  practicaCompletada
                      ? '¡Felicitaciones! Ya sabes '
                      'consultar eventos guardados.'
                      : 'Busca una fecha que tenga eventos '
                      'y pulsa uno para consultar '
                      'su información.',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: textoOscuro,
                  ),
                ),

                const SizedBox(height: 14),

                LinearProgressIndicator(
                  value: practicaCompletada ? 1 : 0,
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
          // LISTA DE EVENTOS
          // ======================================

          construirListaEventos(),

          const SizedBox(height: 24),

          // ======================================
          // FINALIZAR PRÁCTICA
          // ======================================

          if (practicaCompletada)
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
