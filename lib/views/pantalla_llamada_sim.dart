import 'package:flutter/material.dart';

class PantallaLlamadaSimulada extends StatefulWidget {
  final Function(String numero) alCompletar;

  const PantallaLlamadaSimulada({
    super.key,
    required this.alCompletar,
  });

  @override
  State<PantallaLlamadaSimulada> createState() => _PantallaLlamadaSimuladaState();
}

class _PantallaLlamadaSimuladaState extends State<PantallaLlamadaSimulada> {
  String numeroMarcado = "";
  bool estaLlamando = false;

  void _agregarDigito(String digito) {
    if (!estaLlamando) {
      setState(() {
        numeroMarcado += digito;
      });
    }
  }

  void _borrarUltimo() {
    setState(() {
      if (numeroMarcado.isNotEmpty) {
        numeroMarcado = numeroMarcado.substring(0, numeroMarcado.length - 1);
      }
    });
  }

  void _iniciarLlamada() {
    if (numeroMarcado.isEmpty) return;
    setState(() {
      estaLlamando = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          estaLlamando = false;
        });
        widget.alCompletar(numeroMarcado);
        Navigator.pop(context);
      }
    });
  }

  void _colgar() {
    setState(() {
      estaLlamando = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const Text(
                "📞 TELÉFONO SIMULADO",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      estaLlamando ? "Llamando a:" : "",
                      style: const TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                    Text(
                      numeroMarcado.isEmpty ? "Ingresa un número" : numeroMarcado,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    if (estaLlamando)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: Colors.green),
                      ),
                  ],
                ),
              ),
              if (!estaLlamando) ...[
                _fila(["1", "2", "3"]),
                _fila(["4", "5", "6"]),
                _fila(["7", "8", "9"]),
                _fila(["*", "0", "#"]),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: numeroMarcado.isNotEmpty ? _iniciarLlamada : null,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.call, size: 32),
                    ),
                    const SizedBox(width: 50),
                    IconButton(
                      onPressed: _borrarUltimo,
                      icon: const Icon(Icons.backspace, color: Colors.white, size: 32),
                    ),
                  ],
                ),
              ],
              if (estaLlamando)
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: FloatingActionButton(
                    onPressed: _colgar,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end, size: 36),
                  ),
                ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "← Volver sin llamar",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fila(List<String> digitos) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: digitos.map((d) {
          return ElevatedButton(
            onPressed: () => _agregarDigito(d),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 80),
              shape: const CircleBorder(),
              textStyle: const TextStyle(fontSize: 28),
            ),
            child: Text(d),
          );
        }).toList(),
      ),
    );
  }
}