
import 'package:flutter/material.dart';

import '../../controllers/progreso_general_controller.dart';
import '../../models/progreso_general/progreso_general_model.dart';

class ProgresoGeneralView extends StatefulWidget {
  final ProgresoGeneralController controller;

  const ProgresoGeneralView({
    super.key,
    required this.controller,
  });

  @override
  State<ProgresoGeneralView> createState() =>
      _ProgresoGeneralViewState();
}

class _ProgresoGeneralViewState
    extends State<ProgresoGeneralView> {

  // COLORES DE SAFETAP

  static const Color fondo = Color(0xFFEFF6FF);
  static const Color azul = Color(0xFF4D67BC);
  static const Color verde = Color(0xFF299764);
  static const Color texto = Color(0xFF333333);
  static const Color blanco = Colors.white;

  // FUNCIÓN DESPLEGADA ACTUALMENTE
  String? aplicacionAbierta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        title: const Text(
          'Mi progreso general',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),
      ),

      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {

          final ProgresoGeneralModel progreso =
          widget.controller.obtenerProgresoGeneral();

          final double porcentaje =
          progreso.porcentajeGeneral.clamp(0.0, 100.0);

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [

                const Text(
                  '¡Mira cuánto has aprendido!',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Consulta tu progreso y descubre '
                      'qué lecciones has completado.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 24),

                // PROGRESO GENERAL

                _construirProgresoGeneral(
                  progreso,
                  porcentaje,
                ),

                const SizedBox(height: 28),

                const Text(
                  'Progreso por función',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Toca una función para consultar '
                      'sus lecciones.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 16),

                // LAS CINCO FUNCIONES

                ...progreso.aplicaciones.map(
                      (aplicacion) =>
                      _tarjetaAplicacion(aplicacion),
                ),

                const SizedBox(height: 20),

                const Text(
                  '¡Sigue practicando! Cada lección '
                      'cuenta para alcanzar el 100%.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------
  // TARJETA DE PROGRESO GENERAL
  // ---------------------------------------

  Widget _construirProgresoGeneral(
      ProgresoGeneralModel progreso,
      double porcentaje,
      ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: blanco,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [

          const Text(
            'Progreso total de SafeTap',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),

          const SizedBox(height: 22),

          // GRÁFICO CIRCULAR

          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [

                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: porcentaje / 100,
                    strokeWidth: 15,
                    backgroundColor:
                    const Color(0xFFDCE5F5),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                      azul,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      '${porcentaje.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: texto,
                      ),
                    ),

                    const Text(
                      'Completado',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            '${progreso.aplicacionesCompletadas} de '
                '${progreso.totalAplicaciones} '
                'funciones completadas',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: texto,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Tu progreso aumenta al completar '
                'las lecciones de cada función.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------
  // TARJETA DESPLEGABLE DE CADA FUNCIÓN
  // ---------------------------------------

  Widget _tarjetaAplicacion(
      ProgresoAplicacionModel aplicacion,
      ) {

    final double porcentaje =
        aplicacion.porcentajeIndividual;

    final double aporte =
        aplicacion.aporteGeneral;

    final bool estaAbierta =
        aplicacionAbierta == aplicacion.id;

    final lecciones =
    widget.controller.obtenerDetalleLecciones(
      aplicacion.id,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: blanco,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFDCE5F5),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ENCABEZADO QUE SE PUEDE TOCAR

          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              setState(() {
                if (estaAbierta) {
                  aplicacionAbierta = null;
                } else {
                  aplicacionAbierta = aplicacion.id;
                }
              });
            },

            child: Padding(
              padding: const EdgeInsets.all(18),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      Expanded(
                        child: Text(
                          aplicacion.nombre,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: texto,
                          ),
                        ),
                      ),

                      Text(
                        '${porcentaje.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: azul,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Icon(
                        estaAbierta
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: azul,
                        size: 28,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // BARRA DE PROGRESO

                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (porcentaje / 100)
                          .clamp(0.0, 1.0),
                      minHeight: 12,
                      backgroundColor:
                      const Color(0xFFDCE5F5),
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(
                        azul,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '${aplicacion.actividadesCompletadas} de '
                        '${aplicacion.totalActividades} '
                        'lecciones completadas',
                    style: const TextStyle(
                      fontSize: 14,
                      color: texto,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Aporte al progreso general: '
                        '${aporte.toStringAsFixed(1)}% '
                        'de ${aplicacion.pesoMaximo.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  if (aplicacion.completada) ...[
                    const SizedBox(height: 10),

                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: verde,
                          size: 20,
                        ),
                        SizedBox(width: 7),
                        Text(
                          '¡Función completada!',
                          style: TextStyle(
                            color: verde,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // LISTA DESPLEGABLE DE LECCIONES

          if (estaAbierta) ...[

            const Divider(
              height: 1,
              color: Color(0xFFDCE5F5),
            ),

            Padding(
              padding: const EdgeInsets.all(18),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Estado de las lecciones',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: texto,
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (lecciones.isEmpty)
                    const Text(
                      'Todavía no hay lecciones '
                          'registradas para esta función.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                  ...lecciones.map((leccion) {

                    final bool completada =
                        leccion['completada'] == true;

                    final String nombre =
                    leccion['nombre'] as String;

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 14,
                      ),

                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Icon(
                            completada
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: completada
                                ? verde
                                : Colors.grey,
                            size: 25,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  nombre,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.w600,
                                    color: texto,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  completada
                                      ? 'Completada'
                                      : 'Pendiente',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: completada
                                        ? verde
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
