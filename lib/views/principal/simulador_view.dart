
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
  State<SimuladorView> createState() =>
      _SimuladorViewState();
}

class _SimuladorViewState extends State<SimuladorView> {
  // ========================================
  // CONTROLADOR COMPARTIDO
  // ========================================

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

  // ========================================
  // ABRIR PRÁCTICA Y NOTIFICAR A INICIO
  // ========================================

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

  // ========================================
  // INTERFAZ PRINCIPAL
  // ========================================

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    final Color fondo = tema.scaffoldBackgroundColor;
    final Color texto = colores.onSurface;

    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        foregroundColor: texto,
        iconTheme: IconThemeData(
          color: texto,
        ),
        title: Text(
          'Seleccionar práctica',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),
      ),

      // ========================================
      // CUADRÍCULA ADAPTABLE
      // ========================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // El tamaño de letra seleccionado
            // determina el espacio de las tarjetas.
            final escala = MediaQuery.textScalerOf(
              context,
            ).scale(1.0);

            // Si la letra es muy grande,
            // usamos una columna para evitar
            // que los textos se amontonen.
            final bool unaColumna =
                constraints.maxWidth < 340 ||
                    escala >= 1.3;

            final int columnas =
            unaColumna ? 1 : 2;

            final double alturaTarjeta =
            unaColumna
                ? 185 + (escala - 1.0) * 45
                : 205 + (escala - 1.0) * 65;

            return GridView(
              padding: const EdgeInsets.all(16),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnas,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: alturaTarjeta,
              ),
              children: [
                // ===================================
                // LLAMADAS
                // ===================================

                _tarjeta(
                  icono: Icons.phone,
                  titulo: 'Realizar llamada',
                  onTap: () {
                    _abrirPractica(
                      nombre: 'Realizar llamada',
                      descripcion:
                      'Haz una llamada a un contacto conocido',
                      icono:
                      Icons.phone_in_talk_rounded,
                      pantalla:
                      const DetallePracticaView(),
                    );
                  },
                ),

                // ===================================
                // CÁMARA Y GALERÍA
                // ===================================

                _tarjeta(
                  icono: Icons.camera_alt,
                  titulo: 'Cámara y galería',
                  onTap: () {
                    _abrirPractica(
                      nombre: 'Cámara y galería',
                      descripcion:
                      'Aprende a tomar fotos y administrar imágenes',
                      icono:
                      Icons.camera_alt_rounded,
                      pantalla:
                      const DetalleCamaraView(),
                    );
                  },
                ),

                // ===================================
                // RELOJ Y ALARMAS
                // ===================================

                _tarjeta(
                  icono: Icons.access_time,
                  titulo: 'Reloj y alarmas',
                  onTap: () {
                    _abrirPractica(
                      nombre: 'Reloj y alarmas',
                      descripcion:
                      'Aprende a utilizar el reloj y configurar alarmas',
                      icono:
                      Icons.access_time_rounded,
                      pantalla:
                      const DetalleRelojView(),
                    );
                  },
                ),

                // ===================================
                // CALENDARIO
                // ===================================

                _tarjeta(
                  icono: Icons.calendar_month,
                  titulo: 'Calendario',
                  onTap: () {
                    _abrirPractica(
                      nombre: 'Calendario',
                      descripcion:
                      'Aprende a organizar tus eventos y actividades',
                      icono:
                      Icons.calendar_month_rounded,
                      pantalla:
                      const DetalleCalendarioView(),
                    );
                  },
                ),

                // ===================================
                // WHATSAPP
                // ===================================

                _tarjeta(
                  icono: Icons.message,
                  titulo: 'WhatsApp',
                  onTap: () {
                    _abrirPractica(
                      nombre: 'WhatsApp',
                      descripcion:
                      'Aprende a enviar mensajes y compartir fotos',
                      icono: Icons.message_rounded,
                      pantalla:
                      const DetalleWhatsappView(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ========================================
  // TARJETAS DE LAS PRÁCTICAS
  // ========================================

  Widget _tarjeta({
    required IconData icono,
    required String titulo,
    required VoidCallback onTap,
  }) {
    final colores = Theme.of(context).colorScheme;

    final Color colorPrincipal = colores.primary;
    final Color colorTexto = colores.onSurface;
    final Color colorIcono = colores.onPrimary;

    final Color colorTarjeta =
    Color.alphaBlend(
      colorPrincipal.withValues(alpha: 0.13),
      colores.surface,
    );

    return Card(
      color: colorTarjeta,
      elevation: 0,
      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: colorPrincipal.withValues(
            alpha: 0.30,
          ),
          width: 1,
        ),
      ),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,
        splashColor: colorPrincipal.withValues(
          alpha: 0.15,
        ),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              // ===================================
              // ICONO
              // ===================================

              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: colorPrincipal,
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Icon(
                  icono,
                  size: 43,
                  color: colorIcono,
                ),
              ),

              const SizedBox(height: 14),

              // ===================================
              // NOMBRE DE LA PRÁCTICA
              // ===================================

              Text(
                titulo,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: colorTexto,
                ),
              ),

              const SizedBox(height: 8),

              // ===================================
              // FLECHA
              // ===================================

              Icon(
                Icons.arrow_forward_ios,
                size: 19,
                color: colorPrincipal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
