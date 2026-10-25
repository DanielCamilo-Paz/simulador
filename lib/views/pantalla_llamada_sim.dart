import 'package:flutter/material.dart';
import 'simulador_view.dart';

class PantallaLlamadaSim extends StatefulWidget {
  const PantallaLlamadaSim({super.key});

  @override
  State<PantallaLlamadaSim> createState() => _PantallaLlamadaSimState();
}

class _PantallaLlamadaSimState extends State<PantallaLlamadaSim> {
  int paso = 1;

  final contactos = [
    'Hijo David',
    'Hermana',
    'Mama',
    'Primo',
    'Nieto',
    'Cuñado',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telefono - Practica'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: contactos.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(contactos[i]),
                  trailing: IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        paso = 2;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Caja de instrucciones
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paso $paso',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Contexto: Estas en el telefono, ahora quieres llamar a tu hijo para pedirle que te traiga algo para la casa.\n'
                      'Tarea: Selecciona el contacto de tu hijo y dale al simbolo del telefono para llamar',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          if (paso == 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SimuladorView()),
                  );
                },
                child: const Text('Finalizar Práctica'),
              ),
            ),

          // Barra inferior
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contactos'),
              BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Llamadas'),
              BottomNavigationBarItem(icon: Icon(Icons.dialpad), label: 'Marcar'),
            ],
          ),
        ],
      ),
    );
  }
}