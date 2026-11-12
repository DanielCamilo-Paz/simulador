
import 'package:flutter/material.dart';

import '../../controllers/calendario_controller.dart';
import '../compartido/tema_simulador.dart';

import 'practica_conocer_calendario_view.dart';
import 'practica_crear_evento_view.dart';
import 'practica_consultar_eventos_view.dart';
import 'practica_editar_eliminar_view.dart';

class PantallaCalendarioSim extends StatefulWidget {
  const PantallaCalendarioSim({super.key});

  @override
  State<PantallaCalendarioSim> createState() =>
      _PantallaCalendarioSimState();
}

class _PantallaCalendarioSimState
    extends State<PantallaCalendarioSim> {
  late final CalendarioController controller;

  // ========================================
  // COLORES DEL SIMULADOR
  // ========================================

  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  // ========================================
  // INICIALIZAR CONTROLADOR
  // ========================================

  @override
  void initState() {
    super.initState();

    controller = CalendarioController();
    controller.iniciar();
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
  // REINICIAR TODAS LAS PRÁCTICAS
  // ========================================

  Future<void> _reiniciarTodo() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text('¿Reiniciar todo?'),
          content: const Text(
            'Se borrará el progreso de las cuatro prácticas '
                'del calendario. También se eliminarán todos los '
                'eventos guardados en este simulador.\n\n'
                'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Reiniciar todo'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    await controller.reiniciarTodo();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Todo el progreso del calendario se ha reiniciado.',
        ),
      ),
    );
  }

  // ========================================
  // TARJETA REUTILIZABLE DE CADA PRÁCTICA
  // ========================================

  Widget _tarjetaPractica({
    required String titulo,
    required String descripcion,
    required IconData icono,
    required String progreso,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: azul.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icono,
                  color: const Color(0xFF496A79),
                  size: 30,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      descripcion,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      progreso,
                      style: const TextStyle(
                        color: verde,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: azul,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================
  // PRÁCTICA 1: CONOCER EL CALENDARIO
  // PROTEGIDA DEL MODO OSCURO
  // ========================================

  void _abrirConocerCalendario() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemaSimulador(
          child: PracticaConocerCalendarioView(
            controller: controller,
          ),
        ),
      ),
    );
  }

  // ========================================
  // PRÁCTICA 2: CREAR UN EVENTO
  // PROTEGIDA DEL MODO OSCURO
  // ========================================

  void _abrirCrearEvento() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemaSimulador(
          child: PracticaCrearEventoView(
            controller: controller,
          ),
        ),
      ),
    );
  }

  // ========================================
  // PRÁCTICA 3: CONSULTAR EVENTOS
  // PROTEGIDA DEL MODO OSCURO
  // ========================================

  void _abrirConsultarEventos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemaSimulador(
          child: PracticaConsultarEventosView(
            controller: controller,
          ),
        ),
      ),
    );
  }

  // ========================================
  // PRÁCTICA 4: EDITAR Y ELIMINAR EVENTOS
  // PROTEGIDA DEL MODO OSCURO
  // ========================================

  void _abrirEditarEliminar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemaSimulador(
          child: PracticaEditarEliminarView(
            controller: controller,
          ),
        ),
      ),
    );
  }

  // ========================================
  // PANTALLA PRINCIPAL DEL CALENDARIO
  // ========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Práctica de calendario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final estado = controller.estado;

          // ===================================
          // CARGANDO INFORMACIÓN
          // ===================================

          if (controller.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ===================================
              // ENCABEZADO
              // ===================================

              const Text(
                'Aprendamos a usar el calendario',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Practica consultando fechas, creando eventos '
                    'y organizando tus actividades desde el '
                    'calendario de tu teléfono.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // ===================================
              // PROGRESO GENERAL
              // ===================================

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progreso general',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),

                        Text(
                          '${estado.progresoGeneral}%',
                          style: const TextStyle(
                            color: verde,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: estado.progresoGeneral / 100,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                          verde,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      estado.progresoGeneral == 100
                          ? '¡Felicitaciones! Has completado '
                          'todas las prácticas del calendario.'
                          : 'Has completado '
                          '${estado.practicasCompletadas} '
                          'de 4 prácticas.',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ===================================
              // PRÁCTICA 1: CONOCER CALENDARIO
              // ===================================

              _tarjetaPractica(
                titulo: 'Conocer el calendario',
                descripcion:
                'Aprende a cambiar de mes y seleccionar fechas.',
                icono: Icons.calendar_month_rounded,
                progreso:
                '${estado.progresoConocer}/4 actividades completadas',
                onTap: _abrirConocerCalendario,
              ),

              const SizedBox(height: 14),

              // ===================================
              // PRÁCTICA 2: CREAR EVENTO
              // ===================================

              _tarjetaPractica(
                titulo: 'Crear un evento',
                descripcion:
                'Aprende a crear y guardar eventos.',
                icono: Icons.add_circle_outline_rounded,
                progreso:
                '${estado.progresoCrear}/1 actividad completada',
                onTap: _abrirCrearEvento,
              ),

              const SizedBox(height: 14),

              // ===================================
              // PRÁCTICA 3: CONSULTAR EVENTOS
              // ===================================

              _tarjetaPractica(
                titulo: 'Consultar eventos',
                descripcion:
                'Aprende a revisar tus eventos guardados.',
                icono: Icons.event_note_rounded,
                progreso:
                '${estado.progresoConsultar}/1 actividad completada',
                onTap: _abrirConsultarEventos,
              ),

              const SizedBox(height: 14),

              // ===================================
              // PRÁCTICA 4: EDITAR Y ELIMINAR
              // ===================================

              _tarjetaPractica(
                titulo: 'Editar y eliminar eventos',
                descripcion:
                'Aprende a modificar y eliminar eventos.',
                icono: Icons.edit_calendar_rounded,
                progreso:
                '${estado.progresoEditarEliminar}/2 actividades completadas',
                onTap: _abrirEditarEliminar,
              ),

              const SizedBox(height: 28),

              // ===================================
              // BOTÓN REINICIAR TODO
              // ===================================

              OutlinedButton.icon(
                onPressed: _reiniciarTodo,
                icon: const Icon(
                  Icons.restart_alt_rounded,
                ),
                label: const Text('Reiniciar todo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(
                    color: Colors.red.shade300,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
