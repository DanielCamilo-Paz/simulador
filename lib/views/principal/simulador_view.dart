
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      Object icono,
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
    required Object icono,
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
            final escala = MediaQuery.textScalerOf(
              context,
            ).scale(1.0);

            final bool unaColumna =
                constraints.maxWidth < 340 ||
                    escala >= 1.3;

            final int columnas = unaColumna ? 1 : 2;

            final double alturaTarjeta = unaColumna
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
                // TELÉFONO
                // ===================================

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
                      icono: Icons.camera_alt_rounded,
                      pantalla: const DetalleCamaraView(),
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
                      icono: Icons.access_time_rounded,
                      pantalla: const DetalleRelojView(),
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
                      icono: Icons.calendar_month_rounded,
                      pantalla: const DetalleCalendarioView(),
                    );
                  },
                ),

                // ===================================
                // WHATSAPP
                // ===================================

                _tarjeta(
                  icono: FontAwesomeIcons.whatsapp,
                  titulo: 'WhatsApp',
                  onTap: () {
                    _abrirPractica(
                      nombre: 'WhatsApp',
                      descripcion:
                      'Aprende a enviar mensajes y compartir fotos',
                      icono: FontAwesomeIcons.whatsapp,
                      pantalla: const DetalleWhatsappView(),
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
    required Object icono,
    required String titulo,
    required VoidCallback onTap,
  }) {
    final colores = Theme.of(context).colorScheme;

    final Color colorPrincipal = colores.primary;
    final Color colorTexto = colores.onSurface;

    final Color colorTarjeta = Color.alphaBlend(
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
          color: colorPrincipal.withValues(alpha: 0.30),
          width: 1,
        ),
      ),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,
        splashColor: colorPrincipal.withValues(alpha: 0.15),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              // ===================================
              // ICONOS DE APLICACIONES DEL CELULAR
              // ===================================

              _iconoAplicacion(
                titulo,
                icono,
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

  // ========================================
  // DISEÑO PERSONALIZADO DE CADA APLICACIÓN
  // ========================================

  Widget _iconoAplicacion(
      String titulo,
      Object icono,
      ) {

    // ========================================
    // TELÉFONO
    // ========================================

    if (titulo == 'Realizar llamada') {
      return Container(
        width: 76,
        height: 76,

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF35D878),
              Color(0xFF159447),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF159447).withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: const Center(
          child: Icon(
            Icons.call,
            size: 43,
            color: Colors.white,
          ),
        ),
      );
    }

    // ========================================
    // CÁMARA
    // ========================================

    if (titulo == 'Cámara y galería') {
      return Container(
        width: 76,
        height: 76,

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF527CEB),
              Color(0xFF7048C9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF527CEB).withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 53,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Positioned(
                top: 14,
                left: 18,
                child: Container(
                  width: 16,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4770D9),
                  border: Border.all(
                    color: const Color(0xFF263E88),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB7D9FF),
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 14,
                top: 22,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFD66B),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ========================================
    // RELOJ
    // ========================================

    if (titulo == 'Reloj y alarmas') {
      return Container(
        width: 76,
        height: 76,

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF455A64),
              Color(0xFF263238),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF263238).withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Center(
          child: Container(
            width: 53,
            height: 53,

            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),

            child: Stack(
              alignment: Alignment.center,
              children: [

                // Manecilla de la hora
                Positioned(
                  top: 12,
                  child: Container(
                    width: 4,
                    height: 17,
                    decoration: BoxDecoration(
                      color: const Color(0xFF263238),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),

                // Manecilla de los minutos
                Positioned(
                  right: 12,
                  child: Container(
                    width: 17,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF263238),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),

                // Centro del reloj
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5A12A),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ========================================
    // CALENDARIO
    // ========================================

    if (titulo == 'Calendario') {
      return Container(
        width: 76,
        height: 76,

        padding: const EdgeInsets.all(9),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          children: [

            // Encabezado rojo
            Container(
              height: 17,
              width: double.infinity,

              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),

              child: const Center(
                child: Text(
                  'CAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            // Número del calendario
            // Número del calendario: fecha real del dispositivo
            Expanded(
              child: Center(
                child: Text(
                  DateTime.now().day.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ========================================
    // WHATSAPP
    // ========================================

    if (titulo == 'WhatsApp') {
      return Container(
        width: 76,
        height: 76,

        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF25D366).withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.whatsapp,
            size: 43,
            color: Colors.white,
          ),
        ),
      );
    }

    // Icono de respaldo
    return Container(
      width: 76,
      height: 76,

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(21),
      ),

      child: Center(
        child: Icon(
          icono is IconData ? icono : Icons.apps,
          size: 43,
          color: Colors.white,
        ),
      ),
    );
  }
}
