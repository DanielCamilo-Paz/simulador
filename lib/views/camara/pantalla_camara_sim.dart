
import 'package:flutter/material.dart';

import '../../controllers/camara_controller.dart';
import '../compartido/tema_simulador.dart';

import 'practica_camara_view.dart';
import 'practica_galeria_view.dart';

class PantallaCamaraSim extends StatefulWidget {
  const PantallaCamaraSim({super.key});

  @override
  State<PantallaCamaraSim> createState() =>
      _PantallaCamaraSimState();
}

class _PantallaCamaraSimState extends State<PantallaCamaraSim> {
  late final CamaraController controller;

  // ========================================
  // COLORES ORIGINALES DEL SIMULADOR
  // ========================================

  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  // ========================================
  // INICIALIZAR CONTROLADOR
  // ========================================

  @override
  void initState() {
    super.initState();

    controller = CamaraController();
    controller.iniciar();
  }

  // ========================================
  // LIBERAR CONTROLADOR
  // ========================================

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ========================================
  // REINICIAR TODO EL PROGRESO
  // ========================================

  Future<void> _reiniciarTodo() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text('¿Reiniciar todo?'),
          content: const Text(
            'Se borrará el progreso de las prácticas de fotografías '
                'y galería. También se eliminarán todas las fotos guardadas '
                'en este simulador.\n\n'
                'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reiniciar todo'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    await controller.reiniciarTodo();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todo el progreso se ha reiniciado.'),
      ),
    );
  }

  // ========================================
  // TARJETA DE CADA PRÁCTICA
  // ========================================

  Widget _tarjetaPractica({
    required String titulo,
    required String descripcion,
    required IconData icono,
    required String progreso,
    required VoidCallback onTap,
  }) {
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
                  color: azul.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icono,
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
                      titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      descripcion,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      progreso,
                      style: const TextStyle(
                        color: verde,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

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

  // ========================================
  // PANTALLA PRINCIPAL DEL SIMULADOR
  // ========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Práctica de cámara',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final estado = controller.estado;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Aprendamos a usar la cámara',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Practica tomando fotografías y administrándolas '
                    'desde la galería de tu teléfono.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // ===================================
              // PROGRESO GENERAL
              // ===================================

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.black87,
                          ),
                        ),

                        Text(
                          '${estado.progresoGeneral}%',
                          style: const TextStyle(
                            color: verde,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: estado.progresoGeneral / 100,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                          verde,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      estado.progresoGeneral == 100
                          ? '¡Has completado todas las prácticas!'
                          : 'Completa las dos prácticas para alcanzar el 100%.',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ===================================
              // PRÁCTICA 1: TOMAR FOTOGRAFÍAS
              // PROTEGIDA DEL MODO OSCURO
              // ===================================

              _tarjetaPractica(
                titulo: 'Tomar fotografías',
                descripcion: 'Aprende a tomar fotos y selfies.',
                icono: Icons.camera_alt_rounded,
                progreso:
                '${estado.progresoFotografias}/2 actividades completadas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TemaSimulador(
                        child: PracticaFotografiasView(
                          controller: controller,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // ===================================
              // PRÁCTICA 2: ADMINISTRAR FOTOGRAFÍAS
              // PROTEGIDA DEL MODO OSCURO
              // ===================================

              _tarjetaPractica(
                titulo: 'Administrar fotografías',
                descripcion: 'Visualiza, importa y elimina fotos.',
                icono: Icons.photo_library_rounded,
                progreso:
                '${estado.progresoGaleria}/4 actividades completadas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TemaSimulador(
                        child: PracticaGaleriaView(
                          controller: controller,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // ===================================
              // REINICIAR TODO EL MÓDULO
              // ===================================

              OutlinedButton.icon(
                onPressed: _reiniciarTodo,
                icon: const Icon(
                  Icons.restart_alt_rounded,
                ),
                label: const Text('Reiniciar todo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(
                    color: Colors.red.shade300,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
