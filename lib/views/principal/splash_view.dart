
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'inicio_view.dart';
import '../usuario/registro_view.dart';

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
    // Mostrar el logo durante 5 segundos.
    final espera = Future.delayed(const Duration(seconds: 2));

    // Comprobar si el adulto mayor ya se registró.
    final preferencias = await SharedPreferences.getInstance();
    final registrado =
        preferencias.getBool('usuario_registrado') ?? false;

    await espera;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => registrado
            ? const InicioView()
            : const RegistroView(),
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
