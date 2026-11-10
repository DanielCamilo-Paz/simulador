
import 'package:flutter/material.dart';

import '../../controllers/progreso_controller.dart';

import '../llamada/detalle_practica_llamada_view.dart';
import '../camara/detalle_camara_view.dart';
import '../reloj/detalle_reloj_view.dart';
import '../calendario/detalle_calendario_view.dart';
import '../whatsapp/detalle_whatsapp_view.dart';

class SimuladorView extends StatefulWidget {
  final Function(
      String nombre,
      String descripcion,
      IconData icono,
      Widget pantalla,
      )? onSeleccionarPractica;

  const SimuladorView({
    super.key,
    this.onSeleccionarPractica,
  });

  @override
  State<SimuladorView> createState() => _SimuladorViewState();
}

class _SimuladorViewState extends State<SimuladorView> {
  // PALETA DE COLORES PRINCIPAL
  static const Color fondo = Color(0xFFF6F9D8);
  static const Color naranja = Color(0xFFF77F11);
  static const Color texto = Color(0xFF333333);
  static const Color blanco = Colors.white;

  static const Color colorTarjeta = Color(0xFFFFE5C7);
  static const Color colorIcono = Color(0xFFF77F11);

  // CONTROLADOR COMPARTIDO
  late final ProgresoController progresoController;

  @override
  void initState() {
    super.initState();
    progresoController = ProgresoController();
  }

  @override
  void dispose() {
    progresoController.dispose();
    super.dispose();
  }

  // ABRIR PRÁCTICA Y NOTIFICAR A INICIO
  void _abrirPractica({
    required String nombre,
    required String descripcion,
    required IconData icono,
    required Widget pantalla,
  }) {
    widget.onSeleccionarPractica?.call(
      nombre,
      descripcion,
      icono,
      pantalla,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => pantalla,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: texto,
        ),
        title: const Text(
          'Seleccionar práctica',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: texto,
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
          // LLAMADAS
          _tarjeta(
            icono: Icons.phone,
            titulo: 'Realizar llamada',
            onTap: () {
              _abrirPractica(
                nombre: 'Realizar llamada',
                descripcion:
                'Haz una llamada a un contacto conocido',
                icono: Icons.phone_in_talk_rounded,
                pantalla: const DetallePracticaView(),
              );
            },
          ),

          // CÁMARA
          _tarjeta(
            icono: Icons.camera_alt,
            titulo: 'Cámara y galería',
            onTap: () {
              _abrirPractica(
                nombre: 'Cámara y galería',
                descripcion:
                'Aprende a tomar fotos y administrar imágenes',
                icono: Icons.camera_alt_rounded,
                pantalla: const DetalleCamaraView(),
              );
            },
          ),
// RELOJ
          _tarjeta(
            icono: Icons.access_time,
            titulo: 'Reloj y alarmas',
            onTap: () {
              _abrirPractica(
                nombre: 'Reloj y alarmas',
                descripcion:
                'Aprende a utilizar el reloj y configurar alarmas',
                icono: Icons.access_time_rounded,
                pantalla: const DetalleRelojView(),
              );
            },
          ),

          // CALENDARIO
          _tarjeta(
            icono: Icons.calendar_month,
            titulo: 'Calendario',
            onTap: () {
              _abrirPractica(
                nombre: 'Calendario',
                descripcion:
                'Aprende a organizar tus eventos y actividades',
                icono: Icons.calendar_month_rounded,
                pantalla: const DetalleCalendarioView(),
              );
            },
          ),

          // WHATSAPP
          _tarjeta(
            icono: Icons.message,
            titulo: 'WhatsApp',
            onTap: () {
              _abrirPractica(
                nombre: 'WhatsApp',
                descripcion:
                'Aprende a enviar mensajes y compartir fotos',
                icono: Icons.message_rounded,
                pantalla: const DetalleWhatsappView(),
              );
            },
          ),
        ],
      ),
    );
  }

  // TARJETAS DE LAS PRÁCTICAS
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
        side: BorderSide(
          color: naranja.withOpacity(0.25),
          width: 1,
        ),
      ),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,
        splashColor: naranja.withOpacity(0.15),

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
                  color: blanco,
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
                  color: texto,
                ),
              ),

              const SizedBox(height: 8),

              const Icon(
                Icons.arrow_forward_ios,
                size: 19,
                color: naranja,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
