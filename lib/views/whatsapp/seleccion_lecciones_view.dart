
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
        if (controller.cargando) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF075E54),
              ),
            ),
          );
        }

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
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PanelProgreso(controller: controller),

                const SizedBox(height: 22),

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
                      final completada =
                      controller.estaCompletada(leccion.id);

                      return _TarjetaLeccionProgreso(
                        leccion: leccion,
                        completada: completada,
                        onTap: () => onSeleccionarLeccion(leccion),
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

class _PanelProgreso extends StatelessWidget {
  final WhatsappController controller;

  const _PanelProgreso({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final porcentaje =
    (controller.porcentajeProgreso * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tu progreso',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202C33),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${controller.leccionesCompletadas} de '
                    '${controller.totalLecciones} prácticas completadas',
                style: const TextStyle(
                  color: Color(0xFF667781),
                  fontSize: 13,
                ),
              ),
              Text(
                '$porcentaje%',
                style: const TextStyle(
                  color: Color(0xFF075E54),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: controller.porcentajeProgreso,
              minHeight: 10,
              backgroundColor: const Color(0xFFE5E9EB),
              color: const Color(0xFF25D366),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaLeccionProgreso extends StatelessWidget {
  final LeccionWhatsappModel leccion;
  final bool completada;
  final VoidCallback onTap;

  const _TarjetaLeccionProgreso({
    required this.leccion,
    required this.completada,
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
          border: Border.all(
            color: completada
                ? const Color(0xFF25D366)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: completada
                  ? const Icon(
                Icons.check_circle,
                color: Color(0xFF25D366),
                size: 23,
              )
                  : const Icon(
                Icons.circle_outlined,
                color: Color(0xFFCCD3D6),
                size: 23,
              ),
            ),

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

            const SizedBox(height: 5),

            Text(
              completada ? 'Completada' : 'Pendiente',
              style: TextStyle(
                fontSize: 12,
                color: completada
                    ? const Color(0xFF168B55)
                    : const Color(0xFF667781),
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
