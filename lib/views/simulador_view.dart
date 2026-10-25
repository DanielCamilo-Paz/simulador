import 'package:flutter/material.dart';
import '../controllers/practica_controller.dart';
import '../models/practica.dart';
import 'pantalla_llamada_sim.dart';

class SimuladorView extends StatefulWidget {
  final Practica practica;
  const SimuladorView({super.key, required this.practica});

  @override
  State<SimuladorView> createState() => _SimuladorViewState();
}

class _SimuladorViewState extends State<SimuladorView> {
  late PracticaController ctrl;
  String? mensaje;

  @override
  void initState() {
    super.initState();
    ctrl = PracticaController();
    ctrl.cargarPractica(widget.practica);
  }

  void _abrirTelefono() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaLlamadaSimulada(
          alCompletar: (numero) {
            setState(() {
              bool ok = ctrl.verificarAccion("llamar");
              mensaje = ok
                  ? "✅ ¡Bien hecho! Marcaste $numero y completaste la llamada"
                  : "❌ Inténtalo de nuevo";
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.practica.tema)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ctrl.termino ? _pantallaResultado() : _pantallaPaso(),
      ),
    );
  }

  Widget _pantallaPaso() {
    final paso = ctrl.pasoActual!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Paso ${ctrl.indicePasoActual + 1}",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        Text(paso.instruccion, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 35),
        ElevatedButton(
          onPressed: _abrirTelefono,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 25),
            textStyle: const TextStyle(fontSize: 22),
            backgroundColor: Colors.green[700],
          ),
          child: const Text("📞 ABRIR TELÉFONO"),
        ),
        const SizedBox(height: 25),
        if (mensaje != null)
          Text(mensaje!, style: const TextStyle(fontSize: 20)),
      ],
    );
  }

  Widget _pantallaResultado() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("🎉 ¡Práctica terminada!", style: TextStyle(fontSize: 32)),
          const SizedBox(height: 25),
          Text("Avance: ${ctrl.porcentaje.toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 35),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 22),
              textStyle: const TextStyle(fontSize: 22),
            ),
            child: const Text("Volver al inicio"),
          ),
        ],
      ),
    );
  }
}