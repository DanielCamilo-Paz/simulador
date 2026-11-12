
class UsuarioModel {
  final String nombre;
  final int edad;

  const UsuarioModel({
    required this.nombre,
    required this.edad,
  });

  // Convertir los datos del usuario a un mapa.
  // Nos servirá posteriormente para Supabase.
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'edad': edad,
    };
  }

  // Crear un usuario a partir de datos almacenados.
  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      nombre: map['nombre'] as String,
      edad: map['edad'] as int,
    );
  }
}
