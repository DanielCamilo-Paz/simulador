
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

  void _llamarNumero() {
    if (_numero.isEmpty) return;

    final numeroMarcado = _numero;

    _registrarLlamada(
      nombre: 'Número marcado',
      numero: numeroMarcado,
    );

    setState(() {
      _numero = '';
    });
  }

  void _seleccionarContacto(String nombre) {
    final numero = _numeros[nombre]!;

    _registrarLlamada(
      nombre: nombre,
      numero: numero,
    );
  }

  //Encabezado
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
        child: IndexedStack(
          index: _pestana,
          children: [
            _vistaMarcar(),
            _vistaContactos(),
            _vistaRecientes(),
          ],
        ),
      ),
      //Navbar Inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pestana,
        onTap: (indice) {
          setState(() {
            _pestana = indice;
          });
        },
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

  // Marcar Telefono
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
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
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

  //Lista de contactos
  Widget _vistaContactos() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Elige a quién deseas llamar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    color: const Color(0xFF79929E),
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

  //Llamadas Recientes
  Widget _vistaRecientes() {
    if (_recientes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history_rounded, size: 72, color: azul),
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
