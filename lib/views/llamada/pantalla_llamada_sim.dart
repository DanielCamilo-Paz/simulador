import 'package:flutter/material.dart';

class PantallaLlamadaSim extends StatefulWidget {
  const PantallaLlamadaSim({super.key});

  @override
  State<PantallaLlamadaSim> createState() =>
      _PantallaLlamadaSimState();
}

class _PantallaLlamadaSimState extends State<PantallaLlamadaSim> {
  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);

  int _pestana = 0;
  String _numero = '';

  final List<String> _contactos = [
    'Hijo David',
    'Hermana',
    'Mamá',
    'Primo',
    'Nieto',
    'Cuñado',
  ];

  final Map<String, String> _numeros = {
    'Hijo David': '3001234567',
    'Hermana': '3102345678',
    'Mamá': '3153456789',
    'Primo': '3204567890',
    'Nieto': '3015678901',
    'Cuñado': '3126789012',
  };

  final List<Map<String, String>> _recientes = [];

  bool _guiaIniciada = false;
  bool _marcadoCompletado = false;
  bool _contactoCompletado = false;
  bool _recientesCompletado = false;

  int get _pasosCompletados =>
      [_marcadoCompletado, _contactoCompletado, _recientesCompletado]
          .where((paso) => paso)
          .length;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_guiaIniciada) {
        _guiaIniciada = true;
        _mostrarGuiaInicial();
      }
    });
  }

  Future<void> _mostrarAyuda({
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
        backgroundColor: fondo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        icon: Icon(icono, color: azul, size: 42),
        title: Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          mensaje,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: azul,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(boton),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarGuiaInicial() async {
    await _mostrarAyuda(
      titulo: '¡Vamos a practicar con el teléfono!',
      mensaje:
      'Aprenderás a marcar un número, llamar a un contacto guardado '
          'y consultar las llamadas recientes. Todas las llamadas son '
          'simuladas dentro de esta práctica.',
      icono: Icons.phone_android_rounded,
      boton: 'Comenzar',
    );

    if (!mounted) return;

    await _mostrarPasoMarcar();
  }

  Future<void> _mostrarPasoMarcar() async {
    await _mostrarAyuda(
      titulo: 'Paso 1 de 3: marcar un número',
      mensaje:
      'Usa el teclado para escribir un número de teléfono. '
          'Cuando termines, toca el botón verde de llamada.',
      icono: Icons.dialpad_rounded,
    );
  }

  Future<void> _mostrarPasoContacto() async {
    await _mostrarAyuda(
      titulo: 'Paso 2 de 3: llamar a un contacto',
      mensaje:
      'Ahora entra en Contactos, elige una persona de la lista y '
          'selecciónala para simular una llamada.',
      icono: Icons.contacts_rounded,
    );
  }

  Future<void> _mostrarPasoRecientes() async {
    await _mostrarAyuda(
      titulo: 'Paso 3 de 3: mirar recientes',
      mensaje:
      'En Recientes puedes consultar las llamadas que realizaste. '
          'Toca esta pestaña y observa los registros de la práctica.',
      icono: Icons.history_rounded,
    );
  }

  void _agregarNumero(String digito) {
    setState(() {
      _numero += digito;
    });
  }

  void _borrarNumero() {
    if (_numero.isEmpty) return;

    setState(() {
      _numero = _numero.substring(0, _numero.length - 1);
    });
  }

  // Registra una llamada ficticia dentro de la aplicación.
  void _registrarLlamada({
    required String nombre,
    required String numero,
  }) {
    final ahora = TimeOfDay.now().format(context);

    setState(() {
      _recientes.insert(0, {
        'nombre': nombre,
        'numero': numero,
        'hora': ahora,
        'tipo': 'Llamada saliente',
      });
    });
  }

  // Paso 1: marcar un número.
  Future<void> _llamarNumero() async {
    if (_numero.isEmpty) {
      await _mostrarAyuda(
        titulo: 'Escribe un número',
        mensaje: 'Primero utiliza el teclado para ingresar un número.',
        icono: Icons.info_outline,
      );
      return;
    }

    final numeroMarcado = _numero;

    _registrarLlamada(
      nombre: 'Número marcado',
      numero: numeroMarcado,
    );

    setState(() {
      _numero = '';
      _marcadoCompletado = true;
    });

    await _mostrarAyuda(
      titulo: '¡Muy bien! Número marcado',
      mensaje:
      'Realizaste tu primera llamada simulada. Ahora aprenderás '
          'a llamar a alguien que ya está guardado en Contactos.',
      icono: Icons.check_circle_outline,
      boton: 'Continuar',
    );

    if (!mounted) return;

    setState(() => _pestana = 1);

    await _mostrarPasoContacto();
  }

  // Paso 2: llamar a un contacto guardado.
  Future<void> _seleccionarContacto(String nombre) async {
    final numero = _numeros[nombre]!;

    _registrarLlamada(
      nombre: nombre,
      numero: numero,
    );

    setState(() {
      _contactoCompletado = true;
    });

    await _mostrarAyuda(
      titulo: '¡Llamada realizada!',
      mensaje:
      'Simulaste una llamada a $nombre. Ahora vamos a revisar '
          'dónde puedes consultar las llamadas que has realizado.',
      icono: Icons.check_circle_outline,
      boton: 'Ver recientes',
    );

    if (!mounted) return;

    setState(() => _pestana = 2);

    await _mostrarPasoRecientes();
  }

  // Paso 3: consultar llamadas recientes.
  Future<void> _cambiarPestana(int indice) async {
    setState(() => _pestana = indice);

    if (indice == 2 &&
        _contactoCompletado &&
        _recientes.isNotEmpty &&
        !_recientesCompletado) {
      setState(() => _recientesCompletado = true);

      await _mostrarAyuda(
        titulo: '¡Práctica completada!',
        mensaje:
        '¡Excelente! Aprendiste a marcar un número, llamar a un '
            'contacto guardado y consultar las llamadas recientes.',
        icono: Icons.celebration_outlined,
        boton: 'Finalizar',
      );
    } else if (indice == 1 && !_marcadoCompletado) {
      await _mostrarAyuda(
        titulo: 'Primero marca un número',
        mensaje:
        'Para seguir el orden de la práctica, vuelve a Marcar, '
            'escribe un número y toca el botón de llamada.',
        icono: Icons.info_outline,
      );
    } else if (indice == 2 && !_contactoCompletado) {
      await _mostrarAyuda(
        titulo: 'Completa primero la llamada a un contacto',
        mensaje:
        'Para terminar la práctica, entra en Contactos y selecciona '
            'a una persona. Después podrás revisar las llamadas en Recientes.',
        icono: Icons.history_rounded,
      );
    } else if (indice == 2 && _recientes.isEmpty) {
      await _mostrarAyuda(
        titulo: 'Todavía no hay llamadas',
        mensaje:
        'Primero realiza una llamada desde Marcar o Contactos. '
            'Después podrás verla en Recientes.',
        icono: Icons.history_rounded,
      );
    }
  }

  // Encabezado principal.
  @override
  Widget build(BuildContext context) {
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
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso de la práctica.
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
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
                      Text('$_pasosCompletados de 3 pasos'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: _pasosCompletados / 3,
                      minHeight: 9,
                      backgroundColor: Colors.black12,
                      color: azul,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: IndexedStack(
                index: _pestana,
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

      // Barra de navegación inferior.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pestana,
        onTap: _cambiarPestana,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF587887),
        unselectedItemColor: Colors.black54,
        selectedFontSize: 14,
        unselectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dialpad_rounded),
            label: 'Marcar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_rounded),
            label: 'Contactos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Recientes',
          ),
        ],
      ),
    );
  }

  // Pantalla para marcar un número.
  Widget _vistaMarcar() {
    final teclas = [
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
          padding: EdgeInsets.fromLTRB(16, 30, 16, 50),
          child: Text(
            'Escribe un número de teléfono',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 0,
          ),
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    _numero.isEmpty ? 'Ingresa un número' : _numero,
                    style: TextStyle(
                      fontSize: 25,
                      letterSpacing: 2,
                      color: _numero.isEmpty
                          ? Colors.black38
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Borrar último dígito',
                onPressed: _borrarNumero,
                icon: const Icon(Icons.backspace_outlined),
              ),
            ],
          ),
        ),

        const Divider(indent: 30, endIndent: 30),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 10,
            ),
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
                    onTap: () => _agregarNumero(tecla[0]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tecla[0],
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (tecla[1].isNotEmpty)
                          Text(
                            tecla[1],
                            style: const TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.5,
                            ),
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
          padding: const EdgeInsets.fromLTRB(30, 4, 30, 50),
          child: SizedBox(
            width: 105,
            height: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: azul,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
              ),
              onPressed: _llamarNumero,
              child: const Icon(Icons.call, size: 32),
            ),
          ),
        ),
      ],
    );
  }

  // Lista de contactos.
  Widget _vistaContactos() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Elige a quién deseas llamar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _contactos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final nombre = _contactos[index];

              return Material(
                color: const Color(0xFFDAE8EF),
                borderRadius: BorderRadius.circular(20),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  leading: CircleAvatar(
                    radius: 27,
                    backgroundColor: azul,
                    child: Text(
                      nombre[0],
                      style: const TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(_numeros[nombre]!),
                  trailing: const Icon(
                    Icons.call,
                    color: Color(0xFF79929E),
                    size: 28,
                  ),
                  onTap: () => _seleccionarContacto(nombre),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Pantalla de llamadas recientes.
  Widget _vistaRecientes() {
    if (_recientes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                size: 72,
                color: azul,
              ),
              SizedBox(height: 16),
              Text(
                'Todavía no hay llamadas',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Completa las prácticas de llamada para '
                    'verlas aparecer aquí.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
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
            itemCount: _recientes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final llamada = _recientes[index];

              return Material(
                color: const Color(0xFFDAE8EF),
                borderRadius: BorderRadius.circular(20),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 5,
                  ),
                  leading: const CircleAvatar(
                    radius: 26,
                    backgroundColor: azul,
                    child: Icon(
                      Icons.call_made_rounded,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    llamada['nombre']!,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${llamada['numero']}\n'
                        '${llamada['tipo']} · ${llamada['hora']}',
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