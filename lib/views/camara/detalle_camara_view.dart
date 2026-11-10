import 'package:flutter/material.dart';
import 'pantalla_camara_sim.dart'; // ← Tu pantalla real de cámara

class DetalleCamaraView extends StatelessWidget {
  const DetalleCamaraView({super.key});

  // PALETA PRINCIPAL
  static const Color fondo = Color(0xFFF8F8E8);
  static const Color naranja = Color(0xFFF4A261);
  static const Color naranjaSuave = Color(0xFFF6DCC0);
  static const Color texto = Color(0xFF333333);
  static const Color blanco = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        title: const Text(
          'Realizar práctica',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),
        backgroundColor: fondo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: texto,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // Icono principal
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: naranja,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 90,
                color: blanco,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Tomar fotos y videos',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: texto,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            const Text(
              'Aprende a usar la cámara para tomar fotos y grabar videos. ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Información de la práctica
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: naranjaSuave,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _dato(
                    Icons.access_time_rounded,
                    'Duración',
                    '7 minutos',
                  ),
                  _dato(
                    Icons.trending_up_rounded,
                    'Nivel',
                    'Medio',
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Botón para empezar
            SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: naranja,
                  foregroundColor: texto,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PantallaCamaraSim(),
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
            color: blanco.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icono,
            size: 32,
            color: naranja,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          etiqueta,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: texto,
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