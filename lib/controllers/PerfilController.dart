
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilController extends ChangeNotifier {

  // ==========================================
  // DATOS DEL PERFIL
  // ==========================================

  String _nombre = 'Usuario';
  int? _edad;
  int _avatarSeleccionado = 0;
  bool _cargando = true;

  // ==========================================
  // GETTERS
  // ==========================================

  String get nombre => _nombre;

  int? get edad => _edad;

  int get avatarSeleccionado => _avatarSeleccionado;

  bool get cargando => _cargando;

  // ==========================================
  // CARGAR DATOS DEL PERFIL
  // ==========================================

  Future<void> cargarDatos() async {
    _cargando = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Recuperar nombre
      final nombreGuardado =
      prefs.getString('usuario_nombre')?.trim();

      _nombre = nombreGuardado == null ||
          nombreGuardado.isEmpty
          ? 'Usuario'
          : nombreGuardado;

      // Recuperar edad
      _edad = prefs.getInt('usuario_edad');

      // Recuperar avatar
      final avatarGuardado =
          prefs.getInt('perfil_avatar') ?? 0;

      _avatarSeleccionado =
      avatarGuardado == 0 || avatarGuardado == 1
          ? avatarGuardado
          : 0;

    } catch (e) {
      debugPrint('Error al cargar el perfil: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // ==========================================
  // ACTUALIZAR NOMBRE Y EDAD
  // ==========================================

  Future<void> actualizarDatos({
    required String nombre,
    required int edad,
  }) async {

    final nuevoNombre = nombre.trim();

    // Validar nombre
    if (nuevoNombre.isEmpty) {
      throw ArgumentError(
        'El nombre no puede estar vacío',
      );
    }

    // Validar edad
    if (edad < 1 || edad > 120) {
      throw ArgumentError(
        'La edad debe estar entre 1 y 120 años',
      );
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      // Guardar nombre
      final nombreGuardado = await prefs.setString(
        'usuario_nombre',
        nuevoNombre,
      );

      // Guardar edad
      final edadGuardada = await prefs.setInt(
        'usuario_edad',
        edad,
      );

      if (!nombreGuardado || !edadGuardada) {
        throw Exception(
          'No se pudieron guardar los datos',
        );
      }

      // Actualizar valores
      _nombre = nuevoNombre;
      _edad = edad;

      notifyListeners();

    } catch (e) {
      debugPrint('Error al actualizar el perfil: $e');
      rethrow;
    }
  }

  // ==========================================
  // CAMBIAR AVATAR
  // ==========================================

  Future<void> cambiarAvatar(int indice) async {

    // 0 = Hombre
    // 1 = Mujer

    if (indice != 0 && indice != 1) {
      throw ArgumentError(
        'El avatar seleccionado no es válido',
      );
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      // Guardar avatar seleccionado
      final guardado = await prefs.setInt(
        'perfil_avatar',
        indice,
      );

      if (!guardado) {
        throw Exception(
          'No se pudo guardar el avatar',
        );
      }

      // Actualizar avatar
      _avatarSeleccionado = indice;

      notifyListeners();

    } catch (e) {
      debugPrint('Error al cambiar el avatar: $e');
      rethrow;
    }
  }
}
