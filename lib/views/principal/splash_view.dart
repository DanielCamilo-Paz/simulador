
import 'package:flutter/material.dart';

import 'inicio_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  static const Color fondo = Color(0xFFEFF6FF);
  static const Color azul = Color(0xFF4D67BC);
  static const Color texto = Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _iniciarAplicacion();
  }

  Future<void> _iniciarAplicacion() async {
    // Esperar 5 segundos antes de entrar a la aplicación
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const InicioView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // LOGO OFICIAL DE SAFETAP
              Image.asset(
                'assets/images/safeTapLogo.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 25),

              // NOMBRE DE LA APLICACIÓN
              const Text(
                'SafeTap',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: azul,
                ),
              ),

              const SizedBox(height: 12),

              // FRASE DE BIENVENIDA
              const Text(
                'Aprende a usar tu celular',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: texto,
                ),
              ),

              const SizedBox(height: 45),

              // INDICADOR DE CARGA
              const CircularProgressIndicator(
                color: azul,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
