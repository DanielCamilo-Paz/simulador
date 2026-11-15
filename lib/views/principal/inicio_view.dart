
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart' hide progresoGeneralController;
import '../../controllers/progreso_general_controller.dart';

import '../usuario/perfil_view.dart';
import '../principal/simulador_view.dart';
import '../progreso/progreso_general_view.dart';
import '../configuracion/configuracion_view.dart';

// ========================================
// PANTALLA PRINCIPAL DE SAFETAP
// ========================================

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {

  // ========================================
  // COLORES DINÁMICOS
  // ========================================

  Color get naranja => configuracionController.colorPrincipal;

  Color get amarillo => configuracionController.colorPrincipal;

  Color get fondo => Theme.of(context).scaffoldBackgroundColor;

  Color get texto => Theme.of(context).colorScheme.onSurface;

  Color get blanco => Colors.white;

  // ========================================
  // ESCALA DE DISEÑO
  // ========================================

  double get escalaDiseno {
    return configuracionController.escalaTexto
        .clamp(0.85, 1.4)
        .toDouble();
  }

  // ========================================
  // DATOS DEL USUARIO
  // ========================================

  String nombreUsuario = 'Usuario';

  @override
  void initState() {
    super.initState();
    _cargarNombreUsuario();
  }

  Future<void> _cargarNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      final nombre = prefs.getString('usuario_nombre')?.trim();

      nombreUsuario = (nombre == null || nombre.isEmpty)
          ? 'Usuario'
          : nombre;
    });
  }

  // ========================================
  // ABRIR PERFIL
  // ========================================

  Future<void> _abrirPerfil() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PerfilView(
          progresoController: progresoGeneralController,
          configuracionController: configuracionController,
        ),
      ),
    );

    if (!mounted) return;

    await _cargarNombreUsuario();
  }

  // ========================================
  // ABRIR CONFIGURACIÓN
  // ========================================

  Future<void> _abrirConfiguracion() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfiguracionView(
          controller: configuracionController,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // ========================================
  // ÚLTIMA SIMULACIÓN SELECCIONADA
  // ========================================

  String ultimaLeccion = 'Realizar llamada';

  String descripcionLeccion =
      'Haz una llamada a un contacto conocido';

  // Object permite recibir IconData y FaIconData.
  Object iconoLeccion = Icons.phone_in_talk_rounded;

  Widget? ultimaPantalla;

  // ========================================
  // ACTUALIZAR ÚLTIMA PRÁCTICA
  // ========================================

  void _actualizarUltimaLeccion(
      String nombre,
      String descripcion,
      Object icono,
      Widget pantalla,
      ) {
    setState(() {
      ultimaLeccion = nombre;
      descripcionLeccion = descripcion;
      iconoLeccion = icono;
      ultimaPantalla = pantalla;
    });
  }

  // ========================================
  // ABRIR MENÚ DE LECCIONES
  // ========================================

  Future<void> _abrirLecciones() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SimuladorView(
          onSeleccionarPractica: _actualizarUltimaLeccion,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // ========================================
  // CONTINUAR ÚLTIMA LECCIÓN
  // ========================================

  Future<void> _continuarLeccion() async {
    if (ultimaPantalla == null) {
      await _abrirLecciones();
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ultimaPantalla!,
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // ========================================
  // ABRIR PROGRESO GENERAL
  // ========================================

  void _abrirProgresoGeneral() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgresoGeneralView(
          controller: progresoGeneralController,
        ),
      ),
    );
  }

  // ========================================
  // INTERFAZ PRINCIPAL
  // ========================================

  @override
  Widget build(BuildContext context) {
    final double escala = escalaDiseno;

    return Scaffold(
      backgroundColor: fondo,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20 * escala),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // ===================================
              // ENCABEZADO
              // ===================================

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SafeTap',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: texto,
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: amarillo,
                      borderRadius: BorderRadius.circular(13),
                    ),

                    child: IconButton(
                      tooltip: 'Abrir configuración',
                      onPressed: _abrirConfiguracion,

                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 27 * escala,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30 * escala),

              // ===================================
              // SALUDO PERSONALIZADO
              // ===================================

              Text(
                '¡Hola, $nombreUsuario!',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: texto,
                ),
              ),

              SizedBox(height: 28 * escala),

              // ===================================
              // SECCIÓN PRINCIPAL
              // ===================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: _tarjetaContinuar(),
                  ),

                  SizedBox(width: 13 * escala),

                  Expanded(
                    child: _tarjetaProgreso(),
                  ),
                ],
              ),

              SizedBox(height: 28 * escala),

              // ===================================
              // OPCIONES PRINCIPALES
              // ===================================

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 13 * escala,
                mainAxisSpacing: 13 * escala,

                // Las tarjetas aumentan su altura
                // conforme aumenta el tamaño de letra.
                childAspectRatio: 1.25 / escala,

                children: [

                  // LECCIONES

                  _tarjetaOpcion(
                    icono: Icons.menu_book_rounded,
                    titulo: 'Lecciones',
                    onTap: _abrirLecciones,
                  ),

                  // ACTIVIDADES DE REPASO

                  _tarjetaOpcion(
                    icono: Icons.extension_rounded,
                    titulo: 'Actividades de repaso',
                  ),

                  // PROGRESO

                  _tarjetaOpcion(
                    icono: Icons.pie_chart_rounded,
                    titulo: 'Progreso',
                    onTap: _abrirProgresoGeneral,
                  ),

                  // PERFIL

                  _tarjetaOpcion(
                    icono: Icons.person_outline_rounded,
                    titulo: 'Mi perfil',
                    onTap: _abrirPerfil,
                  ),
                ],
              ),

              SizedBox(height: 20 * escala),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================
  // TARJETA SIGUE CON TU LECCIÓN
  // ========================================

  Widget _tarjetaContinuar() {
    final double escala = escalaDiseno;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _continuarLeccion,

      child: Container(
        height: 270 * escala,
        padding: EdgeInsets.all(11 * escala),

        decoration: BoxDecoration(
          color: naranja.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: naranja.withValues(alpha: 0.35),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            // TÍTULO

            Text(
              'Sigue con tu lección',
              textAlign: TextAlign.center,
              softWrap: true,

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
            ),

            // ICONO DE LA ÚLTIMA LECCIÓN

            Flexible(
              child: FittedBox(
                fit: BoxFit.contain,

                child: iconoLeccion is IconData
                    ? Icon(
                  iconoLeccion as IconData,
                  size: 100 * escala,
                  color: naranja,
                )
                    : FaIcon(
                  iconoLeccion as FaIconData,
                  size: 100 * escala,
                  color: const Color(0xFF25D366),
                ),
              ),
            ),

            // DESCRIPCIÓN

            Text(
              descripcionLeccion,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: 13,
                color: texto,
              ),
            ),

            // BOTÓN DE ÚLTIMA LECCIÓN

            Container(
              width: double.infinity,

              padding: EdgeInsets.symmetric(
                vertical: 11 * escala,
                horizontal: 5 * escala,
              ),

              decoration: BoxDecoration(
                color: naranja,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Text(
                ultimaLeccion,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: blanco,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // TARJETA DE PROGRESO GENERAL
  // ========================================

  Widget _tarjetaProgreso() {
    final double escala = escalaDiseno;

    return AnimatedBuilder(
      animation: progresoGeneralController,

      builder: (context, child) {
        final progreso =
        progresoGeneralController.obtenerProgresoGeneral();

        final double porcentaje = progreso.porcentajeGeneral
            .clamp(0.0, 100.0)
            .toDouble();

        final int porcentajeTexto = porcentaje.round();

        final int leccionesCompletadas =
            progresoGeneralController.totalLeccionesCompletadas;

        final int totalLecciones =
            progresoGeneralController.totalLecciones;

        return Container(
          height: 250 * escala,

          padding: EdgeInsets.symmetric(
            horizontal: 5 * escala,
            vertical: 5 * escala,
          ),

          child: LayoutBuilder(
            builder: (context, constraints) {
              final double tamanoCirculo =
              (constraints.maxWidth * 0.82)
                  .clamp(65.0, 130.0)
                  .toDouble();

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [

                  // TÍTULO

                  Text(
                    'Tu progreso General',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                      color: texto,
                    ),
                  ),

                  // INDICADOR CIRCULAR

                  SizedBox(
                    width: tamanoCirculo,
                    height: tamanoCirculo,

                    child: Stack(
                      alignment: Alignment.center,

                      children: [
                        Transform.rotate(
                          angle: 1.57,

                          child: SizedBox.expand(
                            child: CircularProgressIndicator(
                              value: porcentaje / 100,
                              strokeWidth: 11 * escala,
                              strokeCap: StrokeCap.round,

                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,

                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                naranja,
                              ),
                            ),
                          ),
                        ),

                        // PORCENTAJE CENTRAL

                        Padding(
                          padding: EdgeInsets.all(8 * escala),

                          child: FittedBox(
                            fit: BoxFit.scaleDown,

                            child: Text(
                              '$porcentajeTexto%',

                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: texto,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // LECCIONES REALIZADAS

                  Text(
                    'Has realizado $leccionesCompletadas de '
                        '$totalLecciones lecciones',

                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 11,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                      color: texto,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // ========================================
  // TARJETAS DEL MENÚ
  // ========================================

  Widget _tarjetaOpcion({
    required IconData icono,
    required String titulo,
    VoidCallback? onTap,
  }) {
    final double escala = escalaDiseno;

    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8 * escala,
          vertical: 10 * escala,
        ),

        decoration: BoxDecoration(
          color: naranja.withValues(alpha: 0.17),
          borderRadius: BorderRadius.circular(19),

          border: Border.all(
            color: naranja.withValues(alpha: 0.30),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // ICONOS ADAPTABLES

            Flexible(
              flex: 5,

              child: Padding(
                padding: EdgeInsets.all(3 * escala),

                child: FittedBox(
                  fit: BoxFit.contain,

                  child: Icon(
                    icono,
                    size: 50 * escala,
                    color: naranja,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10 * escala),

            // TEXTOS ADAPTABLES

            Flexible(
              flex: 4,

              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5 * escala,
                ),

                child: Center(
                  child: Text(
                    titulo,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 13.9,
                      fontWeight: FontWeight.bold,
                      color: texto,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
