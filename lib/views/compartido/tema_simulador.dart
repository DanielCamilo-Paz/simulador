
import 'package:flutter/material.dart';

class TemaSimulador extends StatelessWidget {
  final Widget child;

  const TemaSimulador({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final temaClaro = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFEFF6FF),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4D67BC),
        brightness: Brightness.light,
      ),
    );

    return Theme(
      data: temaClaro,
      child: child,
    );
  }
}
