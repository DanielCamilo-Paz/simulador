
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../controllers/registro_controller.dart';
import '../principal/inicio_view.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({super.key});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  static const Color fondo = Color(0xFFEFF6FF);
  static const Color azul = Color(0xFF4D67BC);
  static const Color texto = Color(0xFF333333);

  // CONTROLADOR MVC
  late final RegistroController registroController;

  // CONTROLADORES DE LOS CAMPOS
  final TextEditingController nombreController =
  TextEditingController();

  final TextEditingController edadController =
  TextEditingController();

  // RECONOCIMIENTO DE VOZ
  final stt.SpeechToText reconocimientoVoz =
  stt.SpeechToText();

  bool escuchando = false;
  bool vozDisponible = false;

  String campoActivo = '';
  String mensajeVoz = '';

  @override
  void initState() {
    super.initState();

    registroController = RegistroController();
    registroController.addListener(actualizarVista);

    inicializarVoz();
  }

  void actualizarVista() {
    if (mounted) {
      setState(() {});
    }
  }

  // INICIALIZAR RECONOCIMIENTO DE VOZ
  Future<void> inicializarVoz() async {
    try {
      final disponible = await reconocimientoVoz.initialize(
        onStatus: (estado) {
          if (!mounted) return;

          if (estado == 'done' ||
              estado == 'notListening') {
            setState(() {
              escuchando = false;
            });
          }
        },
        onError: (error) {
          if (!mounted) return;

          setState(() {
            escuchando = false;
            mensajeVoz =
            'No pudimos reconocer tu voz. '
                'Puedes intentarlo nuevamente.';
          });
        },
      );

      if (!mounted) return;

      setState(() {
        vozDisponible = disponible;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        vozDisponible = false;
      });
    }
  }

  // INICIAR DICTADO
  Future<void> iniciarDictado(String campo) async {
    if (registroController.guardando) return;

    if (escuchando) {
      await detenerDictado();
      return;
    }

    if (!vozDisponible) {
      await inicializarVoz();
    }

    if (!mounted) return;

    if (!vozDisponible) {
      mostrarMensaje(
        'El reconocimiento de voz no está disponible. '
            'Puedes escribir tus datos con el teclado.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      campoActivo = campo;
      escuchando = true;

      mensajeVoz = campo == 'nombre'
          ? 'Te escucho. Dime tu nombre.'
          : 'Te escucho. Dime cuántos años tienes.';
    });

    try {
      await reconocimientoVoz.listen(
        localeId: 'es_CO',
        listenFor: const Duration(seconds: 25),
        pauseFor: const Duration(seconds: 4),
        onResult: (resultado) {
          if (!mounted) return;

          final palabras =
          resultado.recognizedWords.trim();

          if (palabras.isEmpty) return;

          if (campoActivo == 'nombre') {
            nombreController.text = palabras;
          } else if (campoActivo == 'edad') {
            final edad = convertirEdad(palabras);

            edadController.text = edad ?? palabras;
          }

          setState(() {
            mensajeVoz = resultado.finalResult
                ? '¡Muy bien! Revisa que tus datos estén correctos.'
                : 'Estoy escuchando...';
          });
        },
      );

      if (!reconocimientoVoz.isListening && mounted) {
        setState(() {
          escuchando = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        escuchando = false;
        mensajeVoz =
        'No se pudo iniciar el micrófono.';
      });
    }
  }

  // DETENER DICTADO
  Future<void> detenerDictado() async {
    await reconocimientoVoz.stop();

    if (!mounted) return;

    setState(() {
      escuchando = false;
      mensajeVoz =
      'Dictado detenido. Revisa tus datos.';
    });
  }

  // CONVERTIR EDAD HABLADA A NÚMERO
  String? convertirEdad(String palabras) {
    final textoNormalizado = palabras
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll(RegExp(r'[.,;:!?]'), ' ')
        .trim();

    final numero =
    RegExp(r'\d+').firstMatch(textoNormalizado);

    if (numero != null) {
      return numero.group(0);
    }

    final unidades = <String, int>{
      'un': 1,
      'uno': 1,
      'una': 1,
      'dos': 2,
      'tres': 3,
      'cuatro': 4,
      'cinco': 5,
      'seis': 6,
      'siete': 7,
      'ocho': 8,
      'nueve': 9,
    };

    final especiales = <String, int>{
      'diez': 10,
      'once': 11,
      'doce': 12,
      'trece': 13,
      'catorce': 14,
      'quince': 15,
      'dieciseis': 16,
      'diecisiete': 17,
      'dieciocho': 18,
      'diecinueve': 19,
      'veinte': 20,
      'veintiuno': 21,
      'veintidos': 22,
      'veintitres': 23,
      'veinticuatro': 24,
      'veinticinco': 25,
      'veintiseis': 26,
      'veintisiete': 27,
      'veintiocho': 28,
      'veintinueve': 29,
    };

    final decenas = <String, int>{
      'treinta': 30,
      'cuarenta': 40,
      'cincuenta': 50,
      'sesenta': 60,
      'setenta': 70,
      'ochenta': 80,
      'noventa': 90,
    };

    if (textoNormalizado == 'cien' ||
        textoNormalizado == 'ciento') {
      return '100';
    }

    final palabrasSeparadas = textoNormalizado
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();

    int? valor;

    for (final palabra in palabrasSeparadas) {
      if (especiales.containsKey(palabra)) {
        valor = especiales[palabra];
        break;
      }

      if (decenas.containsKey(palabra)) {
        valor = decenas[palabra];
        continue;
      }

      if (unidades.containsKey(palabra)) {
        valor = (valor ?? 0) + unidades[palabra]!;
      }
    }

    return valor?.toString();
  }

  // REGISTRAR USUARIO UTILIZANDO MVC
  Future<void> registrarUsuario() async {
    if (registroController.guardando) return;

    if (escuchando) {
      await reconocimientoVoz.stop();

      if (!mounted) return;

      setState(() {
        escuchando = false;
      });
    }

    final registrado =
    await registroController.registrarUsuario(
      nombre: nombreController.text,
      edad: edadController.text,
    );

    if (!mounted) return;

    if (registrado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const InicioView(),
        ),
      );
    } else {
      mostrarMensaje(
        registroController.mensajeError ??
            'No se pudo completar el registro.',
      );
    }
  }

  // MOSTRAR MENSAJES
  void mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: const TextStyle(fontSize: 17),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    reconocimientoVoz.cancel();

    registroController.removeListener(actualizarVista);
    registroController.dispose();

    nombreController.dispose();
    edadController.dispose();

    super.dispose();
  }

  // CONSTRUIR CAMPOS DE REGISTRO
  Widget construirCampo({
    required String titulo,
    required String sugerencia,
    required TextEditingController controller,
    required String campo,
    required IconData icono,
    TextInputType tipoTeclado = TextInputType.text,
  }) {
    final activo =
        escuchando && campoActivo == campo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: controller,
          enabled: !registroController.guardando,
          keyboardType: tipoTeclado,
          textCapitalization: campo == 'nombre'
              ? TextCapitalization.words
              : TextCapitalization.none,
          style: const TextStyle(fontSize: 21),
          decoration: InputDecoration(
            hintText: sugerencia,
            prefixIcon: Icon(icono, color: azul),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(16),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 58,
          child: OutlinedButton.icon(
            onPressed: registroController.guardando
                ? null
                : () => iniciarDictado(campo),
            icon: Icon(
              activo
                  ? Icons.stop_circle
                  : Icons.mic,
              size: 28,
            ),
            label: Text(
              activo
                  ? 'DETENER DICTADO'
                  : 'DICTAR CON MI VOZ',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor:
              activo ? Colors.red : azul,
              side: BorderSide(
                color:
                activo ? Colors.red : azul,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        title: const Text('Registro en SafeTap'),
        backgroundColor: fondo,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/safeTapLogo.png',
                height: 110,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              const Text(
                '¡Bienvenido a SafeTap!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: azul,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Vamos a conocernos. '
                    'Solo necesitas registrarte una vez.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  color: texto,
                ),
              ),

              const SizedBox(height: 32),

              construirCampo(
                titulo: '¿Cómo te llamas?',
                sugerencia: 'Escribe tu nombre',
                controller: nombreController,
                campo: 'nombre',
                icono: Icons.person,
              ),

              const SizedBox(height: 30),

              construirCampo(
                titulo: '¿Cuántos años tienes?',
                sugerencia: 'Escribe tu edad',
                controller: edadController,
                campo: 'edad',
                icono: Icons.calendar_today,
                tipoTeclado: TextInputType.number,
              ),

              const SizedBox(height: 22),

              if (mensajeVoz.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0x2B4D67BC),
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        escuchando
                            ? Icons.hearing
                            : Icons.info_outline,
                        color: azul,
                        size: 28,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          mensajeVoz,
                          style: const TextStyle(
                            fontSize: 18,
                            color: texto,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 30),

              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed:
                  registroController.guardando
                      ? null
                      : registrarUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                  child: registroController.guardando
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    'REGISTRARME',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
