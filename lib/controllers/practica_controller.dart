import '../models/practica.dart';
import '../models/paso.dart';

class PracticaController {
  Practica? practicaActual;
  int indicePasoActual = 0;
  int aciertos = 0;
  List<String> mensajes = [];

  void cargarPractica(Practica practica) {
    practicaActual = practica;
    indicePasoActual = 0;
    aciertos = 0;
    mensajes.clear();
  }

  Paso? get pasoActual =>
      (practicaActual != null && indicePasoActual < practicaActual!.pasos.length)
          ? practicaActual!.pasos[indicePasoActual]
          : null;

  bool verificarAccion(String accionUsuario) {
    if (pasoActual == null) return false;

    bool correcta = accionUsuario.trim().toLowerCase() ==
        pasoActual!.accionEsperada.trim().toLowerCase();

    if (correcta) {
      aciertos++;
      mensajes.add(pasoActual!.mensajeCorrecto);
      indicePasoActual++;
    } else {
      mensajes.add(pasoActual!.mensajeIncorrecto);
    }
    return correcta;
  }

  bool get termino =>
      practicaActual != null && indicePasoActual >= practicaActual!.pasos.length;

  double get porcentaje =>
      practicaActual != null && practicaActual!.pasos.isNotEmpty
          ? (aciertos / practicaActual!.pasos.length) * 100
          : 0;
}