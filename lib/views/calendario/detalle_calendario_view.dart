
import 'package:flutter/material.dart';

import '../../controllers/progreso_controller.dart';
import 'pantalla_calendario_sim.dart';
import 'progreso_calendario_view.dart';

class DetalleCalendarioView extends StatelessWidget {
  final ProgresoController progresoController;

  const DetalleCalendarioView({
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
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Realizar práctica',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 25),

              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: azulFondo,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  size: 85,
                  color: azulIcono,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Colocar recordatorio en calendario',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Aprende a visualizar el calendario del mes. '
                    'Selecciona el día y la hora para poner un '
                    'recordatorio con el evento que tú quieras recordar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _dato(
                          Icons.access_time,
                          'Duración',
                          '6 minutos',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 55,
                        color: Colors.black12,
                      ),
                      Expanded(
                        child: _dato(
                          Icons.signal_cellular_alt,
                          'Nivel',
                          'Fácil',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: azulIcono,
                    side: const BorderSide(
                      color: azulIcono,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(
                    Icons.trending_up_rounded,
                    size: 25,
                  ),
                  label: const Text(
                    'Consultar mi progreso',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProgresoCalendarioView(
                          progresoController: progresoController,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azulIcono,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PantallaCalendarioSim(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _dato(IconData icono, String titulo, String valor) {
    return Column(
      children: [
        Icon(
          icono,
          color: azulIcono,
          size: 30,
        ),
        const SizedBox(height: 8),
        Text(
          titulo,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          valor,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
