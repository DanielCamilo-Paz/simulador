
import 'package:flutter/material.dart';

import 'views/principal/inicio_view.dart';

import 'controllers/camara_controller.dart';
import 'controllers/reloj_controller.dart';
import 'controllers/calendario_controller.dart';
import 'controllers/whatsapp_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // CARGAR EL PROGRESO GUARDADO
  // ANTES DE MOSTRAR LA APLICACIÓN
  await cargarProgresoGeneral();

  runApp(const MiApp());
}

Future<void> cargarProgresoGeneral() async {
  // CÁMARA Y GALERÍA
  final camaraController = CamaraController();

  try {
    await camaraController.cargarProgreso();
  } catch (e) {
    debugPrint('Error al cargar progreso de Cámara: $e');
  } finally {
    camaraController.dispose();
  }

  // RELOJ Y ALARMAS
  final relojController = RelojController();

  try {
    await relojController.iniciarProgreso();
  } catch (e) {
    debugPrint('Error al cargar progreso de Reloj: $e');
  } finally {
    relojController.dispose();
  }

  // CALENDARIO
  final calendarioController = CalendarioController();

  try {
    await calendarioController.cargarDatos();
  } catch (e) {
    debugPrint('Error al cargar progreso de Calendario: $e');
  } finally {
    calendarioController.dispose();
  }

  // WHATSAPP
  final whatsappController = WhatsappController();

  try {
    await whatsappController.cargarProgreso();
  } catch (e) {
    debugPrint('Error al cargar progreso de WhatsApp: $e');
  } finally {
    whatsappController.dispose();
  }
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador Celular',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F9D8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF77F11),
        ),
        useMaterial3: true,
      ),
      home: const InicioView(),
    );
  }
}
