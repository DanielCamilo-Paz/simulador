
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
  // PALETA PRINCIPAL
  static const Color fondo = Color(0xFFF8F8E8);
  static const Color naranja = Color(0xFFF4A261);
  static const Color naranjaSuave = Color(0xFFF6DCC0);
  static const Color texto = Color(0xFF333333);
  static const Color blanco = Colors.white;

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
        foregroundColor: texto,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 10),

            // ICONO PRINCIPAL
            Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                color: naranja,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.chat_rounded,
                size: 75,
                color: blanco,
              ),
            ),

            const SizedBox(height: 22),

            // TITULO
            const Text(
              'WhatsApp',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // DESCRIPCION
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

            const SizedBox(height: 26),

            // INFORMACION DE LA PRACTICA
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

            const SizedBox(height: 35),

            // BOTON PRINCIPAL
            SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: naranja,
                  foregroundColor: blanco,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _abrirPractica,
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
      ),
    );
  }

  // DATOS DE LA PRACTICA
  Widget _dato(
      IconData icono,
      String etiqueta,
      String valor,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: blanco,
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