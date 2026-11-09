class Foto {
  final String ruta;
  final DateTime fecha;
  final bool importada;

  const Foto({
    required this.ruta,
    required this.fecha,
    this.importada = false,
  });
}

class EstadoPracticaCamara {
  bool fotoTrasera;
  bool selfie;

  bool galeriaAbierta;
  bool fotoVisualizada;
  bool fotoImportada;
  bool fotoEliminada;

  EstadoPracticaCamara({
    this.fotoTrasera = false,
    this.selfie = false,
    this.galeriaAbierta = false,
    this.fotoVisualizada = false,
    this.fotoImportada = false,
    this.fotoEliminada = false,
  });

  bool get practicaFotografiasCompletada => fotoTrasera && selfie;

  bool get practicaGaleriaCompletada =>
      galeriaAbierta &&
          fotoVisualizada &&
          fotoImportada &&
          fotoEliminada;

  int get progresoFotografias =>
      (fotoTrasera ? 1 : 0) + (selfie ? 1 : 0);

  int get progresoGaleria =>
      (galeriaAbierta ? 1 : 0) +
          (fotoVisualizada ? 1 : 0) +
          (fotoImportada ? 1 : 0) +
          (fotoEliminada ? 1 : 0);

  int get progresoGeneral =>
      (practicaFotografiasCompletada ? 50 : 0) +
          (practicaGaleriaCompletada ? 50 : 0);

  Map<String, dynamic> toJson() {
    return {
      'fotoTrasera': fotoTrasera,
      'selfie': selfie,
      'galeriaAbierta': galeriaAbierta,
      'fotoVisualizada': fotoVisualizada,
      'fotoImportada': fotoImportada,
      'fotoEliminada': fotoEliminada,
    };
  }

  factory EstadoPracticaCamara.fromJson(Map<String, dynamic> json) {
    return EstadoPracticaCamara(
      fotoTrasera: json['fotoTrasera'] == true,
      selfie: json['selfie'] == true,
      galeriaAbierta: json['galeriaAbierta'] == true,
      fotoVisualizada: json['fotoVisualizada'] == true,
      fotoImportada: json['fotoImportada'] == true,
      fotoEliminada: json['fotoEliminada'] == true,
    );
  }
}