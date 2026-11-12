
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

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

  Color get naranja =>
      configuracionController.colorPrincipal;

  Color get amarillo =>
      configuracionController.colorPrincipal;

  Color get fondo =>
      Theme.of(context).scaffoldBackgroundColor;

  Color get texto =>
      Theme.of(context).colorScheme.onSurface;

  Color get blanco => Colors.white;

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
      final nombre =
      prefs.getString('usuario_nombre')?.trim();

      nombreUsuario =
      (nombre == null || nombre.isEmpty)
          ? 'Usuario'
          : nombre;
    });
  }

  // ========================================
  // ABRIR PERFIL
  // ========================================
  // CORRECCIÓN DEL ERROR DE COMPILACIÓN
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

  IconData iconoLeccion =
      Icons.phone_in_talk_rounded;

  Widget? ultimaPantalla;

  // ========================================
  // ACTUALIZAR ÚLTIMA PRÁCTICA
  // ========================================

  void _actualizarUltimaLeccion(
      String nombre,
      String descripcion,
      IconData icono,
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
          onSeleccionarPractica:
          _actualizarUltimaLeccion,
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
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ===================================
              // ENCABEZADO
              // ===================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
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
                      borderRadius:
                      BorderRadius.circular(13),
                    ),
                    child: IconButton(
                      tooltip: 'Abrir configuración',
                      onPressed: _abrirConfiguracion,
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

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

              const SizedBox(height: 28),

              // ===================================
              // SECCIÓN PRINCIPAL
              // ===================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: _tarjetaContinuar(),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    flex: 5,
                    child: _tarjetaProgreso(),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ===================================
              // OPCIONES PRINCIPALES
              // ===================================

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 13,
                mainAxisSpacing: 13,
                childAspectRatio: 1.25,
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

              const SizedBox(height: 20),
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
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _continuarLeccion,
      child: Container(
        height: 270,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: naranja.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: naranja.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sigue con tu lección',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
            ),

            Icon(
              iconoLeccion,
              size: 100,
              color: naranja,
            ),

            Text(
              descripcionLeccion,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: texto,
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: naranja,
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Text(
                ultimaLeccion,
                textAlign: TextAlign.center,
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
    return AnimatedBuilder(
      animation: progresoGeneralController,
      builder: (context, child) {
        final progreso =
        progresoGeneralController
            .obtenerProgresoGeneral();

        final double porcentaje =
        progreso.porcentajeGeneral.clamp(
          0.0,
          100.0,
        );

        final int porcentajeTexto =
        porcentaje.round();

        final int leccionesCompletadas =
            progresoGeneralController
                .totalLeccionesCompletadas;

        final int totalLecciones =
            progresoGeneralController
                .totalLecciones;

        return Container(
          height: 250,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 0,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double tamanoCirculo =
              (constraints.maxWidth * 0.88)
                  .clamp(65.0, 135.0);

              return Column(
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [
                  // TÍTULO
                  Text(
                    'Tu progreso General',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 2.5,
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
                            child:
                            CircularProgressIndicator(
                              value: porcentaje / 100,
                              strokeWidth: 15,
                              strokeCap:
                              StrokeCap.round,
                              backgroundColor:
                              Theme.of(context)
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
                        FittedBox(
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
                      ],
                    ),
                  ),

                  // LECCIONES REALIZADAS
                  Text(
                    'Has realizado $leccionesCompletadas de '
                        '$totalLecciones lecciones',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.9,
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
    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: naranja.withValues(alpha: 0.17),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: naranja.withValues(alpha: 0.30),
          ),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              size: 50,
              color: naranja,
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.9,
                  fontWeight: FontWeight.bold,
                  color: texto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
