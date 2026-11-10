
import 'dart:async';

import 'package:flutter/material.dart';

import '../../controllers/reloj_controller.dart';

class PracticaRelojMundialView extends StatefulWidget {
  final RelojController relojController;
  final VoidCallback onVolver;

  const PracticaRelojMundialView({
    super.key,
    required this.relojController,
    required this.onVolver,
  });

  @override
  State<PracticaRelojMundialView> createState() =>
      _PracticaRelojMundialViewState();
}

class _PracticaRelojMundialViewState
    extends State<PracticaRelojMundialView> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  final Set<String> _ciudadesVisitadas = {};
  Timer? _temporizador;

  bool _guiaIniciada = false;
  bool _finalizada = false;

  RelojController get controller => widget.relojController;

  final List<_Ciudad> _ciudades = const [
    _Ciudad(
      nombre: 'Bogotá',
      pais: 'Colombia',
      diferenciaUtc: -5,
      icono: Icons.location_city_rounded,
    ),
    _Ciudad(
      nombre: 'Madrid',
      pais: 'España',
      diferenciaUtc: 1,
      icono: Icons.account_balance_rounded,
    ),
    _Ciudad(
      nombre: 'Nueva York',
      pais: 'Estados Unidos',
      diferenciaUtc: -5,
      icono: Icons.apartment_rounded,
    ),
    _Ciudad(
      nombre: 'Tokio',
      pais: 'Japón',
      diferenciaUtc: 9,
      icono: Icons.temple_buddhist_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _temporizador = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_guiaIniciada) {
        _guiaIniciada = true;
        _mostrarBienvenida();
      }
    });
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  Future<void> _mensaje({
    required String titulo,
    required String contenido,
    String textoBoton = 'Continuar',
    IconData icono = Icons.info_outline_rounded,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Icon(icono, color: azul, size: 38),
          title: Text(
            titulo,
            textAlign: TextAlign.center,
          ),
          content: Text(
            contenido,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(textoBoton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarBienvenida() async {
    await _mensaje(
      titulo: '¡Vamos a conocer el mundo!',
      contenido:
      'En esta práctica aprenderás a consultar la hora '
          'de diferentes ciudades.\n\n'
          'Comenzaremos observando la hora de Bogotá.',
      icono: Icons.public_rounded,
    );

    if (mounted) {
      await _mostrarPasoActual();
    }
  }

  Future<void> _mostrarPasoActual() async {
    if (!mounted) return;

    final pendientes = _ciudades
        .where(
          (ciudad) =>
      !_ciudadesVisitadas.contains(ciudad.nombre),
    )
        .toList();

    if (pendientes.isEmpty) {
      if (!_finalizada) {
        _finalizada = true;

        await controller.completarActividad(
          'consultar_ciudad',
        );

        if (!mounted) return;

        await _mensaje(
          titulo: '¡Práctica completada!',
          contenido:
          'Consultaste la hora de Bogotá, Madrid, Nueva York '
              'y Tokio. ¡Ya sabes utilizar el reloj mundial!\n\n'
              'Tu progreso en Reloj mundial es del 100%.',
          textoBoton: 'Finalizar',
          icono: Icons.check_circle_rounded,
        );
      }
      return;
    }

    final ciudad = pendientes.first;

    await _mensaje(
      titulo: 'Consulta ${ciudad.nombre}',
      contenido:
      'Toca la tarjeta de ${ciudad.nombre} para consultar '
          'la hora de esa ciudad y conocer su ubicación.',
      icono: Icons.public_rounded,
    );
  }

  Future<void> _mostrarAyuda() async {
    await _mostrarPasoActual();
  }

  Future<void> _consultarCiudad(_Ciudad ciudad) async {
    if (_ciudadesVisitadas.contains(ciudad.nombre)) {
      await _mensaje(
        titulo: ciudad.nombre,
        contenido:
        'Esta ciudad ya fue consultada. Puedes volver a tocar '
            'su tarjeta para observar nuevamente la hora.',
        icono: Icons.access_time_rounded,
      );
      return;
    }

    setState(() {
      _ciudadesVisitadas.add(ciudad.nombre);
    });

    if (_ciudadesVisitadas.length == _ciudades.length) {
      await _mostrarPasoActual();
    } else {
      final siguiente = _ciudades.firstWhere(
            (elemento) =>
        !_ciudadesVisitadas.contains(elemento.nombre),
      );

      await _mensaje(
        titulo: '¡Bien hecho!',
        contenido:
        'Ya consultaste la hora de ${ciudad.nombre}.\n\n'
            'Ahora busca y toca la tarjeta de ${siguiente.nombre}.',
        icono: Icons.check_circle_rounded,
      );
    }
  }

  DateTime _horaCiudad(int diferenciaUtc) {
    return DateTime.now().toUtc().add(
      Duration(hours: diferenciaUtc),
    );
  }

  String _formatearHora(DateTime fecha) {
    return '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')}:'
        '${fecha.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progresoCompletado =
    controller.actividadCompletada('consultar_ciudad');

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onVolver,
        ),
        title: const Text(
          'Reloj mundial',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Recordar el paso',
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: _mostrarAyuda,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // PROGRESO GUARDADO
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mi progreso en Reloj mundial',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${controller.porcentajePractica('mundial').round()}%',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: verde,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value:
                  controller.porcentajePractica('mundial') / 100,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.black12,
                  color: verde,
                ),
                const SizedBox(height: 10),
                Text(
                  progresoCompletado
                      ? '¡Práctica completada!'
                      : 'Consulta las cuatro ciudades para completar la práctica.',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Icon(Icons.public_rounded, color: verde),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Hora en otras ciudades',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${_ciudadesVisitadas.length}/4',
                style: const TextStyle(
                  color: verde,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ..._ciudades.map((ciudad) {
            final visitada =
            _ciudadesVisitadas.contains(ciudad.nombre);

            final hora = _horaCiudad(ciudad.diferenciaUtc);

            return Container(
              margin: const EdgeInsets.only(bottom: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: visitada
                    ? Border.all(color: verde, width: 1.5)
                    : null,
              ),
              child: InkWell(
                onTap: () => _consultarCiudad(ciudad),
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: azul.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          ciudad.icono,
                          color: azul,
                          size: 29,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ciudad.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              ciudad.pais,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            if (visitada)
                              const Text(
                                'Ciudad consultada',
                                style: TextStyle(
                                  color: verde,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatearHora(hora),
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (visitada)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: verde,
                              size: 19,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: verde,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ciudades consultadas en esta sesión: '
                        '${_ciudadesVisitadas.length} de 4',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Ciudad {
  final String nombre;
  final String pais;
  final int diferenciaUtc;
  final IconData icono;

  const _Ciudad({
    required this.nombre,
    required this.pais,
    required this.diferenciaUtc,
    required this.icono,
  });
}
