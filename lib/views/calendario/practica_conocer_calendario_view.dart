
import 'package:flutter/material.dart';

import '../../controllers/calendario_controller.dart';

class PracticaConocerCalendarioView extends StatefulWidget {
  final CalendarioController controller;

  const PracticaConocerCalendarioView({
    super.key,
    required this.controller,
  });

  @override
  State<PracticaConocerCalendarioView> createState() =>
      _PracticaConocerCalendarioViewState();
}

class _PracticaConocerCalendarioViewState
    extends State<PracticaConocerCalendarioView> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);
  static const Color textoOscuro = Color(0xFF202C33);

  late DateTime mesActual;
  late DateTime diaSeleccionado;

  int pasoActual = 0;

  final List<String> instrucciones = [
    'PASO 1. Pulsa la flecha hacia la derecha para avanzar al siguiente mes.',
    'PASO 2. Pulsa la flecha hacia la izquierda para regresar al mes anterior.',
    'PASO 3. Selecciona cualquier día del calendario.',
    'PASO 4. Pulsa el botón "Hoy" para regresar a la fecha actual.',
  ];

  @override
  void initState() {
    super.initState();

    final hoy = DateTime.now();

    mesActual = DateTime(hoy.year, hoy.month);
    diaSeleccionado = hoy;

    final estado = widget.controller.estado;

    if (!estado.avanzarMes) {
      pasoActual = 0;
    } else if (!estado.retrocederMes) {
      pasoActual = 1;
    } else if (!estado.seleccionarDia) {
      pasoActual = 2;
    } else if (!estado.irHoy) {
      pasoActual = 3;
    } else {
      pasoActual = 4;
    }
  }

  // ==========================================
  // NOMBRE DEL MES
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

  // ==========================================
  // AVANZAR MES
  // ==========================================

  void avanzarMes() {
    setState(() {
      mesActual = DateTime(
        mesActual.year,
        mesActual.month + 1,
      );

      if (pasoActual == 0) {
        pasoActual = 1;
        widget.controller.completarActividad('avanzar_mes');
      }
    });
  }

  // ==========================================
  // RETROCEDER MES
  // ==========================================

  void retrocederMes() {
    setState(() {
      mesActual = DateTime(
        mesActual.year,
        mesActual.month - 1,
      );

      if (pasoActual == 1) {
        pasoActual = 2;
        widget.controller.completarActividad('retroceder_mes');
      }
    });
  }

  // ==========================================
  // SELECCIONAR DÍA
  // ==========================================

  void seleccionarDia(DateTime fecha) {
    setState(() {
      diaSeleccionado = fecha;

      if (pasoActual == 2) {
        pasoActual = 3;
        widget.controller.completarActividad('seleccionar_dia');
      }
    });
  }

  // ==========================================
  // REGRESAR A HOY
  // ==========================================

  void volverHoy() {
    final hoy = DateTime.now();

    setState(() {
      mesActual = DateTime(hoy.year, hoy.month);
      diaSeleccionado = hoy;

      if (pasoActual == 3) {
        pasoActual = 4;
        widget.controller.completarActividad('ir_hoy');
      }
    });
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

    return Column(
      children: [
        // ======================================
        // NAVEGACIÓN ENTRE MESES
        // ======================================

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: retrocederMes,
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 34,
                color: textoOscuro,
              ),
            ),

            Text(
              '${nombreMes(mesActual.month)} ${mesActual.year}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textoOscuro,
              ),
            ),

            IconButton(
              onPressed: avanzarMes,
              icon: const Icon(
                Icons.chevron_right_rounded,
                size: 34,
                color: textoOscuro,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // ======================================
        // DÍAS DE LA SEMANA
        // ======================================

        const Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'L',
                  style: TextStyle(
                    color: textoOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    color: textoOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    color: textoOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'J',
                  style: TextStyle(
                    color: textoOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'V',
                  style: TextStyle(
                    color: textoOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    color: textoOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'D',
                  style: TextStyle(
                    color: textoOscuro,
                    fontWeight: FontWeight.bold,
                  ),
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
            final numeroDia = index - espaciosIniciales + 1;

            if (numeroDia <= 0 || numeroDia > diasEnMes) {
              return const SizedBox();
            }

            final fecha = DateTime(
              mesActual.year,
              mesActual.month,
              numeroDia,
            );

            final seleccionado = widget.controller.mismaFecha(
              fecha,
              diaSeleccionado,
            );

            final esHoy = widget.controller.mismaFecha(
              fecha,
              DateTime.now(),
            );

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => seleccionarDia(fecha),
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
                child: Text(
                  '$numeroDia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: seleccionado
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: seleccionado
                        ? Colors.white
                        : textoOscuro,
                  ),
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
            icon: const Icon(Icons.today_rounded),
            label: const Text(
              'Hoy',
              style: TextStyle(fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF496A79),
              side: const BorderSide(
                color: azul,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
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
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Conocer el calendario',
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
            'Aprende a utilizar el calendario',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textoOscuro,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Sigue las instrucciones para aprender '
                'a navegar entre los meses y seleccionar fechas.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 22),

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pasoActual == 4
                      ? '¡Práctica completada!'
                      : 'Paso ${pasoActual + 1} de 4',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textoOscuro,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  pasoActual == 4
                      ? '¡Felicitaciones! Has aprendido '
                      'a navegar por el calendario.'
                      : instrucciones[pasoActual],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: textoOscuro,
                  ),
                ),

                const SizedBox(height: 14),

                LinearProgressIndicator(
                  value: pasoActual / 4,
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

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: construirCalendario(),
          ),

          const SizedBox(height: 25),

          // ======================================
          // FINALIZAR PRÁCTICA
          // ======================================

          if (pasoActual == 4)
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
