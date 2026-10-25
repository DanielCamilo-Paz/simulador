import 'package:flutter/material.dart';
import 'detalle_practica_view.dart';

class SimuladorView extends StatelessWidget {
  const SimuladorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar practica')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Funciones basicas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ✅ Realizar Llamada
          _tarjeta(
            icono: Icons.phone,
            titulo: 'Realizar Llamada telefonica',
            desc: 'Aprende a realizar una llamada a algun contacto cercano',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DetallePracticaView()),
              );
            },
          ),
          const SizedBox(height: 12),

          // ✅ Realizar Foto o Video
          _tarjeta(
            icono: Icons.camera_alt,
            titulo: 'Realizar Foto o Video',
            desc: 'Aprende a realizar una foto o a un video, aprendiendo lo basico en opciones de camara',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: disponible pronto')),
              );
            },
          ),
          const SizedBox(height: 12),

          // ✅ Colocar recordatorio
          _tarjeta(
            icono: Icons.access_time,
            titulo: 'Colocar recordatorio',
            desc: 'Aprende a colocar un recordatorio en la fecha y hora que gustes, personalizando nombre y tono',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: disponible pronto')),
              );
            },
          ),
          const SizedBox(height: 12),

          // ✅ Editar, Eliminar Foto
          _tarjeta(
            icono: Icons.photo_library,
            titulo: 'Editar, Eliminar Foto',
            desc: 'Aprende a entrar a galeria para asi mirar tus fotos y poder decidir si eliminarlas o editarlas a tu gusto',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: disponible pronto')),
              );
            },
          ),
          const SizedBox(height: 24),

          const Text(
            'Apps de mensajeria',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ✅ Enviar mensaje WhatsApp
          _tarjeta(
            icono: Icons.message,
            titulo: 'Enviar mensaje whatsapp',
            desc: 'Aprende a realizar un mensaje por la aplicacion de whatsapp para asi poder hablar con tus seres cercanos',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: disponible pronto')),
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
    required String desc,
    required VoidCallback onTap,
  }) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Icon(icono, size: 34, color: Colors.black54),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}