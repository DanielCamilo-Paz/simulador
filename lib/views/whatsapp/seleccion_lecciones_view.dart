
import 'package:flutter/material.dart';

import '../../controllers/whatsapp_controller.dart';
import '../../models/whatsapp/leccion_whatsapp_model.dart';

class SeleccionLeccionesView extends StatelessWidget {
  final WhatsappController controller;
  final Function(LeccionWhatsappModel) onSeleccionarLeccion;

  const SeleccionLeccionesView({
    super.key,
    required this.controller,
    required this.onSeleccionarLeccion,
  });

  // COLORES
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  // REINICIAR PROGRESO
  Future<void> _reiniciarTodo(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text('¿Reiniciar todo?'),
          content: const Text(
            'Se borrará el progreso de las seis prácticas '
                'de WhatsApp.\n\n'
                'Esta acción no se puede deshacer.',
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
              child: const Text('Reiniciar todo'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !context.mounted) return;

    await controller.reiniciarProgreso();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Todo el progreso de WhatsApp se ha reiniciado.',
        ),
      ),
    );
  }

  // TARJETA DE CADA LECCIÓN
  Widget _tarjetaPractica({
    required LeccionWhatsappModel leccion,
    required VoidCallback onTap,
  }) {
    final bool completada =
    controller.estaCompletada(leccion.id);

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: azul.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  leccion.icono,
                  color: const Color(0xFF496A79),
                  size: 30,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leccion.titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      leccion.descripcion,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      completada
                          ? 'Práctica completada'
                          : 'Práctica pendiente',
                      style: TextStyle(
                        color: completada
                            ? verde
                            : Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: azul,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // PANTALLA PRINCIPAL
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Práctica de WhatsApp',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (controller.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // CÁLCULO CORREGIDO DEL PROGRESO
          final int completadas =
              controller.leccionesCompletadas;

          final int total =
              controller.totalLecciones;

          final double porcentaje = total == 0
              ? 0.0
              : (completadas / total) * 100.0;

          final double valorBarra = total == 0
              ? 0.0
              : completadas / total;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ENCABEZADO
              const Text(
                'Aprendamos a usar WhatsApp',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Practica enviando mensajes, audios, '
                    'fotos, realizando llamadas y '
                    'comunicándote con tus familiares '
                    'y amigos.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // PROGRESO GENERAL
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progreso general',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        Text(
                          '${porcentaje.round()}%',
                          style: const TextStyle(
                            color: verde,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // BARRA DE PROGRESO
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: valorBarra.clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor:
                        Colors.grey.shade200,
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                          verde,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      completadas == total && total > 0
                          ? '¡Felicitaciones! Has completado '
                          'todas las prácticas de WhatsApp.'
                          : 'Has completado $completadas '
                          'de $total prácticas.',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // LISTA DE LAS SEIS PRÁCTICAS
              ...List<LeccionWhatsappModel>.from(
                controller.lecciones,
              ).map<Widget>(
                    (LeccionWhatsappModel leccion) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: _tarjetaPractica(
                      leccion: leccion,
                      onTap: () {
                        onSeleccionarLeccion(leccion);
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // BOTÓN REINICIAR TODO
              OutlinedButton.icon(
                onPressed: () {
                  _reiniciarTodo(context);
                },
                icon: const Icon(
                  Icons.restart_alt_rounded,
                ),
                label: const Text('Reiniciar todo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                  Colors.red.shade700,
                  side: BorderSide(
                    color: Colors.red.shade300,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
