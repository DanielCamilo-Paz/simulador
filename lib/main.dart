
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/principal/splash_view.dart';

import 'controllers/camara_controller.dart';
import 'controllers/reloj_controller.dart';
import 'controllers/calendario_controller.dart';
import 'controllers/whatsapp_controller.dart';
import 'controllers/configuracion_controller.dart';
import 'controllers/progreso_general_controller.dart';

// ========================================
// CONTROLADORES GLOBALES DE SAFETAP
// ========================================

final configuracionController = ConfiguracionController();

final progresoGeneralController = ProgresoGeneralController();

// ========================================
// FUNCIÓN PRINCIPAL
// ========================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ========================================
  // CLAVE PÚBLICA DE SUPABASE
  // ========================================

  const String claveSupabase =
      'sb_publishable_s9OQWShr5dhtJE1gvxRYbw_2A9vwWkB';

  if (claveSupabase.isEmpty) {
    throw StateError(
      'No se encontró la clave pública de Supabase.',
    );
  }

  // ========================================
  // INICIALIZAR SUPABASE
  // ========================================

  try {
    await Supabase.initialize(
      url: 'https://gfseruqmpcoyxbjbgczn.supabase.co',
      anonKey: claveSupabase,
    );

    debugPrint('Supabase inicializado correctamente.');
  } catch (e) {
    debugPrint('Error al inicializar Supabase: $e');
    rethrow;
  }

  // ========================================
  // CARGAR CONFIGURACIÓN GUARDADA
  // ========================================

  try {
    await configuracionController.cargarConfiguracion();

    debugPrint('Configuración de SafeTap cargada.');
  } catch (e) {
    debugPrint('Error al cargar configuración: $e');
  }

  // ========================================
  // CARGAR PROGRESO GUARDADO
  // ========================================

  await cargarProgresoGeneral();

  // ========================================
  // INICIAR SAFETAP
  // ========================================

  runApp(const MiApp());
}

// ========================================
// CARGAR PROGRESO GENERAL
// ========================================

Future<void> cargarProgresoGeneral() async {
  // ========================================
  // CÁMARA Y GALERÍA
  // ========================================

  final camaraController = CamaraController();

  try {
    await camaraController.cargarProgreso();

    debugPrint('Progreso de Cámara cargado.');
  } catch (e) {
    debugPrint('Error al cargar progreso de Cámara: $e');
  } finally {
    camaraController.dispose();
  }

  // ========================================
  // RELOJ Y ALARMAS
  // ========================================

  final relojController = RelojController();

  try {
    await relojController.iniciarProgreso();

    debugPrint('Progreso de Reloj cargado.');
  } catch (e) {
    debugPrint('Error al cargar progreso de Reloj: $e');
  } finally {
    relojController.dispose();
  }

  // ========================================
  // CALENDARIO
  // ========================================

  final calendarioController = CalendarioController();

  try {
    await calendarioController.cargarDatos();

    debugPrint('Progreso de Calendario cargado.');
  } catch (e) {
    debugPrint('Error al cargar progreso de Calendario: $e');
  } finally {
    calendarioController.dispose();
  }

  // ========================================
  // WHATSAPP
  // ========================================

  final whatsappController = WhatsappController();

  try {
    await whatsappController.cargarProgreso();

    debugPrint('Progreso de WhatsApp cargado.');
  } catch (e) {
    debugPrint('Error al cargar progreso de WhatsApp: $e');
  } finally {
    whatsappController.dispose();
  }

  debugPrint('Carga inicial del progreso finalizada.');
}

// ========================================
// APLICACIÓN PRINCIPAL SAFETAP
// ========================================

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: configuracionController,
      builder: (context, child) {
        final color = configuracionController.colorPrincipal;
        final escala = configuracionController.escalaTexto;

        return MaterialApp(
          title: 'SafeTap',
          debugShowCheckedModeBanner: false,

          // ========================================
          // TEMA CLARO
          // ========================================

          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor:
            const Color(0xFFEFF6FF),
            colorScheme: ColorScheme.fromSeed(
              seedColor: color,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFEFF6FF),
              foregroundColor: Color(0xFF333333),
            ),
          ),

          // ========================================
          // TEMA OSCURO
          // ========================================

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor:
            const Color(0xFF121826),
            colorScheme: ColorScheme.fromSeed(
              seedColor: color,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121826),
              foregroundColor: Colors.white,
            ),
          ),

          // ========================================
          // MODO ACTUAL
          // ========================================

          themeMode: configuracionController.modoTema,

          // ========================================
          // TAMAÑO DE LETRA GLOBAL
          // ========================================

          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(escala),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },

          home: const SplashView(),
        );
      },
    );
  }
}
