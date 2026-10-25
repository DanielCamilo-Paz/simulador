import 'package:flutter/material.dart';
import 'pantalla_llamada_sim.dart';

class DetallePracticaView extends StatelessWidget {
  const DetallePracticaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Practica'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 130,
              height: 130,
              color: Colors.grey[300],
              child: const Icon(Icons.phone, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'Realizar Llamada\ntelefonica',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Aprende a hacer una llamada telefonica al contacto que tu desees',
              style: TextStyle(fontSize: 15, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _dato(Icons.access_time, 'Duracion', '5 minutos'),
                _dato(Icons.trending_up, 'Nivel', 'Facil'),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaLlamadaSim()),
                  );
                },
                child: const Text('Comenzar Leccion', style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dato(IconData icono, String etiqueta, String valor) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          color: Colors.grey[300],
          child: Icon(icono, size: 30, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(valor, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}