import 'package:flutter/material.dart';

import '../../controllers/reloj_controller.dart';
import '../../models/reloj/alarma_model.dart';

class PracticaAlarmaView extends StatefulWidget {
  final RelojController relojController;
  final Function(String) onCompletar;
  final VoidCallback onVolver;

  const PracticaAlarmaView({
    super.key,
    required this.relojController,
    required this.onCompletar,
    required this.onVolver,
  });

  @override
  State<PracticaAlarmaView> createState() =>
      _PracticaAlarmaViewState();
}

class _PracticaAlarmaViewState extends State<PracticaAlarmaView> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  RelojController get controller => widget.relojController;

  bool _guiaIniciada = false;
  bool _creada = false;
  bool _cambiada = false;
  bool _editada = false;
  bool _eliminada = false;
  bool _finalizada = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_guiaIniciada) {
        _guiaIniciada = true;
        widget.onCompletar('abrir_alarmas');
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
      titulo: '¡Vamos a configurar alarmas!',
      contenido:
      'En esta práctica aprenderás a crear una alarma, '
          'cambiar su estado, editarla y eliminarla.\n\n'
          'Primero vamos a crear nuestra primera alarma.',
      icono: Icons.alarm_rounded,
    );

    if (mounted) await _mostrarPasoActual();
  }

  Future<void> _mostrarPasoActual() async {
    if (!mounted) return;

    if (!_creada) {
      await _mensaje(
        titulo: 'Paso 1: crear una alarma',
        contenido:
        'Presiona el botón «Agregar alarma». '
            'Después elige una hora, escribe un nombre y guarda '
            'la alarma.',
        icono: Icons.add_alarm_rounded,
      );
    } else if (!_cambiada) {
      await _mensaje(
        titulo: 'Paso 2: activar o desactivar',
        contenido:
        '¡Muy bien! Ya creaste tu alarma.\n\n'
            'Ahora utiliza el interruptor que aparece junto a ella '
            'para activarla y desactivarla.',
        icono: Icons.toggle_on_rounded,
      );
    } else if (!_editada) {
      await _mensaje(
        titulo: 'Paso 3: editar una alarma',
        contenido:
        '¡Excelente! Ahora presiona el botón de editar '
            'que aparece junto a tu alarma. Cambia su nombre '
            'o su hora y guarda los cambios.',
        icono: Icons.edit_rounded,
      );
    } else if (!_eliminada) {
      await _mensaje(
        titulo: 'Paso 4: eliminar una alarma',
        contenido:
        'Ya sabes crear, activar y editar alarmas.\n\n'
            'Ahora presiona el botón de eliminar junto a la alarma '
            'y confirma la acción.',
        icono: Icons.delete_outline_rounded,
      );
    } else if (!_finalizada) {
      _finalizada = true;
      await _mensaje(
        titulo: '¡Práctica completada!',
        contenido:
        'Aprendiste a crear, activar, desactivar, editar '
            'y eliminar una alarma.',
        textoBoton: 'Finalizar',
        icono: Icons.check_circle_rounded,
      );
    }
  }

  Future<void> _mostrarAyuda() async {
    await _mostrarPasoActual();
  }

  Future<_DatosAlarma?> _formularioAlarma({
    AlarmaModel? alarma,
  }) async {
    final nombreController = TextEditingController(
      text: alarma?.nombre ?? '',
    );

    TimeOfDay hora = alarma?.hora ?? TimeOfDay.now();

    final resultado = await showDialog<_DatosAlarma>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: Text(
                alarma == null ? 'Nueva alarma' : 'Editar alarma',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      final seleccionada = await showTimePicker(
                        context: context,
                        initialTime: hora,
                      );

                      if (seleccionada != null) {
                        actualizarDialogo(() {
                          hora = seleccionada;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time_rounded),
                    label: Text(
                      hora.format(context),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la alarma',
                      hintText: 'Ej. Despertar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final nombre = nombreController.text.trim();

                    if (nombre.isEmpty) return;

                    Navigator.pop(
                      dialogContext,
                      _DatosAlarma(hora: hora, nombre: nombre),
                    );
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    nombreController.dispose();
    return resultado;
  }

  Future<void> _agregarAlarma() async {
    final datos = await _formularioAlarma();

    if (datos == null || !mounted) return;

    controller.agregarAlarma(
      hora: datos.hora,
      nombre: datos.nombre,
    );

    if (!_creada) {
      setState(() => _creada = true);
      widget.onCompletar('crear_alarma');
      await _mostrarPasoActual();
    }
  }

  Future<void> _editarAlarma(int indice) async {
    final alarma = controller.alarmas[indice];
    final datos = await _formularioAlarma(alarma: alarma);

    if (datos == null || !mounted) return;

    controller.editarAlarma(
      indice: indice,
      hora: datos.hora,
      nombre: datos.nombre,
      activa: alarma.activa,
    );

    if (!_editada) {
      setState(() => _editada = true);
      widget.onCompletar('editar_alarma');
      await _mostrarPasoActual();
    }
  }

  Future<void> _eliminarAlarma(int indice) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Eliminar alarma',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            '¿Estás seguro de que deseas eliminar esta alarma?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    controller.eliminarAlarma(indice);

    if (!_eliminada) {
      setState(() => _eliminada = true);
      widget.onCompletar('eliminar_alarma');
      await _mostrarPasoActual();
    }
  }

  Future<void> _cambiarEstado(int indice, bool activa) async {
    controller.cambiarEstadoAlarma(indice, activa);

    if (!_cambiada) {
      setState(() => _cambiada = true);
      widget.onCompletar('activar_alarma');
      await _mostrarPasoActual();
    }
  }

  String _formatearHora(TimeOfDay hora) {
    return '${hora.hour.toString().padLeft(2, '0')}:'
        '${hora.minute.toString().padLeft(2, '0')}';
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
          'Alarmas',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarAlarma,
        backgroundColor: verde,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alarm_rounded),
        label: const Text('Agregar alarma'),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Row(
                children: [
                  Icon(Icons.alarm_rounded, color: verde),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Mis alarmas',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (controller.alarmas.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        color: azul,
                        size: 48,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Todavía no tienes alarmas.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Presiona «Agregar alarma» para comenzar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(controller.alarmas.length, (indice) {
                  final alarma = controller.alarmas[indice];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.alarm_rounded,
                          color: azul,
                          size: 30,
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatearHora(alarma.hora),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                alarma.nombre,
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: alarma.activa,
                          activeColor: verde,
                          onChanged: (valor) =>
                              _cambiarEstado(indice, valor),
                        ),
                        IconButton(
                          tooltip: 'Editar',
                          onPressed: () => _editarAlarma(indice),
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: azul,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Eliminar',
                          onPressed: () => _eliminarAlarma(indice),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 85),
            ],
          );
        },
      ),
    );
  }
}

class _DatosAlarma {
  final TimeOfDay hora;
  final String nombre;

  const _DatosAlarma({
    required this.hora,
    required this.nombre,
  });
}