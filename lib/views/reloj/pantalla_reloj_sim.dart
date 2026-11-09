import 'package:flutter/material.dart';

import '../../controllers/reloj_controller.dart';
import '../../controllers/progreso_controller.dart';
import 'practica_alarma_view.dart';
import 'practica_reloj_mundial_view.dart';
import 'practica_cronometro_view.dart';

class PantallaRelojSim extends StatefulWidget {
  final ProgresoController progresoController;

  const PantallaRelojSim({
    super.key,
    required this.progresoController,
  });

  @override
  State<PantallaRelojSim> createState() => _PantallaRelojSimState();
}

class _PantallaRelojSimState extends State<PantallaRelojSim> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  late final RelojController relojController;

  String practicaActual = 'menu';

  @override
  void initState() {
    super.initState();
    relojController = RelojController();
  }

  @override
  void dispose() {
    relojController.dispose();
    super.dispose();
  }

  void abrirPractica(String practica) {
    setState(() {
      practicaActual = practica;
    });
  }

  void volverMenu() {
    setState(() {
      practicaActual = 'menu';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: practicaActual == 'menu'
          ? AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        title: const Text(
          'Aprende a usar el reloj',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
          : null,
      body: _construirContenido(),
    );
  }

  Widget _construirContenido() {
    switch (practicaActual) {
      case 'alarmas':
        return PracticaAlarmaView(
          relojController: relojController,
          onCompletar:
          widget.progresoController.completarActividadReloj,
          onVolver: volverMenu,
        );

      case 'mundial':
        return PracticaRelojMundialView(
          onCompletar:
          widget.progresoController.completarActividadReloj,
          onVolver: volverMenu,
        );

      case 'cronometro':
        return PracticaCronometroView(
          relojController: relojController,
          onCompletar:
          widget.progresoController.completarActividadReloj,
          onVolver: volverMenu,
        );

      default:
        return _construirMenu();
    }
  }

  Widget _construirMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            '¡Vamos a aprender!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Practica las funciones principales de la aplicación del reloj.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 25),
          _tarjeta(
            icono: Icons.alarm,
            titulo: 'Alarmas',
            descripcion: 'Crea, edita y activa tus alarmas.',
            color: azul,
            onTap: () => abrirPractica('alarmas'),
          ),
          const SizedBox(height: 16),
          _tarjeta(
            icono: Icons.public,
            titulo: 'Reloj mundial',
            descripcion: 'Consulta la hora en diferentes ciudades.',
            color: verde,
            onTap: () => abrirPractica('mundial'),
          ),
          const SizedBox(height: 16),
          _tarjeta(
            icono: Icons.timer,
            titulo: 'Cronómetro',
            descripcion: 'Mide el tiempo y guarda tus vueltas.',
            color: Colors.deepPurple,
            onTap: () => abrirPractica('cronometro'),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta({
    required IconData icono,
    required String titulo,
    required String descripcion,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icono, color: color, size: 31),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      descripcion,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black45,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}