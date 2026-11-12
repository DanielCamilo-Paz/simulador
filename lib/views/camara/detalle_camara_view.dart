
import 'package:flutter/material.dart';

import 'pantalla_camara_sim.dart';
import '../compartido/tema_simulador.dart';

class DetalleCamaraView extends StatelessWidget {
  const DetalleCamaraView({super.key});

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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colorTexto,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // ===================================
              // ICONO PRINCIPAL
              // ===================================

              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: colorPrincipal,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 90,
                  color: colorSobrePrincipal,
                ),
              ),

              const SizedBox(height: 24),

              // ===================================
              // TÍTULO DE LA PRÁCTICA
              // ===================================

              Text(
                'Tomar fotos y videos',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: colorTexto,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // ===================================
              // DESCRIPCIÓN
              // ===================================

              Text(
                'Aprende a usar la cámara para tomar fotos '
                    'y grabar videos.',
                style: TextStyle(
                  fontSize: 16,
                  color: colorSecundario,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

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
                        '7 minutos',
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
                        'Medio',
                        colorPrincipal,
                        colorTexto,
                        colorSecundario,
                        colorTarjeta,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ===================================
              // BOTÓN COMENZAR LECCIÓN
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

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TemaSimulador(
                          child: PantallaCamaraSim(),
                        ),
                      ),
                    );
                  },

                  child: Text(
                    'Comenzar lección',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: colorSobrePrincipal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ===================================
              // BOTÓN REGRESAR A PRÁCTICAS
              // ===================================

              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 25,
                  ),
                  label: const Text(
                    'Regresar a prácticas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorPrincipal,
                    side: BorderSide(
                      color: colorPrincipal,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================
  // INFORMACIÓN: DURACIÓN Y NIVEL
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
