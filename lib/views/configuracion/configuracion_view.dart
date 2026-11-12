
import 'package:flutter/material.dart';

import '../../controllers/configuracion_controller.dart';
import '../../models/configuracion/configuracion_model.dart';

class ConfiguracionView extends StatelessWidget {
  final ConfiguracionController controller;

  const ConfiguracionView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final color = controller.colorPrincipal;
        final oscuro = controller.modoOscuro;
        final fondo = Theme.of(context).scaffoldBackgroundColor;

        return Scaffold(
          backgroundColor: fondo,
          appBar: AppBar(
            backgroundColor: fondo,
            title: const Text(
              'Configuración',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ===================================
                // TAMAÑO DE LETRA
                // ===================================

                _seccion(
                  context,
                  titulo: 'Tamaño de letra',
                  icono: Icons.text_fields_rounded,
                  color: color,
                  contenido: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecciona el tamaño que te resulte '
                            'más cómodo para leer.',
                      ),
                      const SizedBox(height: 16),

                      ...ConfiguracionModel
                          .tamanosLetra.entries.map((opcion) {
                        return RadioListTile<double>(
                          title: Text(opcion.key),
                          value: opcion.value,
                          groupValue: controller.escalaTexto,
                          activeColor: color,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (valor) {
                            if (valor != null) {
                              controller.cambiarTamanoLetra(valor);
                            }
                          },
                        );
                      }),

                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Bienvenido a SafeTap',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===================================
                // MODO CLARO Y OSCURO
                // ===================================

                _seccion(
                  context,
                  titulo: 'Apariencia',
                  icono: Icons.brightness_6_rounded,
                  color: color,
                  contenido: Column(
                    children: [
                      SwitchListTile(
                        title: const Text(
                          'Modo oscuro',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          oscuro
                              ? 'Activado'
                              : 'Desactivado',
                        ),
                        secondary: Icon(
                          oscuro
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: color,
                        ),
                        value: oscuro,
                        activeColor: color,
                        contentPadding: EdgeInsets.zero,
                        onChanged: controller.cambiarModoTema,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===================================
                // PALETA DE COLORES
                // ===================================

                _seccion(
                  context,
                  titulo: 'Colores de la aplicación',
                  icono: Icons.palette_rounded,
                  color: color,
                  contenido: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Elige el color que más te guste.',
                      ),

                      const SizedBox(height: 18),

                      Wrap(
                        spacing: 14,
                        runSpacing: 18,
                        alignment: WrapAlignment.center,
                        children: ConfiguracionModel
                            .coloresDisponibles.entries
                            .map((opcion) {
                          final seleccionado =
                              color.value == opcion.value.value;

                          return InkWell(
                            borderRadius:
                            BorderRadius.circular(16),
                            onTap: () {
                              controller.cambiarColor(
                                opcion.value,
                              );
                            },
                            child: SizedBox(
                              width: 78,
                              child: Column(
                                children: [
                                  Container(
                                    width: 62,
                                    height: 62,
                                    decoration: BoxDecoration(
                                      color: opcion.value,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: seleccionado
                                            ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                    child: seleccionado
                                        ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    opcion.key,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ===================================
                // RESTABLECER CONFIGURACIÓN
                // ===================================

                OutlinedButton.icon(
                  onPressed: () async {
                    final confirmar =
                    await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text(
                            'Restablecer configuración',
                          ),
                          content: const Text(
                            '¿Quieres volver al tamaño '
                                'de letra, colores y apariencia '
                                'originales de SafeTap?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(
                                    dialogContext,
                                    false,
                                  ),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.pop(
                                    dialogContext,
                                    true,
                                  ),
                              child: const Text(
                                'Restablecer',
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmar == true) {
                      await controller
                          .restablecerConfiguracion();
                    }
                  },
                  icon: const Icon(
                    Icons.restart_alt_rounded,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    child: Text(
                      'RESTABLECER CONFIGURACIÓN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ===================================
                // REGRESAR
                // ===================================

                SizedBox(
                  height: 58,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                    ),
                    label: const Text(
                      'REGRESAR AL INICIO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ========================================
  // TARJETAS DE CONFIGURACIÓN
  // ========================================

  Widget _seccion(
      BuildContext context, {
        required String titulo,
        required IconData icono,
        required Color color,
        required Widget contenido,
      }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 29),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          contenido,
        ],
      ),
    );
  }
}
