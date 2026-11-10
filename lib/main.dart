
import 'package:flutter/material.dart';
import 'views/principal/simulador_view.dart';
import 'views/principal/inicio_view.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador Celular',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F9D8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF77F11),
        ),
        useMaterial3: true,
      ),
      home: const InicioView(),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'views/principal/simulador_view.dart';

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
}*/