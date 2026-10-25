import 'package:flutter/material.dart';
import 'views/simulador_view.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador Celular',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SimuladorView(),  // ← De una vez la lista de prácticas
      debugShowCheckedModeBanner: false,
    );
  }
}