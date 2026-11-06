import 'dart:async';
import 'package:flutter/material.dart';

import '../../controllers/reloj_controller.dart';
import '../../controllers/progreso_controller.dart';
import '../../models/reloj/alarma_model.dart';

class PantallaRelojSim extends StatefulWidget {
  final ProgresoController progresoController;

  const PantallaRelojSim({
    super.key,
    required this.progresoController,
  });

  @override
  State<PantallaRelojSim> createState() => _PantallaRelojSimState();
}

class _PantallaRelojSimState extends State<PantallaRelojSim> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  late final RelojController relojController;

  int? practicaActual;

  int pasoAlarma = 1;
  String instruccionAlarma =
      'PASO 1. Pulsa el botón “Agregar alarma” para comenzar.';

  bool formularioAlarmaVisible = false;
  int? indiceAlarmaEditando;

  TimeOfDay horaFormulario =
  const TimeOfDay(hour: 7, minute: 0);

  final TextEditingController nombreAlarmaController =
  TextEditingController();

  bool alarmaFormularioActiva = true;
  bool horaFormularioElegida = false;

  String instruccionMundial =
      'Observa el nombre de cada ciudad y mira la hora que aparece a su derecha.';

  String instruccionCronometro =
      'PASO 1. Pulsa “Iniciar” para comenzar a medir el tiempo.';

  bool cronometroSeInicio = false;

  // RELOJ MUNDIAL

  DateTime ahora = DateTime.now();
  Timer? relojTimer;

  final List<Map<String, dynamic>> ciudades = [
    {'nombre': 'Bogotá', 'zona': 'Colombia', 'offset': -5},
    {'nombre': 'Madrid', 'zona': 'España', 'offset': 1},
    {'nombre': 'Nueva York', 'zona': 'Estados Unidos', 'offset': -4},
    {'nombre': 'Tokio', 'zona': 'Japón', 'offset': 9},
  ];

  @override
  void initState() {
    super.initState();

    relojController = RelojController();
    relojController.addListener(actualizarVista);

    relojTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (mounted) {
          setState(() {
            ahora = DateTime.now();
          });
        }
      },
    );
  }

  void actualizarVista() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    relojTimer?.cancel();
    nombreAlarmaController.dispose();

    relojController.removeListener(actualizarVista);
    relojController.dispose();

    super.dispose();
  }

  Future<void> mostrarAyuda({
    required String titulo,
    required String mensaje,
    required IconData icono,
    String boton = 'Entendido',
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        icon: Icon(icono, size: 48, color: azul),
        title: Text(titulo, textAlign: TextAlign.center),
        content: Text(
          mensaje,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
            height: 1.4,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: azul,
              foregroundColor: Colors.white,
              minimumSize: const Size(150, 52),
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              boton,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> abrirPractica(int indice) async {
    // REGISTRO DE PROGRESO:
    // Al entrar a Alarmas o consultar el Reloj mundial.
    if (indice == 0) {
      widget.progresoController.completarActividadReloj(
        'abrir_alarmas',
      );
    } else if (indice == 1) {
      widget.progresoController.completarActividadReloj(
        'reloj_mundial',
      );
    }

    setState(() {
      practicaActual = indice;

      if (indice == 0) {
        pasoAlarma = 1;
        instruccionAlarma =
        'PASO 1. Pulsa el botón “Agregar alarma” para comenzar.';
      } else if (indice == 1) {
        instruccionMundial =
        'Observa el nombre de cada ciudad y mira la hora que aparece a su derecha. Esta pantalla es solo para consultar.';
      } else {
        instruccionCronometro =
        'PASO 1. Pulsa “Iniciar” para comenzar a medir el tiempo.';
      }
    });
  }

  void volverAlMenu() {
    setState(() {
      practicaActual = null;
    });
  }

  String formatoHora(TimeOfDay hora) {
    return '${hora.hour.toString().padLeft(2, '0')}:'
        '${hora.minute.toString().padLeft(2, '0')}';
  }

  DateTime horaCiudad(int diferencia) {
    return DateTime.now().toUtc().add(
      Duration(hours: diferencia),
    );
  }

  // ---------------- ALARMAS ----------------

  AlarmaModel? obtenerProximaAlarma() {
    return relojController.obtenerProximaAlarma();
  }

  void mostrarFormularioAlarma({int? indice}) {
    final esEdicion = indice != null;

    final AlarmaModel? existente =
    esEdicion ? relojController.alarmas[indice] : null;

    setState(() {
      formularioAlarmaVisible = true;
      indiceAlarmaEditando = indice;

      horaFormulario =
          existente?.hora ?? const TimeOfDay(hour: 7, minute: 0);

      nombreAlarmaController.text = existente?.nombre ?? '';

      alarmaFormularioActiva = existente?.activa ?? true;

      horaFormularioElegida = esEdicion;

      pasoAlarma = 2;

      instruccionAlarma = esEdicion
          ? 'PASO 2. Modifica la hora de la alarma. Después revisa el nombre y su estado.'
          : 'PASO 2. Pulsa “Elegir hora”. La pantalla de alarmas seguirá visible mientras completas el formulario.';
    });
  }

  Future<void> elegirHoraAlarma() async {
    final seleccion = await showTimePicker(
      context: context,
      initialTime: horaFormulario,
      helpText: 'ELIGE LA HORA DE TU ALARMA',
      confirmText: 'ACEPTAR',
      cancelText: 'CANCELAR',
    );

    if (seleccion == null || !mounted) return;

    setState(() {
      horaFormulario = seleccion;
      horaFormularioElegida = true;

      if (nombreAlarmaController.text.trim().isNotEmpty) {
        pasoAlarma = 4;
        instruccionAlarma =
        'PASO 4. Revisa la hora, el nombre y el interruptor. Cuando esté listo, pulsa “Guardar alarma”.';
      } else {
        pasoAlarma = 3;
        instruccionAlarma =
        'PASO 3. ¡Muy bien! Ahora escribe un nombre para recordar para qué es esta alarma.';
      }
    });
  }

  void actualizarNombreAlarma(String valor) {
    setState(() {
      if (valor.trim().isNotEmpty && horaFormularioElegida) {
        pasoAlarma = 4;
        instruccionAlarma =
        'PASO 4. Revisa la hora, el nombre y el interruptor. Cuando esté listo, pulsa “Guardar alarma”.';
      } else if (horaFormularioElegida) {
        pasoAlarma = 3;
        instruccionAlarma =
        'PASO 3. Escribe un nombre para recordar para qué es esta alarma.';
      }
    });
  }

  void cancelarFormularioAlarma() {
    setState(() {
      formularioAlarmaVisible = false;
      indiceAlarmaEditando = null;
      nombreAlarmaController.clear();

      pasoAlarma = 1;

      instruccionAlarma =
      'PASO 1. Pulsa “Agregar alarma” cuando quieras practicar de nuevo.';
    });
  }

  void guardarAlarmaFormulario() {
    if (!horaFormularioElegida) {
      setState(() {
        pasoAlarma = 2;
        instruccionAlarma =
        'PASO 2. Primero pulsa “Elegir hora” para seleccionar cuándo sonará la alarma.';
      });
      return;
    }

    if (nombreAlarmaController.text.trim().isEmpty) {
      setState(() {
        pasoAlarma = 3;
        instruccionAlarma =
        'PASO 3. Escribe un nombre para identificar la alarma, por ejemplo: Levantarse.';
      });
      return;
    }

    final nombreGuardado = nombreAlarmaController.text.trim();
    final horaGuardada = formatoHora(horaFormulario);

    final estabaEditando = indiceAlarmaEditando != null;

    if (estabaEditando) {
      relojController.editarAlarma(
        indice: indiceAlarmaEditando!,
        hora: horaFormulario,
        nombre: nombreGuardado,
        activa: alarmaFormularioActiva,
      );

      widget.progresoController.completarActividadReloj(
        'editar_alarma',
      );
    } else {
      relojController.agregarAlarma(
        hora: horaFormulario,
        nombre: nombreGuardado,
        activa: alarmaFormularioActiva,
      );

      widget.progresoController.completarActividadReloj(
        'crear_alarma',
      );
    }

    setState(() {
      formularioAlarmaVisible = false;
      indiceAlarmaEditando = null;
      nombreAlarmaController.clear();

      pasoAlarma = 5;

      instruccionAlarma = !estabaEditando
          ? '¡Excelente! Creaste la alarma “$nombreGuardado” para las $horaGuardada. PASO 6. Ahora puedes practicar las opciones de la alarma: pulsa “Editar” para cambiarla, “Eliminar” para borrarla o usa el interruptor verde para activarla o suspenderla. Para crear otra, pulsa “Agregar alarma”.'
          : '¡Listo! Actualizaste la alarma “$nombreGuardado” para las $horaGuardada. Ahora puedes usar “Eliminar” para borrarla o el interruptor verde para activarla o suspenderla. Para crear otra, pulsa “Agregar alarma”.';
    });
  }

  Widget construirFormularioAlarma() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              indiceAlarmaEditando == null
                  ? 'Nueva alarma'
                  : 'Editar alarma',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: elegirHoraAlarma,
              icon: const Icon(
                Icons.access_time_rounded,
                size: 26,
              ),
              label: Text(
                horaFormularioElegida
                    ? 'Hora seleccionada: ${formatoHora(horaFormulario)}'
                    : 'Elegir hora',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                foregroundColor: const Color(0xFF405F6D),
                side: const BorderSide(color: azul, width: 1.5),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: nombreAlarmaController,
              onChanged: actualizarNombreAlarma,
              style: const TextStyle(fontSize: 17),
              decoration: InputDecoration(
                labelText: 'Nombre de la alarma',
                hintText: 'Ej. Levantarse',
                prefixIcon: const Icon(Icons.edit_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Alarma activada',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Verde: encendida. Gris: apagada.',
              ),
              value: alarmaFormularioActiva,
              activeColor: verde,
              onChanged: (valor) {
                setState(() {
                  alarmaFormularioActiva = valor;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: cancelarFormularioAlarma,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: guardarAlarmaFormulario,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Guardar alarma'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verde,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void cambiarEstadoAlarma(int indice, bool valor) {
    final estadoAnterior = relojController.alarmas[indice].activa;

    relojController.cambiarEstadoAlarma(indice, valor);

    if (estadoAnterior != valor) {
      widget.progresoController.completarActividadReloj(
        'activar_alarma',
      );
    }
  }

  Future<void> eliminarAlarma(int indice) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar alarma'),
        content: const Text(
          '¿Deseas eliminar esta alarma de la práctica?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      relojController.eliminarAlarma(indice);

      setState(() {
        instruccionAlarma = relojController.alarmas.isEmpty
            ? 'La alarma se eliminó. Cuando quieras practicar otra vez, pulsa “Agregar alarma”.'
            : 'La alarma se eliminó. Puedes continuar con otra alarma o pulsar “Agregar alarma” para crear una nueva.';
      });
    }
  }

  // ---------------- CRONÓMETRO ----------------

  void iniciarCronometro() {
    if (relojController.estaEnMarcha) return;

    relojController.iniciarCronometro();

    // REGISTRO DE PROGRESO:
    widget.progresoController.completarActividadReloj(
      'iniciar_cronometro',
    );

    cronometroSeInicio = true;

    setState(() {
      instruccionCronometro =
      'PASO 2. El cronómetro está contando. Pulsa “Guardar tiempo” para registrar lo que llevas o “Reiniciar” para volver a cero.';
    });
  }

  void pausarCronometro() {
    relojController.pausarCronometro();

    // No registramos 'usar_cronometro' porque no forma
    // parte de las ocho actividades del progreso.

    setState(() {
      instruccionCronometro =
      'El cronómetro está pausado. Pulsa “Iniciar” para continuar o “Reiniciar” para comenzar desde cero.';
    });
  }

  void reiniciarCronometro() {
    final teniaTiempo =
        relojController.tiempoTranscurrido.inMilliseconds > 0;

    relojController.reiniciarCronometro();

    if (cronometroSeInicio && teniaTiempo) {
      widget.progresoController.completarActividadReloj(
        'reiniciar_cronometro',
      );
    }

    setState(() {
      instruccionCronometro =
      'PASO 1. El tiempo volvió a cero. Pulsa “Iniciar” para comenzar una nueva medición.';
    });
  }

  void guardarVuelta() {
    if (relojController.tiempoTranscurrido.inMilliseconds <= 0) {
      return;
    }

    relojController.guardarVuelta();

    widget.progresoController.completarActividadReloj(
      'guardar_vuelta',
    );

    setState(() {
      instruccionCronometro =
      '¡Tiempo guardado! Lo puedes ver en la lista. Continúa midiendo o pulsa “Reiniciar” para empezar de nuevo.';
    });
  }

  // ---------------- CONSTRUCCIÓN DE LA PANTALLA ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        leadingWidth: practicaActual == null ? null : 132,
        leading: practicaActual == null
            ? null
            : TextButton.icon(
          onPressed: volverAlMenu,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 25,
          ),
          label: const Text(
            'Volver',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          practicaActual == null
              ? 'Reloj'
              : ['Alarmas', 'Reloj mundial', 'Cronómetro']
          [practicaActual!],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: practicaActual == null
            ? construirMenuPracticas()
            : IndexedStack(
          index: practicaActual!,
          children: [
            construirAlarmas(),
            construirRelojMundial(),
            construirCronometro(),
          ],
        ),
      ),
      bottomNavigationBar: practicaActual == null
          ? null
          : SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
          child: SizedBox(
            height: 58,
            child: ElevatedButton.icon(
              onPressed: volverAlMenu,
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 26,
              ),
              label: const Text(
                'REGRESAR AL MENÚ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF526F7B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget construirMenuPracticas() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(height: 12),
        const Icon(
          Icons.watch_later_rounded,
          size: 70,
          color: azul,
        ),
        const SizedBox(height: 12),
        const Text(
          '¿Qué deseas aprender?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Selecciona una práctica para conocer cómo funciona el reloj.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 25),
        _tarjetaPractica(
          icono: Icons.alarm_rounded,
          titulo: 'Practicar alarmas',
          descripcion:
          'Agregar, editar, activar y desactivar una alarma.',
          onTap: () => abrirPractica(0),
        ),
        _tarjetaPractica(
          icono: Icons.public_rounded,
          titulo: 'Conocer el reloj mundial',
          descripcion: 'Observar la hora de diferentes ciudades.',
          onTap: () => abrirPractica(1),
        ),
        _tarjetaPractica(
          icono: Icons.timer_rounded,
          titulo: 'Usar el cronómetro',
          descripcion:
          'Iniciar, pausar, guardar tiempos y reiniciar.',
          onTap: () => abrirPractica(2),
        ),
      ],
    );
  }

  Widget _tarjetaPractica({
    required IconData icono,
    required String titulo,
    required String descripcion,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
        leading: CircleAvatar(
          radius: 29,
          backgroundColor: azul.withOpacity(0.22),
          child: Icon(
            icono,
            color: const Color(0xFF587887),
            size: 30,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            descripcion,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _panelInstruccion(String texto) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE4EEF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF9DBAC6),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.school_rounded,
                color: Color(0xFF405F6D),
                size: 23,
              ),
              const SizedBox(width: 8),
              const Text(
                'GUÍA PASO A PASO',
                style: TextStyle(
                  color: Color(0xFF405F6D),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.push_pin_rounded,
                color: Color(0xFF587887),
                size: 19,
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 17,
              height: 1.4,
              fontWeight: FontWeight.w700,
              color: Color(0xFF263D46),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- VISTA DE ALARMAS ----------------

  Widget construirAlarmas() {
    final proxima = obtenerProximaAlarma();
    final alarmas = relojController.alarmas;

    return ListView(
      padding: const EdgeInsets.only(bottom: 18),
      children: [
        _panelInstruccion(instruccionAlarma),

        if (proxima != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 15),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: azul.withOpacity(0.22),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Text(
                  'PRÓXIMA ALARMA ACTIVADA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  proxima.obtenerHoraFormateada(),
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(proxima.nombre),
              ],
            ),
          ),

        const SizedBox(height: 7),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mis alarmas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: formularioAlarmaVisible
                    ? null
                    : () => mostrarFormularioAlarma(),
                icon: const Icon(Icons.add),
                label: const Text('Agregar alarma'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 48),
                ),
              ),
            ],
          ),
        ),

        if (formularioAlarmaVisible)
          construirFormularioAlarma(),

        if (alarmas.isNotEmpty)
          ...List.generate(alarmas.length, (indice) {
            final alarma = alarmas[indice];
            final activa = alarma.activa;

            return Card(
              color: Colors.white,
              elevation: 2,
              margin: const EdgeInsets.fromLTRB(15, 8, 15, 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.alarm_rounded,
                          color: activa ? azul : Colors.grey,
                          size: 34,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                alarma.obtenerHoraFormateada(),
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: activa
                                      ? Colors.black87
                                      : Colors.grey,
                                ),
                              ),
                              Text(
                                alarma.nombre,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () =>
                              mostrarFormularioAlarma(indice: indice),
                          icon: const Icon(
                            Icons.edit_rounded,
                            size: 19,
                          ),
                          label: const Text('Editar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                            const Color(0xFF405F6D),
                            minimumSize: const Size(112, 44),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => eliminarAlarma(indice),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 19,
                          ),
                          label: const Text('Eliminar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            minimumSize: const Size(112, 44),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: activa,
                              activeColor: verde,
                              onChanged: (valor) =>
                                  cambiarEstadoAlarma(indice, valor),
                            ),
                            Text(
                              activa ? 'Activa' : 'Suspendida',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: activa
                                    ? verde
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  // ---------------- RELOJ MUNDIAL ----------------

  Widget construirRelojMundial() {
    return Column(
      children: [
        _panelInstruccion(instruccionMundial),
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 8, 18, 14),
          child: Text(
            'Hora en otras ciudades',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: ciudades.length,
            itemBuilder: (context, indice) {
              final ciudad = ciudades[indice];
              final hora = horaCiudad(ciudad['offset'] as int);

              final horaTexto =
                  '${hora.hour.toString().padLeft(2, '0')}:'
                  '${hora.minute.toString().padLeft(2, '0')}';

              final fechaTexto =
                  '${hora.day.toString().padLeft(2, '0')}/'
                  '${hora.month.toString().padLeft(2, '0')}/'
                  '${hora.year}';

              return Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Row(
                    children: [
                      Icon(
                        Icons.public_rounded,
                        color: azul,
                        size: 35,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              ciudad['nombre'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(ciudad['zona'] as String),
                            Text(
                              fechaTexto,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        horaTexto,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------- VISTA DEL CRONÓMETRO ----------------

  Widget construirCronometro() {
    final cronometro = relojController.cronometro;
    final estaEnMarcha = relojController.estaEnMarcha;

    return Column(
      children: [
        _panelInstruccion(instruccionCronometro),

        const SizedBox(height: 28),

        const Text(
          'Mide el tiempo de una actividad',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),

        const SizedBox(height: 28),

        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: azul.withOpacity(0.22),
            shape: BoxShape.circle,
          ),
          child: Text(
            cronometro.tiempo,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 30),

        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: estaEnMarcha
                  ? pausarCronometro
                  : iniciarCronometro,
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 16,
                ),
              ),
              child: Text(
                estaEnMarcha ? 'Pausar' : 'Iniciar',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            ElevatedButton(
              onPressed: reiniciarCronometro,
              style: ElevatedButton.styleFrom(
                backgroundColor: azul,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Reiniciar',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed:
          relojController.tiempoTranscurrido.inMilliseconds > 0
              ? guardarVuelta
              : null,
          icon: const Icon(Icons.flag_rounded),
          label: const Text('Guardar tiempo'),
        ),

        const SizedBox(height: 14),

        if (cronometro.vueltas.isNotEmpty)
          const Text(
            'Tiempos guardados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

        Expanded(
          child: ListView.builder(
            itemCount: cronometro.vueltas.length,
            itemBuilder: (context, indice) => ListTile(
              leading: CircleAvatar(
                backgroundColor: azul,
                child: Text('${indice + 1}'),
              ),
              title: Text(
                'Tiempo: ${cronometro.vueltas[indice]}',
              ),
            ),
          ),
        ),
      ],
    );
  }
}