
class ProgresoWhatsappModel {
  final Set<String> leccionesCompletadas;

  ProgresoWhatsappModel({
    Set<String>? leccionesCompletadas,
  }) : leccionesCompletadas = leccionesCompletadas ?? {};

  bool estaCompletada(String id) {
    return leccionesCompletadas.contains(id);
  }

  void marcarCompletada(String id) {
    leccionesCompletadas.add(id);
  }

  void quitarCompletada(String id) {
    leccionesCompletadas.remove(id);
  }

  int get cantidadCompletadas => leccionesCompletadas.length;

  double porcentaje(int totalLecciones) {
    if (totalLecciones <= 0) return 0;

    return cantidadCompletadas / totalLecciones;
  }

  Map<String, dynamic> toJson() {
    return {
      'leccionesCompletadas': leccionesCompletadas.toList(),
    };
  }

  factory ProgresoWhatsappModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProgresoWhatsappModel(
      leccionesCompletadas:
      Set<String>.from(json['leccionesCompletadas'] ?? []),
    );
  }
}
