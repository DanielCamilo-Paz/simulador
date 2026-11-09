import 'package:flutter/material.dart';

import '../../controllers/reloj_controller.dart';

class PracticaCronometroView extends StatefulWidget {
  final RelojController relojController;
  final Function(String) onCompletar;
  final VoidCallback onVolver;

  const PracticaCronometroView({
    super.key,
    required this.relojController,
    required this.onCompletar,
    required this.onVolver,
  });

  @override
  State<PracticaCronometroView> createState() =>
      _PracticaCronometroViewState();
}

class _PracticaCronometroViewState
    extends State<PracticaCronometroView> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  RelojController get controller => widget.relojController;

  bool _guiaIniciada = false;
  bool _iniciado = false;
  bool _pausado = false;
  bool _vueltaGuardada = false;
  bool _reiniciado = false;
  bool _finalizado = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_guiaIniciada) {
        _guiaIniciada = true;
        _mostrarBienvenida();
      }
    });
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
      titulo: '¡Vamos a usar el cronómetro!',
      contenido:
      'En esta práctica aprenderás a medir el tiempo, '
          'pausar el cronómetro, guardar vueltas y reiniciarlo.\n\n'
          'Primero vamos a ponerlo en marcha.',
      icono: Icons.timer_rounded,
    );

    if (mounted) await _mostrarPasoActual();
  }

  Future<void> _mostrarPasoActual() async {
    if (!mounted) return;

    if (!_iniciado) {
      await _mensaje(
        titulo: 'Paso 1: iniciar',
        contenido:
        'Presiona el botón verde «Iniciar» para comenzar '
            'a medir el tiempo.',
        icono: Icons.play_circle_fill_rounded,
      );
    } else if (!_pausado) {
      await _mensaje(
        titulo: 'Paso 2: pausar',
        contenido:
        '¡El cronómetro está funcionando!\n\n'
            'Presiona «Pausar» para detenerlo temporalmente.',
        icono: Icons.pause_circle_filled_rounded,
      );
    } else if (!_vueltaGuardada) {
      await _mensaje(
        titulo: 'Paso 3: guardar una vuelta',
        contenido:
        'Ahora que el cronómetro está pausado, '
            'presiona «Guardar vuelta» para conservar el tiempo '
            'que has medido.',
        icono: Icons.flag_rounded,
      );
    } else if (!_reiniciado) {
      await _mensaje(
        titulo: 'Paso 4: reiniciar',
        contenido:
        '¡Muy bien! Ya guardaste una vuelta.\n\n'
            'Presiona «Reiniciar» para devolver el cronómetro '
            'a cero y borrar las vueltas de esta práctica.',
        icono: Icons.restart_alt_rounded,
      );
    } else if (!_finalizado) {
      _finalizado = true;
      widget.onCompletar('iniciar_cronometro');

      await _mensaje(
        titulo: '¡Práctica completada!',
        contenido:
        'Aprendiste a iniciar, pausar, guardar vueltas '
            'y reiniciar el cronómetro.',
        textoBoton: 'Finalizar',
        icono: Icons.check_circle_rounded,
      );
    }
  }

  Future<void> _mostrarAyuda() async {
    await _mostrarPasoActual();
  }

  Future<void> _iniciar() async {
    controller.iniciarCronometro();

    if (!_iniciado) {
      setState(() => _iniciado = true);
      widget.onCompletar('iniciar_cronometro');
      await _mostrarPasoActual();
    }
  }

  Future<void> _pausar() async {
    controller.pausarCronometro();

    if (!_pausado) {
      setState(() => _pausado = true);
      await _mostrarPasoActual();
    }
  }

  Future<void> _guardarVuelta() async {
    if (controller.tiempoTranscurrido.inMilliseconds <= 0) return;

    controller.guardarVuelta();

    if (!_vueltaGuardada) {
      setState(() => _vueltaGuardada = true);
      widget.onCompletar('guardar_vuelta');
      await _mostrarPasoActual();
    }
  }

  Future<void> _reiniciar() async {
    controller.reiniciarCronometro();

    if (!_reiniciado) {
      setState(() => _reiniciado = true);
      widget.onCompletar('reiniciar_cronometro');
      await _mostrarPasoActual();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Cronómetro',
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
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Row(
                children: [
                  Icon(Icons.timer_rounded, color: verde),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Mide el tiempo',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 35,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: azul,
                      size: 48,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      controller.cronometro.tiempo,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.estaEnMarcha
                          ? 'Cronómetro en marcha'
                          : 'Cronómetro detenido',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _botonAccion(
                    icono: controller.estaEnMarcha
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    texto: controller.estaEnMarcha
                        ? 'Pausar'
                        : 'Iniciar',
                    color: verde,
                    onTap: controller.estaEnMarcha
                        ? _pausar
                        : _iniciar,
                  ),
                  _botonAccion(
                    icono: Icons.flag_rounded,
                    texto: 'Guardar vuelta',
                    color: azul,
                    onTap: controller.estaEnMarcha ||
                        controller.tiempoTranscurrido.inMilliseconds > 0
                        ? _guardarVuelta
                        : null,
                  ),
                  _botonAccion(
                    icono: Icons.restart_alt_rounded,
                    texto: 'Reiniciar',
                    color: Colors.deepPurple,
                    onTap: controller.tiempoTranscurrido.inMilliseconds > 0
                        ? _reiniciar
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.flag_rounded, color: verde),
                        SizedBox(width: 9),
                        Text(
                          'Vueltas guardadas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (controller.cronometro.vueltas.isEmpty)
                      const Text(
                        'Todavía no has guardado ninguna vuelta.',
                        style: TextStyle(color: Colors.black54),
                      )
                    else
                      ...List.generate(
                        controller.cronometro.vueltas.length,
                            (indice) {
                          final vuelta =
                          controller.cronometro.vueltas[indice];

                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: azul.withOpacity(0.18),
                              child: Text('${indice + 1}'),
                            ),
                            title: Text('Vuelta ${indice + 1}'),
                            trailing: Text(
                              vuelta,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _botonAccion({
    required IconData icono,
    required String texto,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Column(
      children: [
        IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icono),
          iconSize: 28,
          style: IconButton.styleFrom(
            backgroundColor: color.withOpacity(0.16),
            foregroundColor: color,
            disabledBackgroundColor: Colors.black12,
            disabledForegroundColor: Colors.black26,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 95,
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}