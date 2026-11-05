
import 'package:flutter/material.dart';

import 'detalle_practica_llamada_view.dart';
import 'detalle_camara_view.dart';
import 'detalle_reloj_view.dart';
import 'detalle_galeria_view.dart';
import 'detalle_calendario_view.dart';
import 'detalle_whatsapp_view.dart';
import 'pantalla_whatsapp_sim.dart';

class SimuladorView extends StatelessWidget {
  const SimuladorView({super.key});

  static const Color fondo = Color(0xFFF7F9FA);
  static const Color colorTarjeta = Color(0xFFBECCD2);
  static const Color colorIcono = Color(0xFF92AFBC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        title: const Text(
          'Seleccionar práctica',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.95,
        children: [
          _tarjeta(
            icono: Icons.phone,
            titulo: 'Realizar llamada',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DetallePracticaView(),
                ),
              );
            },
          ),

          _tarjeta(
            icono: Icons.camera_alt,
            titulo: 'Cámara',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DetalleCamaraView(),
                ),
              );
            },
          ),

          _tarjeta(
            icono: Icons.access_time,
            titulo: 'Reloj y alarmas',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DetalleRelojView(),
                ),
              );
            },
          ),

          _tarjeta(
            icono: Icons.photo_library,
            titulo: 'Galería de fotos',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DetalleGaleriaView(),
                ),
              );
            },
          ),

          _tarjeta(
            icono: Icons.calendar_month,
            titulo: 'Calendario',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DetalleCalendarioView(),
                ),
              );
            },
          ),

          _tarjeta(
            icono: Icons.message,
            titulo: 'WhatsApp',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DetalleWhatsappView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tarjeta({
    required IconData icono,
    required String titulo,
    required VoidCallback onTap,
  }) {
    return Card(
      color: colorTarjeta,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: colorIcono,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icono,
                  size: 43,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              const Icon(
                Icons.arrow_forward_ios,
                size: 19,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
