import 'package:flutter/material.dart';
import '../../controllers/llamada_controller.dart';
import '../../models/llamada/llamada_model.dart';

class PantallaLlamadaSim extends StatefulWidget {
  const PantallaLlamadaSim({super.key});

  @override
  State<PantallaLlamadaSim> createState() =>
      _PantallaLlamadaSimState();
}

class _PantallaLlamadaSimState
    extends State<PantallaLlamadaSim> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  late final LlamadaController controller;

  @override
  void initState() {
    super.initState();
    controller = LlamadaController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _iniciarPractica();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _mensaje(
      String titulo,
      String contenido, {
        IconData icono = Icons.info_outline,
      }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: fondo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: Icon(icono, color: azul, size: 42),
        title: Text(
          titulo,
          textAlign: TextAlign.center,
        ),
        content: Text(
          contenido,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: azul,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Future<void> _iniciarPractica() async {
    await _mensaje(
      '¡Vamos a practicar!',
      'Aprenderás a marcar un número, llamar a un contacto '
          'guardado y consultar las llamadas recientes. '
          'Las llamadas son simuladas.',
      icono: Icons.phone_android,
    );

    if (!mounted) return;

    await _mensaje(
      'Paso 1 de 3: marcar',
      'Escribe un número con el teclado y toca el botón verde.',
      icono: Icons.dialpad,
    );
  }

  Future<void> _llamarNumero() async {
    final resultado = controller.llamarNumero();

    if (!resultado) {
      await _mensaje(
        'Número vacío',
        'Escribe un número antes de realizar la llamada.',
      );
      return;
    }

    await _mensaje(
      '¡Muy bien!',
      'Has completado el primer paso. Ahora selecciona '
          'un contacto guardado.',
      icono: Icons.check_circle,
    );

    if (!mounted) return;

    await _mensaje(
      'Paso 2 de 3: contactos',
      'Selecciona una persona de tu lista para simular '
          'una llamada.',
      icono: Icons.contacts,
    );
  }

  Future<void> _llamarContacto(Contacto contacto) async {
    controller.llamarContacto(contacto);

    await _mensaje(
      '¡Contacto llamado!',
      'Has simulado una llamada a ${contacto.nombre}. '
          'Ahora revisa la pestaña Recientes.',
      icono: Icons.check_circle,
    );

    if (!mounted) return;

    await _mensaje(
      'Paso 3 de 3: recientes',
      'En esta sección podrás consultar las llamadas '
          'que realizaste.',
      icono: Icons.history,
    );
  }

  Future<void> _consultarRecientes() async {
    final resultado = controller.consultarRecientes();

    if (!resultado) {
      await _mensaje(
        'Todavía falta un paso',
        'Primero debes llamar a un contacto guardado. '
            'Después podrás completar esta práctica.',
      );
      return;
    }

    await _mensaje(
      '¡Práctica completada!',
      'Excelente trabajo. Aprendiste a marcar un número, '
          'llamar a un contacto y revisar las llamadas recientes.',
      icono: Icons.celebration,
    );
  }

  Future<void> _cambiarPestana(int indice) async {
    if (indice == 1 && !controller.progreso.numeroMarcado) {
      await _mensaje(
        'Completa el primer paso',
        'Primero debes marcar un número desde la pestaña Marcar.',
      );
      return;
    }

    if (indice == 2) {
      if (!controller.progreso.contactoLlamado) {
        await _mensaje(
          'Completa el segundo paso',
          'Primero selecciona un contacto y simula una llamada.',
        );
        return;
      }

      controller.cambiarPestana(indice);
      await _consultarRecientes();
      return;
    }

    controller.cambiarPestana(indice);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: fondo,
          appBar: AppBar(
            backgroundColor: fondo,
            elevation: 0,
            title: const Text(
              'Teléfono',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                tooltip: 'Ayuda',
                icon: const Icon(Icons.help_outline),
                onPressed: _iniciarPractica,
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                _barraProgreso(),
                Expanded(
                  child: IndexedStack(
                    index: controller.pestanaActual,
                    children: [
                      _vistaMarcar(),
                      _vistaContactos(),
                      _vistaRecientes(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.pestanaActual,
            onTap: _cambiarPestana,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF587887),
            unselectedItemColor: Colors.black54,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dialpad),
                label: 'Marcar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                label: 'Contactos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Recientes',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _barraProgreso() {
    final progreso = controller.progreso;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progreso de la práctica',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('${progreso.pasosCompletados} de 3 pasos'),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: controller.porcentajeProgreso,
              minHeight: 9,
              backgroundColor: Colors.black12,
              color: azul,
            ),
          ),
        ],
      ),
    );
  }

  // VISTA 1: MARCAR
  Widget _vistaMarcar() {
    const teclas = [
      ['1', ''],
      ['2', 'ABC'],
      ['3', 'DEF'],
      ['4', 'GHI'],
      ['5', 'JKL'],
      ['6', 'MNO'],
      ['7', 'PQRS'],
      ['8', 'TUV'],
      ['9', 'WXYZ'],
      ['*', ''],
      ['0', '+'],
      ['#', ''],
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Escribe un número de teléfono',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    controller.numeroMarcado.isEmpty
                        ? 'Ingresa un número'
                        : controller.numeroMarcado,
                    style: const TextStyle(
                      fontSize: 27,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.borrarNumero,
                icon: const Icon(Icons.backspace_outlined),
              ),
            ],
          ),
        ),
        const Divider(indent: 25, endIndent: 25),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teclas.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 18,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final tecla = teclas[index];

                return Material(
                  color: const Color(0xFFE4EBEF),
                  borderRadius: BorderRadius.circular(40),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () => controller.agregarNumero(tecla[0]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tecla[0],
                          style: const TextStyle(fontSize: 25),
                        ),
                        Text(
                          tecla[1],
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 35, top: 8),
          child: SizedBox(
            width: 100,
            height: 65,
            child: ElevatedButton(
              onPressed: _llamarNumero,
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              child: const Icon(Icons.call, size: 30),
            ),
          ),
        ),
      ],
    );
  }

  // VISTA 2: CONTACTOS
  Widget _vistaContactos() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(18),
          child: Text(
            'Elige a quién deseas llamar',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.contactos.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final contacto = controller.contactos[index];

              return Card(
                color: const Color(0xFFDAE8EF),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    radius: 27,
                    backgroundColor: azul,
                    child: Text(
                      contacto.nombre[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  title: Text(
                    contacto.nombre,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(contacto.numero),
                  trailing: const Icon(
                    Icons.call,
                    color: verde,
                    size: 28,
                  ),
                  onTap: () => _llamarContacto(contacto),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // VISTA 3: RECIENTES
  Widget _vistaRecientes() {
    if (controller.recientes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 70,
              color: azul,
            ),
            SizedBox(height: 15),
            Text(
              'Todavía no hay llamadas',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Las llamadas realizadas aparecerán aquí.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(18),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Llamadas recientes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.recientes.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final llamada = controller.recientes[index];

              return Card(
                color: const Color(0xFFDAE8EF),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const CircleAvatar(
                    backgroundColor: azul,
                    child: Icon(
                      Icons.call_made,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    llamada.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${llamada.numero}\n'
                        '${llamada.tipo} · ${llamada.hora}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}