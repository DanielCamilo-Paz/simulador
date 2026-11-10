
class ProgresoAplicacionModel {
  final String id;
  final String nombre;
  final double pesoMaximo;
  final int actividadesCompletadas;
  final int totalActividades;

  const ProgresoAplicacionModel({
    required this.id,
    required this.nombre,
    required this.pesoMaximo,
    required this.actividadesCompletadas,
    required this.totalActividades,
  });

  // Porcentaje completado dentro de esta aplicación.
  double get porcentajeIndividual {
    if (totalActividades <= 0) return 0.0;

    final resultado =
        (actividadesCompletadas / totalActividades) * 100;

    return resultado.clamp(0.0, 100.0).toDouble();
  }

  // Cuánto aporta esta aplicación al progreso general.
  double get aporteGeneral {
    return (porcentajeIndividual / 100) * pesoMaximo;
  }

  bool get completada {
    return totalActividades > 0 &&
        actividadesCompletadas >= totalActividades;
  }
}

class ProgresoGeneralModel {
  final List<ProgresoAplicacionModel> aplicaciones;

  const ProgresoGeneralModel({
    required this.aplicaciones,
  });

  // Suma los aportes de las cinco aplicaciones.
  double get porcentajeGeneral {
    final total = aplicaciones.fold<double>(
      0.0,
          (suma, aplicacion) =>
      suma + aplicacion.aporteGeneral,
    );

    return total.clamp(0.0, 100.0).toDouble();
  }

  int get aplicacionesCompletadas {
    return aplicaciones
        .where((aplicacion) => aplicacion.completada)
        .length;
  }

  int get totalAplicaciones => aplicaciones.length;
}
