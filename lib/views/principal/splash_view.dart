
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
              // LOGO PROVISIONAL
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: azul,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: const Icon(
                  Icons.phone_android_rounded,
                  size: 95,
                  color: Colors.white,
                ),
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

              const Text(
                'Aprende a usar tu celular',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: texto,
                ),
              ),

              const SizedBox(height: 45),

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
