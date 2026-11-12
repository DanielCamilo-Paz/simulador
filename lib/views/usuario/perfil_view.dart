import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  static const Color azul = Color(0xFF4D67BC);
  static const Color fondo = Color(0xFFEFF6FF);
  static const Color texto = Color(0xFF333333);

  String nombre = 'Usuario';
  int? edad;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      final guardado = prefs.getString('usuario_nombre')?.trim();
      nombre = (guardado == null || guardado.isEmpty) ? 'Usuario' : guardado;
      edad = prefs.getInt('usuario_edad');
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        title: const Text('Mi perfil', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: azul))
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCE6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded, size: 118, color: azul),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Mis datos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: texto),
              ),
              const SizedBox(height: 30),
              _dato(Icons.badge_outlined, 'Nombre', nombre),
              const SizedBox(height: 18),
              _dato(Icons.cake_outlined, 'Edad',
                  edad == null ? 'No registrada' : '$edad años'),
              const SizedBox(height: 35),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('REGRESAR AL INICIO',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dato(IconData icono, String etiqueta, String valor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: azul.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icono, color: azul, size: 34),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta, style: const TextStyle(fontSize: 15, color: Colors.black54)),
                const SizedBox(height: 5),
                Text(valor, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: texto)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
