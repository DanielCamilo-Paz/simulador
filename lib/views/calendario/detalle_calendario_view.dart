
import 'package:flutter/material.dart';

import 'pantalla_calendario_sim.dart';
import '../compartido/tema_simulador.dart';

class DetalleCalendarioView extends StatelessWidget {
  const DetalleCalendarioView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ========================================
    // COLORES DINÁMICOS DEL TEMA SELECCIONADO
    // ========================================

    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    final Color fondo = tema.scaffoldBackgroundColor;
    final Color colorPrincipal = colores.primary;
    final Color colorTexto = colores.onSurface;
    final Color colorSecundario = colores.onSurfaceVariant;
    final Color colorTarjeta = colores.surface;
    final Color colorSobrePrincipal = colores.onPrimary;

    // Color suave que se adapta al tema.
    final Color colorSuave =
    colorPrincipal.withOpacity(0.15);

    return Scaffold(
      backgroundColor: fondo,

      // ========================================
      // BARRA SUPERIOR
      // ========================================

      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        foregroundColor: colorTexto,
        title: const Text(
          'Realizar práctica',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 25),

              // ===================================
              // ICONO DEL CALENDARIO
              // ===================================

              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: colorSuave,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.calendar_month,
                  size: 85,
                  color: colorPrincipal,
                ),
              ),

              const SizedBox(height: 28),

              // ===================================
              // TÍTULO
              // ===================================

              Text(
                'Colocar recordatorio en calendario',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorTexto,
                ),
              ),

              const SizedBox(height: 14),

              // ===================================
              // DESCRIPCIÓN
              // ===================================

              Text(
                'Aprende a visualizar el calendario del mes. '
                    'Selecciona el día y la hora para poner un '
                    'recordatorio con el evento que tú quieras recordar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: colorSecundario,
                ),
              ),

              const SizedBox(height: 30),

              // ===================================
              // TARJETA DE DURACIÓN Y NIVEL
              // ===================================

              Card(
                color: colorTarjeta,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 22,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _dato(
                          Icons.access_time,
                          'Duración',
                          '6 minutos',
                          colorPrincipal,
                          colorTexto,
                          colorSecundario,
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 60,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        color: colores.outlineVariant,
                      ),

                      Expanded(
                        child: _dato(
                          Icons.signal_cellular_alt,
                          'Nivel',
                          'Fácil',
                          colorPrincipal,
                          colorTexto,
                          colorSecundario,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ===================================
              // BOTÓN COMENZAR LECCIÓN
              // ===================================

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TemaSimulador(
                          child: PantallaCalendarioSim(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrincipal,
                    foregroundColor: colorSobrePrincipal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
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
                      borderRadius: BorderRadius.circular(16),
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
      String titulo,
      String valor,
      Color colorPrincipal,
      Color colorTexto,
      Color colorSecundario,
      ) {
    return Column(
      children: [
        Icon(
          icono,
          color: colorPrincipal,
          size: 30,
        ),

        const SizedBox(height: 8),

        Text(
          titulo,
          style: TextStyle(
            color: colorSecundario,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          valor,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: colorTexto,
          ),
        ),
      ],
    );
  }
}
