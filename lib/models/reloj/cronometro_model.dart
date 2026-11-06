class CronometroModel {
  String tiempo = '00:00:10';

  final List<String> vueltas = [];

  void actualizarTiempo(String nuevoTiempo) {
    tiempo = nuevoTiempo;
  }

  void guardarVuelta() {
    vueltas.add(tiempo);
  }

  void limpiarVueltas() {
    vueltas.clear();
  }

  void reiniciar() {
    tiempo = '00:00:00';
    vueltas.clear();
  }
}