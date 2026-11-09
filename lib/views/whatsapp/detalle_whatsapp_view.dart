
import 'package:flutter/material.dart';

import '../../controllers/whatsapp_controller.dart';
import 'pantalla_whatsapp_sim.dart';

class DetalleWhatsappView extends StatefulWidget {
  const DetalleWhatsappView({super.key});

  @override
  State<DetalleWhatsappView> createState() =>
      _DetalleWhatsappViewState();
}

class _DetalleWhatsappViewState extends State<DetalleWhatsappView> {
  static const Color azulFondo = Color(0xFFBECCD2);
  static const Color azulIcono = Color(0xFF92AFBC);

  late final WhatsappController controller;

  @override
  void initState() {
    super.initState();
    controller = WhatsappController();
    controller.cargarProgreso();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _abrirPractica() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaWhatsappSim(
          controller: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text(
          'Realizar práctica',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final total = controller.totalLecciones;
          final completadas = controller.leccionesCompletadas;
          final pendientes = controller.leccionesPendientes;
          final porcentaje = controller.porcentajeProgreso;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: azulIcono,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.chat_rounded,
                    size: 75,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'WhatsApp',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Aprende a utilizar WhatsApp de manera sencilla. '
                      'Practica cómo enviar mensajes, compartir audios y fotos, '
                      'realizar llamadas, publicar estados y buscar contactos.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                // Información de la práctica
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: azulFondo,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _dato(
                        Icons.access_time_rounded,
                        'Duración',
                        '20 minutos',
                      ),
                      _dato(
                        Icons.trending_up_rounded,
                        'Nivel',
                        'Fácil',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Resumen del progreso
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE1E7EA),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: controller.cargando
                      ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.assessment_rounded,
                            color: Color(0xFF668B9B),
                            size: 25,
                          ),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Mi progreso',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$completadas de $total actividades',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${(porcentaje * 100).round()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFF39866A),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: porcentaje,
                          minHeight: 11,
                          backgroundColor:
                          const Color(0xFFE8ECEE),
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4B9B7B),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF39866A),
                            size: 19,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$completadas completadas',
                            style: const TextStyle(
                              color: Color(0xFF39866A),
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.pending_outlined,
                            color: Colors.grey,
                            size: 19,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$pendientes pendientes',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 25),

                      const Text(
                        'Tus actividades',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ...controller.lecciones.map((leccion) {
                        final completada =
                        controller.estaCompletada(leccion.id);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                completada
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: completada
                                    ? const Color(0xFF39866A)
                                    : Colors.grey,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  leccion.titulo,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: completada
                                        ? const Color(0xFF39866A)
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              Text(
                                completada
                                    ? 'Completada'
                                    : 'Pendiente',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: completada
                                      ? const Color(0xFF39866A)
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Botón para aprender
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azulIcono,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed:
                    controller.cargando ? null : _abrirPractica,
                    child: const Text(
                      'Aprender a usar WhatsApp',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dato(IconData icono, String etiqueta, String valor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icono,
            size: 32,
            color: const Color(0xFF79929E),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          etiqueta,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
