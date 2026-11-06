
import 'package:flutter/material.dart';

import '../../controllers/progreso_controller.dart';
import '../reloj/pantalla_reloj_sim.dart';
import '../reloj/progreso_reloj_view.dart';

class DetalleRelojView extends StatelessWidget {
  final ProgresoController progresoController;

  const DetalleRelojView({
    super.key,
    required this.progresoController,
  });

  static const Color azulFondo = Color(0xFFBECCD2);
  static const Color azulIcono = Color(0xFF92AFBC);

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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // ICONO PRINCIPAL
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: azulIcono,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.watch_later_rounded,
                  size: 90,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // TÍTULO
              const Text(
                'Reloj, Alarmas y Cronómetro',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // DESCRIPCIÓN
              const Text(
                'Aprende a ver la hora actual, crear y editar alarmas. '
                    'Conoce la hora de otras ciudades del mundo y usa el cronómetro.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // INFORMACIÓN DE LA PRÁCTICA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
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
                      '10 minutos',
                    ),
                    _dato(
                      Icons.trending_up_rounded,
                      'Nivel',
                      'Fácil',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CONSULTAR PROGRESO
              SizedBox(
                width: double.infinity,
                height: 62,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProgresoRelojView(
                          progresoController: progresoController,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.trending_up_rounded,
                    size: 27,
                  ),
                  label: const Text(
                    'Consultar mi progreso',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF405F6D),
                    side: const BorderSide(
                      color: azulIcono,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // COMENZAR LECCIÓN
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PantallaRelojSim(
                          progresoController: progresoController,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Comenzar lección',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
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
            color: Colors.white.withValues(alpha: 0.75),
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
