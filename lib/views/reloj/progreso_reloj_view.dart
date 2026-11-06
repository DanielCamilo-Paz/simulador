
import 'package:flutter/material.dart';
import '../../controllers/progreso_controller.dart';

class ProgresoRelojView extends StatefulWidget {
  final ProgresoController progresoController;

  const ProgresoRelojView({
    super.key,
    required this.progresoController,
  });

  @override
  State<ProgresoRelojView> createState() =>
      _ProgresoRelojViewState();
}

class _ProgresoRelojViewState extends State<ProgresoRelojView> {
  static const Color verde = Color(0xFF299764);
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);

  // Identificador guardado por el controlador y nombre visible.
  final List<Map<String, String>> actividades = [
    {
      'id': 'abrir_alarmas',
      'nombre': 'Abrir la sección de alarmas',
    },
    {
      'id': 'crear_alarma',
      'nombre': 'Crear una alarma',
    },
    {
      'id': 'editar_alarma',
      'nombre': 'Editar una alarma',
    },
    {
      'id': 'activar_alarma',
      'nombre': 'Activar o desactivar una alarma',
    },
    {
      'id': 'reloj_mundial',
      'nombre': 'Consultar el reloj mundial',
    },
    {
      'id': 'iniciar_cronometro',
      'nombre': 'Iniciar el cronómetro',
    },
    {
      'id': 'guardar_vuelta',
      'nombre': 'Guardar un tiempo',
    },
    {
      'id': 'reiniciar_cronometro',
      'nombre': 'Reiniciar el cronómetro',
    },
  ];

  @override
  void initState() {
    super.initState();
    widget.progresoController.addListener(actualizarVista);
  }

  void actualizarVista() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.progresoController.removeListener(actualizarVista);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final realizadas =
    widget.progresoController.obtenerActividadesReloj();

    // Calculamos el progreso directamente desde las actividades
    // que coinciden con los identificadores.
    final cantidad = actividades.where((actividad) {
      return realizadas.contains(actividad['id']);
    }).length;

    final porcentaje = ((cantidad / actividades.length) * 100).round();

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        title: const Text(
          'Mi progreso',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: fondo,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // RESUMEN DEL PROGRESO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: azul),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    size: 55,
                    color: verde,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Mi progreso en el reloj',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '$porcentaje%',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: verde,
                    ),
                  ),

                  Text(
                    '$cantidad de ${actividades.length} actividades completadas',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: porcentaje / 100,
                      minHeight: 12,
                      backgroundColor: azul.withValues(alpha: 0.35),
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(verde),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Mis actividades',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // LISTA DE ACTIVIDADES
            ...actividades.map((actividad) {
              final completada =
              realizadas.contains(actividad['id']);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: completada
                        ? verde.withValues(alpha: 0.5)
                        : azul.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      completada
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: completada ? verde : Colors.grey,
                      size: 30,
                    ),

                    const SizedBox(width: 13),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            actividad['nombre']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            completada
                                ? 'Actividad completada'
                                : 'Actividad pendiente',
                            style: TextStyle(
                              fontSize: 13,
                              color: completada
                                  ? verde
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 10),

            if (porcentaje == 100)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: verde.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '¡Felicitaciones! Has completado todas las actividades del reloj.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: verde,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
