
class ProgresoModel {
  // PROGRESO DE RELOJ

  int actividadesRelojCompletadas = 0;
  final int totalActividadesReloj = 8;

  final Set<String> actividadesReloj = {};

  void completarActividadReloj(String actividad) {
    actividadesReloj.add(actividad);
    actividadesRelojCompletadas = actividadesReloj.length;
  }

  int obtenerPorcentajeReloj() {
    if (totalActividadesReloj == 0) return 0;

    return ((actividadesRelojCompletadas /
        totalActividadesReloj) *
        100)
        .round();
  }

  // Obtener las actividades completadas
  Set<String> obtenerActividadesReloj() {
    return Set.unmodifiable(actividadesReloj);
  }

  void reiniciarProgresoReloj() {
    actividadesReloj.clear();
    actividadesRelojCompletadas = 0;
  }


  // PROGRESO DE CALENDARIO

  int actividadesCalendarioCompletadas = 0;
  final int totalActividadesCalendario = 4;

  final Set<String> actividadesCalendario = {};

  void completarActividadCalendario(String actividad) {
    actividadesCalendario.add(actividad);
    actividadesCalendarioCompletadas =
        actividadesCalendario.length;
  }

  int obtenerPorcentajeCalendario() {
    if (totalActividadesCalendario == 0) return 0;

    return ((actividadesCalendarioCompletadas /
        totalActividadesCalendario) *
        100)
        .round();
  }

  Set<String> obtenerActividadesCalendario() {
    return Set.unmodifiable(actividadesCalendario);
  }

  void reiniciarProgresoCalendario() {
    actividadesCalendario.clear();
    actividadesCalendarioCompletadas = 0;
  }
}
