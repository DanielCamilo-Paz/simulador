import 'package:flutter/material.dart';
import '../models/practica.dart';
import '../models/paso.dart';
import 'simulador_view.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    final practicaLlamada = Practica(
      idPractica: 1,
      tema: "Hacer una llamada telefónica",
      descripcion: "Aprende paso a paso sin riesgo",
      pasos: [
        Paso(
          idPaso: 1,
          idPractica: 1,
          numeroPaso: 1,
          instruccion: "Paso 1: Toca el botón para abrir el teléfono",
          accionEsperada: "llamar",
          mensajeCorrecto: "¡Perfecto! Abriste el teléfono correctamente",
          mensajeIncorrecto: "Busca el botón verde que dice ABRIR TELÉFONO",
        ),
        Paso(
          idPaso: 2,
          idPractica: 1,
          numeroPaso: 2,
          instruccion: "Paso 2: Marca un número y presiona llamar",
          accionEsperada: "llamar",
          mensajeCorrecto: "¡Excelente! Ya sabes hacer una llamada 📞",
          mensajeIncorrecto: "Recuerda: marca un número y toca el botón verde",
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Simulador — Uso del Celular")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SimuladorView(practica: practicaLlamada),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 25),
            textStyle: const TextStyle(fontSize: 22),
          ),
          child: const Text("📞 PRÁCTICA: Hacer una llamada"),
        ),
      ),
    );
  }
}