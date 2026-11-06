
import 'package:flutter/material.dart';

import '../../controllers/progreso_controller.dart';

class ProgresoCalendarioView extends StatefulWidget {
  final ProgresoController progresoController;

  const ProgresoCalendarioView({
    super.key,
    required this.progresoController,
  });

  @override
  State<ProgresoCalendarioView> createState() =>
      _ProgresoCalendarioViewState();
}

class _ProgresoCalendarioViewState
    extends State<ProgresoCalendarioView> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  final List<Map<String, String>> actividades = [
    {
      'id': 'navegar_calendario',
      'nombre': 'Navegar por el calendario',
      'descripcion': 'Avanzar, retroceder y seleccionar fechas.',
    },
    {
      'id': 'crear_evento',
      'nombre': 'Crear un evento',
      'descripcion': 'Agregar un evento con sus datos y recordatorio.',
    },
    {
      'id': 'consultar_evento',
      'nombre': 'Consultar un evento',
      'descripcion': 'Buscar y visualizar un evento guardado.',
    },
    {
      'id': 'editar_eliminar_evento',
      'nombre': 'Editar y eliminar un evento',
      'descripcion': 'Modificar o eliminar un evento del calendario.',
    },
  ];

  @override
  void initState() {
    super.initState();
    widget.progresoController.addListener(actualizarPantalla);
  }

  @override
  void dispose() {
    widget.progresoController.removeListener(actualizarPantalla);
    super.dispose();
  }

  void actualizarPantalla() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final completadas = widget.progresoController
        .obtenerActividadesCalendario();

    final porcentaje = widget.progresoController
        .obtenerPorcentajeCalendario();

    final cantidadCompletadas = completadas.length;
    final totalActividades = actividades.length;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Mi progreso',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Center(
                child: Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    color: azul.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    size: 60,
                    color: azul,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Mi progreso en el calendario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                        size: 48,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '${porcentaje.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: verde,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Progreso completado',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 22),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: (porcentaje / 100).clamp(0.0, 1.0),
                          minHeight: 14,
                          backgroundColor: Colors.black12,
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(verde),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        '$cantidadCompletadas de $totalActividades actividades completadas',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Mis actividades',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ...actividades.map((actividad) {
                final realizada =
                completadas.contains(actividad['id']);

                return Card(
                  color: Colors.white,
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: realizada
                                ? verde.withOpacity(0.12)
                                : azul.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            realizada
                                ? Icons.check_circle
                                : Icons.pending_actions,
                            color: realizada ? verde : azul,
                            size: 27,
                          ),
                        ),

                        const SizedBox(width: 13),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                actividad['nombre']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                actividad['descripcion']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  height: 1.3,
                                ),
                              ),

                              const SizedBox(height: 7),

                              Text(
                                realizada
                                    ? 'Actividad completada'
                                    : 'Actividad pendiente',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: realizada ? verde : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(
                          realizada
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: realizada ? verde : Colors.black26,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 15),

              if (porcentaje >= 100)
                Card(
                  color: verde.withOpacity(0.12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.celebration,
                          color: verde,
                          size: 45,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '¡Felicitaciones!',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: verde,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Has completado todas las actividades '
                              'de la práctica del calendario. ¡Excelente trabajo!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
