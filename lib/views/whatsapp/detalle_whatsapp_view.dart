
import 'package:flutter/material.dart';

import '../../controllers/whatsapp_controller.dart';
import 'pantalla_whatsapp_sim.dart';
import '../compartido/tema_simulador.dart';

class DetalleWhatsappView extends StatefulWidget {
  const DetalleWhatsappView({super.key});

  @override
  State<DetalleWhatsappView> createState() =>
      _DetalleWhatsappViewState();
}

class _DetalleWhatsappViewState
    extends State<DetalleWhatsappView> {

  // ========================================
  // CONTROLADOR DE WHATSAPP
  // ========================================

  late final WhatsappController controller;

  // ========================================
  // INICIALIZAR CONTROLADOR Y PROGRESO
  // ========================================

  @override
  void initState() {
    super.initState();

    controller = WhatsappController();
    controller.cargarProgreso();
  }

  // ========================================
  // LIBERAR CONTROLADOR
  // ========================================

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ========================================
  // ABRIR SIMULADOR DE WHATSAPP
  // CON TEMA CLARO INDEPENDIENTE
  // ========================================

  void _abrirPractica() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemaSimulador(
          child: PantallaWhatsappSim(
            controller: controller,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // ========================================
    // COLORES DINÁMICOS DEL TEMA SELECCIONADO
    // ========================================

    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    final Color fondo = tema.scaffoldBackgroundColor;
    final Color colorPrincipal = colores.primary;
    final Color colorSobrePrincipal = colores.onPrimary;
    final Color colorTexto = colores.onSurface;
    final Color colorSecundario = colores.onSurfaceVariant;
    final Color colorTarjeta = colores.surface;

    // Color suave basado en el color elegido.
    final Color colorSuave =
    colorPrincipal.withValues(alpha: 0.15);

    return Scaffold(
      backgroundColor: fondo,

      // ========================================
      // BARRA SUPERIOR
      // ========================================

      appBar: AppBar(
        title: Text(
          'Realizar práctica',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorTexto,
          ),
        ),
        backgroundColor: fondo,
        foregroundColor: colorTexto,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 10),

              // ===================================
              // ICONO PRINCIPAL
              // ===================================

              Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  color: colorPrincipal,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.chat_rounded,
                  size: 75,
                  color: colorSobrePrincipal,
                ),
              ),

              const SizedBox(height: 22),

              // ===================================
              // TÍTULO
              // ===================================

              Text(
                'WhatsApp',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorTexto,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // ===================================
              // DESCRIPCIÓN
              // ===================================

              Text(
                'Aprende a utilizar WhatsApp de manera sencilla. '
                    'Practica cómo enviar mensajes, compartir audios y fotos, '
                    'realizar llamadas, publicar estados y buscar contactos.',
                style: TextStyle(
                  fontSize: 16,
                  color: colorSecundario,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 26),

              // ===================================
              // INFORMACIÓN DE LA PRÁCTICA
              // ===================================

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: colorSuave,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _dato(
                        Icons.access_time_rounded,
                        'Duración',
                        '20 minutos',
                        colorPrincipal,
                        colorTexto,
                        colorSecundario,
                        colorTarjeta,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _dato(
                        Icons.trending_up_rounded,
                        'Nivel',
                        'Fácil',
                        colorPrincipal,
                        colorTexto,
                        colorSecundario,
                        colorTarjeta,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // ===================================
              // BOTÓN PRINCIPAL
              // ===================================

              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrincipal,
                    foregroundColor: colorSobrePrincipal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),

                  onPressed: _abrirPractica,

                  child: Text(
                    'Aprender a usar WhatsApp',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: colorSobrePrincipal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================
  // INFORMACIÓN DE DURACIÓN Y NIVEL
  // ========================================

  Widget _dato(
      IconData icono,
      String etiqueta,
      String valor,
      Color colorPrincipal,
      Color colorTexto,
      Color colorSecundario,
      Color colorTarjeta,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colorTarjeta,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icono,
            size: 32,
            color: colorPrincipal,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          etiqueta,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: colorTexto,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          valor,
          style: TextStyle(
            color: colorSecundario,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
