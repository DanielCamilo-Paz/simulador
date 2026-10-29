import 'package:flutter/material.dart';
import 'pantalla_llamada_sim.dart';
import 'pantalla_camara_sim.dart';
import 'pantalla_recordatorio_sim.dart';
import 'pantalla_galeria_sim.dart';

class SimuladorView extends StatelessWidget {
  const SimuladorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text(
          'Seleccionar practica',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF7F9FA),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Funciones basicas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          //  Realizar Llamada
          _tarjeta(
            icono: Icons.phone,
            titulo: 'Realizar Llamada telefonica',
            desc: 'Aprende a realizar una llamada a algun contacto cercano',
            colorIcono: const Color(0xFF92AFBC),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaLlamadaSim()),
              );
            },
          ),
          const SizedBox(height: 12),

          //  Realizar Foto o Video
          _tarjeta(
            icono: Icons.camera_alt,
            titulo: 'Realizar Foto o Video',
            desc: 'Aprende a realizar una foto o a un video, aprendiendo lo basico en opciones de camara',
            colorIcono: const Color(0xFF92AFBC),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaCamaraSim()),
              );
            },
          ),
          const SizedBox(height: 12),

          // Colocar Recordatorio
          _tarjeta(
            icono: Icons.access_time,
            titulo: 'Colocar recordatorio',
            desc: 'Aprende a colocar un recordatorio en la fecha y hora que gustes, personalizando nombre y tono',
            colorIcono: const Color(0xFF92AFBC),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaRecordatorioSim()),
              );
            },
          ),
          const SizedBox(height: 12),

          // Editar, Eliminar Foto — AHORA FUNCIONA
          _tarjeta(
            icono: Icons.photo_library,
            titulo: 'Editar, Eliminar Foto',
            desc: 'Aprende a entrar a galeria para asi mirar tus fotos y poder decidir si eliminarlas o editarlas a tu gusto',
            colorIcono: const Color(0xFF92AFBC),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaGaleriaSim()),
              );
            },
          ),
          const SizedBox(height: 24),

          const Text(
            'Apps de mensajeria',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ⏳ WhatsApp
          _tarjeta(
            icono: Icons.message,
            titulo: 'Enviar mensaje whatsapp',
            desc: 'Aprende a realizar un mensaje por la aplicacion de whatsapp para asi poder hablar con tus seres cercanos',
            colorIcono: const Color(0xFF92AFBC),
            onTap: () => _proximamente(context),
          ),
        ],
      ),
    );
  }

  void _proximamente(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Próximamente: disponible pronto')),
    );
  }

  Widget _tarjeta({
    required IconData icono,
    required String titulo,
    required String desc,
    required Color colorIcono,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFFBECCD2),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: colorIcono,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icono, size: 40, color: Colors.white),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(desc, style: const TextStyle(fontSize: 14)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 25),
        onTap: onTap,
      ),
    );
  }
}