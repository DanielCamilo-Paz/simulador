
import 'package:flutter/material.dart';

import '../../controllers/reloj_controller.dart';

import 'practica_alarma_view.dart';
import 'practica_reloj_mundial_view.dart';
import 'practica_cronometro_view.dart';

class PantallaRelojSim extends StatefulWidget {
  const PantallaRelojSim({super.key});

  @override
  State<PantallaRelojSim> createState() =>
      _PantallaRelojSimState();
}

class _PantallaRelojSimState extends State<PantallaRelojSim> {
  late final RelojController relojController;

  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  String practicaActual = 'menu';

  @override
  void initState() {
    super.initState();

    relojController = RelojController();
    relojController.iniciarProgreso();
  }

  @override
  void dispose() {
    relojController.dispose();
    super.dispose();
  }

  // ABRIR UNA PRÁCTICA
  void abrirPractica(String practica) {
    setState(() {
      practicaActual = practica;
    });
  }

  // REGRESAR AL MENÚ
  void volverMenu() {
    setState(() {
      practicaActual = 'menu';
    });
  }

  // REINICIAR TODAS LAS PRÁCTICAS
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
            'Se borrará el progreso de las tres prácticas '
                'del reloj: Alarmas, Reloj mundial y Cronómetro.\n\n'
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

    await relojController.reiniciarProgreso();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Todo el progreso del reloj se ha reiniciado.',
        ),
      ),
    );
  }

  // TARJETA REUTILIZABLE DE CADA PRÁCTICA
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
                  color: azul.withValues(alpha: 0.18),
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

  // PANTALLA DE CADA PRÁCTICA
  Widget _construirContenido() {
    switch (practicaActual) {
      case 'alarmas':
        return PracticaAlarmaView(
          relojController: relojController,
          onVolver: volverMenu,
        );

      case 'mundial':
        return PracticaRelojMundialView(
          relojController: relojController,
          onVolver: volverMenu,
        );

      case 'cronometro':
        return PracticaCronometroView(
          relojController: relojController,
          onVolver: volverMenu,
        );

      default:
        return _construirMenu();
    }
  }

  // PANTALLA PRINCIPAL
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: relojController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: fondo,

          appBar: practicaActual == 'menu'
              ? AppBar(
            backgroundColor: azul,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Práctica de reloj',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          )
              : null,

          body: relojController.cargandoProgreso
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : _construirContenido(),
        );
      },
    );
  }

  // MENÚ DE LAS TRES PRÁCTICAS
  Widget _construirMenu() {
    final progresoGeneral =
    relojController.porcentajeGeneral.round();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ENCABEZADO
        const Text(
          'Aprendamos a usar el reloj',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Practica creando alarmas, consultando la hora '
              'de diferentes ciudades y utilizando el '
              'cronómetro de tu teléfono.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 24),

        // PROGRESO GENERAL
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
                    ),
                  ),

                  Text(
                    '$progresoGeneral%',
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
                  value: relojController.porcentajeGeneral / 100,
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
                progresoGeneral == 100
                    ? '¡Felicitaciones! Has completado '
                    'todas las prácticas del reloj.'
                    : 'Has completado '
                    '${relojController.practicasCompletadas} '
                    'de 3 prácticas.',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // PRÁCTICA 1: ALARMAS
        _tarjetaPractica(
          titulo: 'Alarmas',
          descripcion:
          'Aprende a crear, editar, activar y eliminar alarmas.',
          icono: Icons.alarm_rounded,
          progreso:
          '${relojController.actividadesRealizadas('alarmas')}/'
              '${relojController.totalActividades('alarmas')} '
              'actividades completadas',
          onTap: () => abrirPractica('alarmas'),
        ),

        const SizedBox(height: 14),

        // PRÁCTICA 2: RELOJ MUNDIAL
        _tarjetaPractica(
          titulo: 'Reloj mundial',
          descripcion:
          'Aprende a consultar la hora en otras ciudades.',
          icono: Icons.public_rounded,
          progreso:
          '${relojController.actividadesRealizadas('mundial')}/'
              '${relojController.totalActividades('mundial')} '
              'actividades completadas',
          onTap: () => abrirPractica('mundial'),
        ),

        const SizedBox(height: 14),

        // PRÁCTICA 3: CRONÓMETRO
        _tarjetaPractica(
          titulo: 'Cronómetro',
          descripcion:
          'Aprende a medir el tiempo y guardar vueltas.',
          icono: Icons.timer_rounded,
          progreso:
          '${relojController.actividadesRealizadas('cronometro')}/'
              '${relojController.totalActividades('cronometro')} '
              'actividades completadas',
          onTap: () => abrirPractica('cronometro'),
        ),

        const SizedBox(height: 28),

        // BOTÓN REINICIAR TODO
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
            padding:
            const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
