import 'dart:async';
import 'package:flutter/material.dart';

class PantallaRelojSim extends StatefulWidget {
  const PantallaRelojSim({super.key});

  @override
  State<PantallaRelojSim> createState() => _PantallaRelojSimState();
}

class _PantallaRelojSimState extends State<PantallaRelojSim> {
  final Color azul = const Color(0xFF92AFBC);
  final Color fondo = const Color(0xFFF7F9FA);
  final Color verde = const Color(0xFF299764);

  int paginaActual = 0;

  // ALARMAS
  final List<Map<String, dynamic>> alarmas = [
    {
      'hora': const TimeOfDay(hour: 6, minute: 30),
      'nombre': 'Levantarse',
      'activa': true,
    },
    {
      'hora': const TimeOfDay(hour: 8, minute: 0),
      'nombre': 'Desayuno',
      'activa': true,
    },
  ];

  // RELOJ MUNDIAL
  DateTime ahora = DateTime.now();
  Timer? relojTimer;

  final List<Map<String, dynamic>> ciudades = [
    {'nombre': 'Bogotá', 'zona': 'Colombia', 'offset': -5},
    {'nombre': 'Madrid', 'zona': 'España', 'offset': 1},
    {'nombre': 'Nueva York', 'zona': 'Estados Unidos', 'offset': -4},
    {'nombre': 'Tokio', 'zona': 'Japón', 'offset': 9},
  ];

  // CRONÓMETRO
  final Stopwatch cronometro = Stopwatch();
  Timer? cronometroTimer;
  String tiempo = '00:00:00';
  final List<String> vueltas = [];

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    relojTimer?.cancel();
    cronometroTimer?.cancel();
    super.dispose();
  }

  // FORMATO DE HORA
  String formatoHora(TimeOfDay hora) {
    final h = hora.hour.toString().padLeft(2, '0');
    final m = hora.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // HORA ACTUAL DE CADA CIUDAD
  DateTime horaCiudad(int diferencia) {
    final utc = DateTime.now().toUtc();
    return utc.add(Duration(hours: diferencia));
  }

  // PRÓXIMA ALARMA
  Map<String, dynamic>? obtenerProximaAlarma() {
    final activas = alarmas.where((a) => a['activa'] == true).toList();

    if (activas.isEmpty) return null;

    activas.sort((a, b) {
      final horaA = a['hora'] as TimeOfDay;
      final horaB = b['hora'] as TimeOfDay;

      final minutosA = horaA.hour * 60 + horaA.minute;
      final minutosB = horaB.hour * 60 + horaB.minute;

      return minutosA.compareTo(minutosB);
    });

    final actual = TimeOfDay.now();
    final minutosActuales = actual.hour * 60 + actual.minute;

    for (final alarma in activas) {
      final hora = alarma['hora'] as TimeOfDay;
      final minutos = hora.hour * 60 + hora.minute;

      if (minutos > minutosActuales) return alarma;
    }

    return activas.first;
  }

  // CREAR O EDITAR ALARMA
  void mostrarFormularioAlarma({int? indice}) {
    final esEdicion = indice != null;

    final alarmaExistente =
    esEdicion ? alarmas[indice] : null;

    TimeOfDay horaSeleccionada =
        alarmaExistente?['hora'] ??
            const TimeOfDay(hour: 7, minute: 0);

    final nombreController = TextEditingController(
      text: alarmaExistente?['nombre'] ?? '',
    );

    bool activa = alarmaExistente?['activa'] ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            return AlertDialog(
              title: Text(
                esEdicion ? 'Editar alarma' : 'Nueva alarma',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '¿A qué hora deseas que suene?',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    InkWell(
                      onTap: () async {
                        final seleccion = await showTimePicker(
                          context: context,
                          initialTime: horaSeleccionada,
                        );

                        if (seleccion != null) {
                          actualizarDialogo(() {
                            horaSeleccionada = seleccion;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: fondo,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, color: azul),
                            const SizedBox(width: 12),
                            Text(
                              formatoHora(horaSeleccionada),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de la alarma',
                        hintText: 'Ej. Tomar medicamentos',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Alarma activada'),
                      value: activa,
                      activeColor: verde,
                      onChanged: (valor) {
                        actualizarDialogo(() {
                          activa = valor;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      final nuevaAlarma = {
                        'hora': horaSeleccionada,
                        'nombre': nombreController.text.trim().isEmpty
                            ? 'Mi alarma'
                            : nombreController.text.trim(),
                        'activa': activa,
                      };

                      if (esEdicion) {
                        alarmas[indice] = nuevaAlarma;
                      } else {
                        alarmas.add(nuevaAlarma);
                      }
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ELIMINAR ALARMA
  void eliminarAlarma(int indice) {
    setState(() {
      alarmas.removeAt(indice);
    });
  }

  // CRONÓMETRO
  String formatoCronometro(Duration duracion) {
    final horas = duracion.inHours.toString().padLeft(2, '0');
    final minutos =
    (duracion.inMinutes % 60).toString().padLeft(2, '0');
    final segundos =
    (duracion.inSeconds % 60).toString().padLeft(2, '0');

    return '$horas:$minutos:$segundos';
  }

  void iniciarCronometro() {
    if (cronometro.isRunning) return;

    cronometro.start();

    cronometroTimer = Timer.periodic(
      const Duration(milliseconds: 100),
          (_) {
        if (mounted) {
          setState(() {
            tiempo = formatoCronometro(cronometro.elapsed);
          });
        }
      },
    );

    setState(() {});
  }

  void pausarCronometro() {
    cronometro.stop();
    cronometroTimer?.cancel();
    setState(() {
      tiempo = formatoCronometro(cronometro.elapsed);
    });
  }

  void reiniciarCronometro() {
    cronometro.stop();
    cronometro.reset();
    cronometroTimer?.cancel();

    setState(() {
      tiempo = '00:00:00';
      vueltas.clear();
    });
  }

  void guardarVuelta() {
    setState(() {
      vueltas.add(tiempo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      construirAlarmas(),
      construirRelojMundial(),
      construirCronometro(),
    ];

    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reloj',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: pantallas[paginaActual],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaActual,
        onTap: (indice) {
          setState(() {
            paginaActual = indice;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: verde,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm, size: 27),
            label: 'Alarma',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public, size: 27),
            label: 'Mundial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer, size: 27),
            label: 'Cronómetro',
          ),
        ],
      ),
    );
  }

  // PANTALLA DE ALARMAS
  Widget construirAlarmas() {
    final proxima = obtenerProximaAlarma();

    return Column(
      children: [
        if (proxima != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: azul.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'PRÓXIMA ALARMA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatoHora(proxima['hora']),
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(proxima['nombre']),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: azul.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'No tienes alarmas activadas',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
          ),

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
                onPressed: () => mostrarFormularioAlarma(),
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Expanded(
          child: alarmas.isEmpty
              ? const Center(
            child: Text('Todavía no tienes alarmas'),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: alarmas.length,
            itemBuilder: (context, indice) {
              final alarma = alarmas[indice];

              return Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  onTap: () {
                    mostrarFormularioAlarma(indice: indice);
                  },
                  leading: Icon(
                    Icons.alarm,
                    color: azul,
                    size: 32,
                  ),
                  title: Text(
                    formatoHora(alarma['hora']),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    alarma['nombre'],
                    style: const TextStyle(fontSize: 15),
                  ),
                  trailing: Switch(
                    value: alarma['activa'],
                    activeColor: verde,
                    onChanged: (valor) {
                      setState(() {
                        alarma['activa'] = valor;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Toca una alarma para editarla.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  // PANTALLA DE RELOJ MUNDIAL
  Widget construirRelojMundial() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
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
              final hora = horaCiudad(ciudad['offset']);

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
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Icon(
                        Icons.public,
                        color: azul,
                        size: 35,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ciudad['nombre'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(ciudad['zona']),
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

  // PANTALLA DE CRONÓMETRO
  Widget construirCronometro() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Mide el tiempo de una actividad',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),

        const SizedBox(height: 35),

        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: azul.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            tiempo,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: cronometro.isRunning
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
                cronometro.isRunning ? 'Pausar' : 'Iniciar',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(width: 12),

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

        const SizedBox(height: 15),

        OutlinedButton.icon(
          onPressed: cronometro.elapsedMilliseconds > 0
              ? guardarVuelta
              : null,
          icon: const Icon(Icons.flag),
          label: const Text('Guardar tiempo'),
        ),

        const SizedBox(height: 20),

        if (vueltas.isNotEmpty)
          const Text(
            'Tiempos guardados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

        Expanded(
          child: ListView.builder(
            itemCount: vueltas.length,
            itemBuilder: (context, indice) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: azul,
                  child: Text('${indice + 1}'),
                ),
                title: Text('Tiempo: ${vueltas[indice]}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
