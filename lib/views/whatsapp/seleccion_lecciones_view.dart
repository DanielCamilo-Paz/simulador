
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F5),
          appBar: AppBar(
            title: const Text(
              'Prácticas de WhatsApp',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF075E54),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecciona una práctica',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF202C33),
                  ),
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: GridView.builder(
                    itemCount: controller.lecciones.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemBuilder: (context, index) {
                      final leccion = controller.lecciones[index];

                      return _TarjetaLeccion(
                        leccion: leccion,
                        onTap: () {
                          onSeleccionarLeccion(leccion);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TarjetaLeccion extends StatelessWidget {
  final LeccionWhatsappModel leccion;
  final VoidCallback onTap;

  const _TarjetaLeccion({
    required this.leccion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            CircleAvatar(
              radius: 29,
              backgroundColor: leccion.color.withValues(alpha: 0.15),
              child: Icon(
                leccion.icono,
                color: leccion.color,
                size: 30,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              leccion.titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF202C33),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Toca para practicar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF667781),
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}