
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/usuario/usuario_model.dart';

class RegistroController extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  UsuarioModel? _usuario;
  bool _guardando = false;
  String? _mensajeError;

  UsuarioModel? get usuario => _usuario;
  bool get guardando => _guardando;
  String? get mensajeError => _mensajeError;

  // VALIDAR NOMBRE Y EDAD
  String? validarDatos({
    required String nombre,
    required String edad,
  }) {
    if (nombre.trim().isEmpty) {
      return 'Por favor, ingresa tu nombre.';
    }

    final edadNumero = int.tryParse(edad.trim());

    if (edadNumero == null ||
        edadNumero < 1 ||
        edadNumero > 120) {
      return 'Por favor, ingresa una edad válida.';
    }

    return null;
  }

  // REGISTRAR AL ADULTO MAYOR
  Future<bool> registrarUsuario({
    required String nombre,
    required String edad,
  }) async {
    if (_guardando) return false;

    _mensajeError = validarDatos(
      nombre: nombre,
      edad: edad,
    );

    if (_mensajeError != null) {
      notifyListeners();
      return false;
    }

    _guardando = true;
    notifyListeners();

    try {
      final nuevoUsuario = UsuarioModel(
        nombre: nombre.trim(),
        edad: int.parse(edad.trim()),
      );

      // 1. OBTENER O CREAR SESIÓN ANÓNIMA
      var usuarioAuth = supabase.auth.currentUser;

      if (usuarioAuth == null) {
        final respuesta =
        await supabase.auth.signInAnonymously();

        usuarioAuth = respuesta.user;
      }

      if (usuarioAuth == null) {
        throw Exception(
          'No se pudo crear la identidad del usuario.',
        );
      }

      // 2. GUARDAR LOS DATOS EN SUPABASE
      // El nombre de la tabla tiene U mayúscula.
      await supabase.from('Usuarios').upsert(
        {
          'id': usuarioAuth.id,
          'nombre': nuevoUsuario.nombre,
          'edad': nuevoUsuario.edad,
        },
        onConflict: 'id',
      );

      // 3. GUARDAR TAMBIÉN EN EL CELULAR
      final preferencias =
      await SharedPreferences.getInstance();

      final nombreGuardado = await preferencias.setString(
        'usuario_nombre',
        nuevoUsuario.nombre,
      );

      final edadGuardada = await preferencias.setInt(
        'usuario_edad',
        nuevoUsuario.edad,
      );

      if (!nombreGuardado || !edadGuardada) {
        throw Exception(
          'No se pudieron guardar los datos locales.',
        );
      }

      final registroGuardado =
      await preferencias.setBool(
        'usuario_registrado',
        true,
      );

      if (!registroGuardado) {
        throw Exception(
          'No se pudo completar el registro local.',
        );
      }

      _usuario = nuevoUsuario;
      _mensajeError = null;

      return true;
    } on AuthException catch (e) {
      _mensajeError =
      'Error de autenticación: ${e.message}';
      return false;
    } on PostgrestException catch (e) {
      _mensajeError =
      'Error al guardar en Supabase: ${e.message}';
      return false;
    } catch (e) {
      _mensajeError =
      'No se pudo completar el registro: $e';
      return false;
    } finally {
      _guardando = false;
      notifyListeners();
    }
  }

  // COMPROBAR REGISTRO LOCAL
  Future<bool> estaRegistrado() async {
    final preferencias =
    await SharedPreferences.getInstance();

    return preferencias.getBool('usuario_registrado') ??
        false;
  }

  // RECUPERAR DATOS DEL USUARIO
  Future<UsuarioModel?> obtenerUsuario() async {
    final preferencias =
    await SharedPreferences.getInstance();

    final registrado =
        preferencias.getBool('usuario_registrado') ??
            false;

    if (!registrado) return null;

    final nombre =
    preferencias.getString('usuario_nombre');

    final edad =
    preferencias.getInt('usuario_edad');

    if (nombre == null || edad == null) {
      return null;
    }

    _usuario = UsuarioModel(
      nombre: nombre,
      edad: edad,
    );

    notifyListeners();

    return _usuario;
  }
}
