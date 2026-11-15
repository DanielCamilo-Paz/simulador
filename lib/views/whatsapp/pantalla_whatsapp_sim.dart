import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../controllers/whatsapp_controller.dart';
import '../../models/whatsapp/leccion_whatsapp_model.dart';
import 'seleccion_lecciones_view.dart';
import '../compartido/tema_simulador.dart';

const Color verdeWhatsapp = Color(0xFF075E54);
const Color verdeClaro = Color(0xFF25D366);
const Color fondoWhatsapp = Color(0xFFF0F2F5);
const Color textoOscuro = Color(0xFF202C33);

const List<Map<String, dynamic>> contactosDemo = [
  {
    'nombre': 'David',
    'inicial': 'D',
    'color': Color(0xFF527DA3),
    'mensaje': '¡Hola! ¿Cómo estás?',
    'hora': '10:30',
  },
  {
    'nombre': 'María',
    'inicial': 'M',
    'color': Color(0xFFB66B91),
    'mensaje': 'Nos vemos pronto 😊',
    'hora': '09:45',
  },
  {
    'nombre': 'Juan',
    'inicial': 'J',
    'color': Color(0xFF699B75),
    'mensaje': 'Muchas gracias',
    'hora': 'Ayer',
  },
  {
    'nombre': 'Carlos',
    'inicial': 'C',
    'color': Color(0xFFB58B51),
    'mensaje': 'Te llamo más tarde',
    'hora': 'Ayer',
  },
];

// -----------------------------------------------------------------------------
// PANTALLA INICIAL
// -----------------------------------------------------------------------------

class PantallaWhatsappSim extends StatefulWidget {
  final WhatsappController controller;

  const PantallaWhatsappSim({
    super.key,
    required this.controller,
  });

  @override
  State<PantallaWhatsappSim> createState() =>
      _PantallaWhatsappSimState();
}

class _PantallaWhatsappSimState extends State<PantallaWhatsappSim> {
  void _abrirLecciones() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemaSimulador(
          child: SeleccionLeccionesView(
            controller: widget.controller,
            onSeleccionarLeccion: (LeccionWhatsappModel leccion) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TemaSimulador(
                    child: PantallaLeccionSim(
                      tipo: leccion.tipo,
                      titulo: leccion.titulo,
                      controller: widget.controller,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoWhatsapp,
      appBar: AppBar(
        backgroundColor: verdeWhatsapp,
        foregroundColor: Colors.white,
        title: const Text(
          'WhatsApp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
              decoration: const BoxDecoration(
                color: verdeWhatsapp,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Aprendamos a usar WhatsApp!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    'Practica paso a paso y descubre cómo comunicarte con tus familiares y amigos.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  const Text(
                    '¿Qué quieres aprender hoy?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textoOscuro,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _TarjetaOpcion(
                    icono: Icons.school_rounded,
                    color: verdeClaro,
                    titulo: 'Ver las actividades',
                    descripcion:
                    'Elige una actividad y aprende paso a paso.',
                    onTap: _abrirLecciones,
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: verdeWhatsapp,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Puedes repetir las actividades todas las veces que quieras.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TARJETA DE OPCIÓN
// -----------------------------------------------------------------------------

class _TarjetaOpcion extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String titulo;
  final String descripcion;
  final VoidCallback onTap;

  const _TarjetaOpcion({
    required this.icono,
    required this.color,
    required this.titulo,
    required this.descripcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icono, color: color, size: 29),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: textoOscuro,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      descripcion,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PANTALLA DE LECCIONES
// -----------------------------------------------------------------------------

class PantallaLeccionSim extends StatefulWidget {
  final String tipo;
  final String titulo;
  final WhatsappController controller;

  const PantallaLeccionSim({
    super.key,
    required this.tipo,
    required this.titulo,
    required this.controller,
  });

  @override
  State<PantallaLeccionSim> createState() =>
      _PantallaLeccionSimState();
}

class _PantallaLeccionSimState extends State<PantallaLeccionSim> {
  final TextEditingController mensajeController = TextEditingController();
  final TextEditingController busquedaController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  StreamSubscription<PlayerState>? _playerSubscription;

  final Map<String, List<String>> _mensajesPorContacto = {};
  final Map<String, List<String>> _audiosPorContacto = {};
  final Map<String, List<XFile>> _fotosPorContacto = {};

  String contacto = '';

  XFile? fotoBorrador;
  XFile? fotoEstado;
  String? estadoPublicado;

  String? audioBorrador;
  String? audioReproduciendose;

  bool grabando = false;
  bool reproduciendo = false;
  bool llamadaActiva = false;
  bool llamadaFinalizada = false;
  bool estadoFotoPublicada = false;
  bool _operacionAudio = false;
  bool _solicitoDetenerGrabacion = false;

  bool _mostrandoContactos = false;
  bool _silenciado = false;
  bool _altavoz = false;
  bool _videoActivado = false;

  int _pasoActual = 0;
  bool _guiaIniciada = false;
  bool _guiaCompletada = false;
  bool _dialogoGuiaAbierto = false;

  bool _audioEscuchado = false;
  bool _controlLlamadaUtilizado = false;
  bool _estadoDemoAbierto = false;
  bool _mensajeEscrito = false;
  bool _contactoBuscado = false;
  bool _resultadoConfirmado = false;

  List<String> get mensajesEnviados =>
      _mensajesPorContacto.putIfAbsent(contacto, () => []);

  List<String> get audiosEnviados =>
      _audiosPorContacto.putIfAbsent(contacto, () => []);

  List<XFile> get fotosEnviadas =>
      _fotosPorContacto.putIfAbsent(contacto, () => []);

  List<Map<String, dynamic>> get _pasosGuia {
    switch (widget.tipo) {
      case 'mensajes':
        return [
          {
            'titulo': 'Selecciona un contacto',
            'contenido': 'Elige a la persona con quien quieres conversar.',
            'icono': Icons.person_search,
          },
          {
            'titulo': 'Escribe tu mensaje',
            'contenido':
            'En el campo de texto de la parte inferior, escribe un mensaje.',
            'icono': Icons.edit,
          },
          {
            'titulo': 'Envía el mensaje',
            'contenido': 'Pulsa el botón verde con el símbolo de enviar.',
            'icono': Icons.send,
          },
        ];

      case 'audios':
        return [
          {
            'titulo': 'Selecciona un contacto',
            'contenido':
            'Elige a la persona a quien quieres enviar una nota de voz.',
            'icono': Icons.person_search,
          },
          {
            'titulo': 'Ubica el micrófono',
            'contenido':
            'En la parte inferior encontrarás el botón del micrófono.',
            'icono': Icons.mic,
          },
          {
            'titulo': 'Graba tu audio',
            'contenido':
            'Mantén presionado el micrófono mientras hablas. Suéltalo cuando termines.',
            'icono': Icons.mic_none,
          },
          {
            'titulo': 'Escucha tu grabación',
            'contenido':
            'Pulsa el botón de reproducción y escucha el audio completo.',
            'icono': Icons.play_circle,
          },
          {
            'titulo': 'Envía el audio',
            'contenido':
            'Cuando estés satisfecho con tu grabación, pulsa Enviar.',
            'icono': Icons.send,
          },
        ];

      case 'llamadas':
        return [
          {
            'titulo': 'Selecciona un contacto',
            'contenido':
            'Elige a la persona con quien deseas realizar una llamada.',
            'icono': Icons.person_search,
          },
          {
            'titulo': 'Inicia la llamada',
            'contenido':
            'Pulsa el botón Llamar para iniciar una llamada de demostración.',
            'icono': Icons.call,
          },
          {
            'titulo': 'Conoce los controles',
            'contenido':
            'Prueba alguno de los controles de llamada, como silenciar o activar el altavoz.',
            'icono': Icons.settings_phone,
          },
          {
            'titulo': 'Finaliza la llamada',
            'contenido':
            'Pulsa el botón rojo para finalizar la llamada simulada.',
            'icono': Icons.call_end,
          },
        ];

      case 'fotos':
        return [
          {
            'titulo': 'Selecciona un contacto',
            'contenido':
            'Elige a la persona con quien quieres compartir una fotografía.',
            'icono': Icons.person_search,
          },
          {
            'titulo': 'Abre la galería o cámara',
            'contenido':
            'Pulsa el botón para adjuntar una fotografía o utiliza la cámara.',
            'icono': Icons.photo_camera,
          },
          {
            'titulo': 'Revisa la fotografía',
            'contenido':
            'Selecciona una imagen y observa su vista previa antes de enviarla.',
            'icono': Icons.image,
          },
          {
            'titulo': 'Envía la fotografía',
            'contenido':
            'Si estás satisfecho con la imagen, pulsa Enviar fotografía.',
            'icono': Icons.send,
          },
        ];

      case 'estados':
        return [
          {
            'titulo': 'Observa los estados',
            'contenido':
            'En Actualizaciones recientes puedes encontrar los estados de tus contactos. Abre uno para visualizarlo.',
            'icono': Icons.visibility,
          },
          {
            'titulo': 'Crea una actualización',
            'contenido':
            'Pulsa Mi estado o el botón de agregar. Puedes crear un estado de texto o compartir una fotografía.',
            'icono': Icons.add_circle_outline,
          },
          {
            'titulo': 'Publica tu estado',
            'contenido':
            'Cuando hayas escrito tu mensaje o seleccionado tu fotografía, pulsa Publicar estado.',
            'icono': Icons.send,
          },
        ];

      case 'contactos':
        return [
          {
            'titulo': 'Ubica el buscador',
            'contenido':
            'Pulsa el campo de búsqueda para comenzar a buscar contactos.',
            'icono': Icons.search,
          },
          {
            'titulo': 'Escribe un nombre',
            'contenido':
            'Escribe el nombre de una persona, por ejemplo, María.',
            'icono': Icons.edit,
          },
          {
            'titulo': 'Identifica el resultado',
            'contenido':
            'Observa el contacto que coincide con lo que escribiste y selecciónalo.',
            'icono': Icons.person_search,
          },
          {
            'titulo': 'Abre el contacto',
            'contenido':
            'Pulsa nuevamente el contacto para consultar su información.',
            'icono': Icons.contact_page,
          },
        ];

      default:
        return [];
    }
  }

  @override
  void initState() {
    super.initState();

    _playerSubscription =
        _audioPlayer.onPlayerStateChanged.listen((estado) {
          if (!mounted) return;

          if (estado == PlayerState.completed) {
            final audioTerminado = widget.tipo == 'audios' &&
                audioBorrador != null &&
                audioReproduciendose == audioBorrador &&
                !_audioEscuchado;

            setState(() {
              reproduciendo = false;
              audioReproduciendose = null;
            });

            if (audioTerminado) {
              _audioEscuchado = true;

              if (_pasoActual == 3) {
                _avanzarGuia();
              }

              _mostrarMensaje(
                '¡Muy bien! Has escuchado tu grabación completa.',
              );
            }
          } else {
            setState(() {
              reproduciendo = estado == PlayerState.playing;

              if (estado == PlayerState.stopped) {
                audioReproduciendose = null;
              }
            });
          }
        });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _mostrarBienvenida();
    });
  }

  @override
  void dispose() {
    mensajeController.dispose();
    busquedaController.dispose();
    estadoController.dispose();

    _playerSubscription?.cancel();
    _audioPlayer.dispose();
    _recorder.dispose();

    super.dispose();
  }

  void _mensajeGuia({
    required IconData icono,
    required String titulo,
    required String contenido,
    required String textoBoton,
    VoidCallback? accion,
  }) {
    if (!mounted || _dialogoGuiaAbierto) return;

    _dialogoGuiaAbierto = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contextDialogo) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Icon(icono, color: verdeWhatsapp, size: 42),
          title: Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            contenido,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verdeWhatsapp,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.pop(contextDialogo);
                _dialogoGuiaAbierto = false;
                accion?.call();
              },
              child: Text(textoBoton),
            ),
          ],
        );
      },
    ).then((_) {
      _dialogoGuiaAbierto = false;
    });
  }

  void _mostrarBienvenida() {
    if (!mounted || _guiaIniciada) return;

    _guiaIniciada = true;

    _mensajeGuia(
      icono: Icons.school_rounded,
      titulo: '¡Vamos a practicar!',
      contenido:
      'En esta actividad aprenderás ${widget.titulo.toLowerCase()} paso a paso. Sigue las indicaciones y realiza cada acción para completar la práctica.',
      textoBoton: 'Comenzar',
      accion: _mostrarPasoActual,
    );
  }

  void _mostrarPasoActual() {
    if (!mounted || _guiaCompletada) return;

    if (_pasoActual >= _pasosGuia.length) {
      _completarGuia();
      return;
    }

    final paso = _pasosGuia[_pasoActual];

    _mensajeGuia(
      icono: paso['icono'] as IconData,
      titulo: 'Paso ${_pasoActual + 1}: ${paso['titulo']}',
      contenido: paso['contenido'] as String,
      textoBoton: 'Entendido',
    );
  }

  void _mostrarAyuda() {
    if (_guiaCompletada) {
      _mensajeGuia(
        icono: Icons.check_circle,
        titulo: 'Práctica completada',
        contenido:
        'Ya terminaste esta actividad. Puedes repetirla para seguir practicando.',
        textoBoton: 'Entendido',
      );
      return;
    }

    if (!_guiaIniciada) {
      _mostrarBienvenida();
      return;
    }

    _mostrarPasoActual();
  }

  void _avanzarGuia() {
    if (!mounted || _guiaCompletada) return;

    _pasoActual++;

    if (_pasoActual >= _pasosGuia.length) {
      _completarGuia();
    } else {
      _mostrarPasoActual();
    }
  }

  Future<void> _completarGuia() async {
    if (!mounted || _guiaCompletada) return;

    setState(() {
      _guiaCompletada = true;
    });

    await widget.controller.marcarCompletada(widget.tipo);

    if (!mounted) return;

    _mensajeGuia(
      icono: Icons.emoji_events,
      titulo: '¡Lección completada!',
      contenido:
      '¡Excelente trabajo! Has realizado correctamente todas las actividades de ${widget.titulo.toLowerCase()}. Tu progreso ha sido registrado.',
      textoBoton: 'Finalizar',
    );
  }

  Map<String, dynamic>? get _contactoActual {
    for (final c in contactosDemo) {
      if (c['nombre'] == contacto) return c;
    }
    return null;
  }

  void _seleccionarContacto(String nombre) {
    setState(() {
      contacto = nombre;
      _mostrandoContactos = false;
      mensajeController.clear();
      fotoBorrador = null;
      audioBorrador = null;
      llamadaFinalizada = false;
    });

    if (widget.tipo == 'mensajes' ||
        widget.tipo == 'audios' ||
        widget.tipo == 'llamadas' ||
        widget.tipo == 'fotos') {
      if (_pasoActual == 0) {
        _avanzarGuia();
      }
    }
  }

  void _mostrarMensaje(String texto) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _enviarMensaje() {
    final texto = mensajeController.text.trim();

    if (texto.isEmpty) {
      _mostrarMensaje('Primero debes escribir un mensaje.');
      return;
    }

    if (widget.tipo == 'mensajes' && _pasoActual < 2) {
      _mostrarMensaje(
        'Completa primero el paso de escribir el mensaje.',
      );
      return;
    }

    setState(() {
      mensajesEnviados.add(texto);
      mensajeController.clear();
    });

    _mensajeEscrito = false;

    _mostrarMensaje('¡Muy bien! Tu mensaje fue enviado.');

    if (widget.tipo == 'mensajes' && _pasoActual == 2) {
      _avanzarGuia();
    }
  }

  void _iniciarLlamada() {
    setState(() {
      llamadaActiva = true;
      llamadaFinalizada = false;
      _controlLlamadaUtilizado = false;
    });

    if (widget.tipo == 'llamadas' && _pasoActual == 1) {
      _avanzarGuia();
    }
  }

  void _usarControlLlamada(String control) {
    setState(() {
      if (control == 'Silenciar') {
        _silenciado = !_silenciado;
      } else if (control == 'Altavoz') {
        _altavoz = !_altavoz;
      } else {
        _videoActivado = !_videoActivado;
      }
    });

    if (!_controlLlamadaUtilizado &&
        widget.tipo == 'llamadas' &&
        _pasoActual == 2) {
      _controlLlamadaUtilizado = true;
      _avanzarGuia();
    }
  }

  void _finalizarLlamada() {
    setState(() {
      llamadaActiva = false;
      llamadaFinalizada = true;
    });

    _mostrarMensaje(
      '¡Muy bien! Has finalizado la llamada simulada.',
    );

    if (widget.tipo == 'llamadas' && _pasoActual == 3) {
      _avanzarGuia();
    }
  }

  Future<void> _abrirGaleria({bool paraEstado = false}) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (contextModal) {
        return TemaSimulador(
          child: SafeArea(
            child: Wrap(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    'Selecciona una fotografía',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE4F4EA),
                    child: Icon(
                      Icons.photo_library,
                      color: verdeWhatsapp,
                    ),
                  ),
                  title: const Text('Abrir galería'),
                  subtitle: const Text(
                    'Elegir una foto de tu dispositivo',
                  ),
                  onTap: () {
                    Navigator.pop(contextModal);
                    _seleccionarImagen(
                      ImageSource.gallery,
                      paraEstado: paraEstado,
                    );
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE4F4EA),
                    child: Icon(
                      Icons.camera_alt,
                      color: verdeWhatsapp,
                    ),
                  ),
                  title: const Text('Tomar una fotografía'),
                  subtitle: const Text(
                    'Abrir la cámara del dispositivo',
                  ),
                  onTap: () {
                    Navigator.pop(contextModal);
                    _seleccionarImagen(
                      ImageSource.camera,
                      paraEstado: paraEstado,
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _seleccionarImagen(
      ImageSource origen, {
        bool paraEstado = false,
      }) async {
    try {
      final XFile? imagen = await _imagePicker.pickImage(
        source: origen,
        imageQuality: 85,
      );

      if (!mounted || imagen == null) return;

      setState(() {
        if (paraEstado) {
          fotoEstado = imagen;
          estadoFotoPublicada = false;
        } else {
          fotoBorrador = imagen;
        }
      });

      if (!paraEstado) {
        _mostrarMensaje(
          'Fotografía seleccionada. Revisa la vista previa.',
        );

        if (widget.tipo == 'fotos' && _pasoActual == 1) {
          _avanzarGuia();
        }
      } else {
        _mostrarMensaje(
          'Fotografía seleccionada. Pulsa Publicar estado para compartirla.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje(
        'No se pudo abrir la cámara o la galería. Inténtalo nuevamente.',
      );
    }
  }

  void _enviarFoto() {
    if (fotoBorrador == null) {
      _mostrarMensaje('Primero selecciona una fotografía.');
      return;
    }

    if (widget.tipo == 'fotos' && _pasoActual < 3) {
      _mostrarMensaje(
        'Primero revisa la vista previa de la fotografía.',
      );
      return;
    }

    setState(() {
      fotosEnviadas.add(fotoBorrador!);
      fotoBorrador = null;
    });

    _mostrarMensaje('¡Fotografía enviada correctamente!');

    if (widget.tipo == 'fotos' && _pasoActual == 3) {
      _avanzarGuia();
    }
  }

  void _cancelarFoto() {
    setState(() {
      fotoBorrador = null;
    });
  }

  // ---------------------------------------------------------------------------
  // AUDIO: INICIO Y DETENCIÓN DE GRABACIÓN CORREGIDOS
  // ---------------------------------------------------------------------------

  Future<void> _iniciarGrabacion() async {
    if (grabando || _operacionAudio) return;

    _operacionAudio = true;
    _solicitoDetenerGrabacion = false;

    try {
      final tienePermiso = await _recorder.hasPermission();

      if (!tienePermiso) {
        _mostrarMensaje(
          'Debes permitir el acceso al micrófono para grabar un audio.',
        );
        return;
      }

      final directorio = await getApplicationDocumentsDirectory();

      final ruta = p.join(
        directorio.path,
        'safetap_audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
      );

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
        ),
        path: ruta,
      );

      if (!mounted) return;

      setState(() {
        grabando = true;
        audioBorrador = null;
        _audioEscuchado = false;
      });

      _mostrarMensaje(
        'Grabando... Suelta el micrófono para terminar.',
      );

      if (widget.tipo == 'audios' && _pasoActual == 1) {
        _avanzarGuia();
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensaje(
          'No se pudo iniciar la grabación. Revisa el permiso del micrófono.',
        );
      }
    } finally {
      _operacionAudio = false;

      if (_solicitoDetenerGrabacion && grabando) {
        _solicitoDetenerGrabacion = false;
        await _detenerGrabacion();
      }
    }
  }

  Future<void> _detenerGrabacion() async {
    if (_operacionAudio) {
      _solicitoDetenerGrabacion = true;
      return;
    }

    if (!grabando) return;

    _operacionAudio = true;

    try {
      final ruta = await _recorder.stop();

      if (!mounted) return;

      setState(() {
        grabando = false;
        audioBorrador = ruta;
      });

      if (ruta != null) {
        _mostrarMensaje(
          'Audio grabado. Escúchalo antes de enviarlo.',
        );

        if (widget.tipo == 'audios' && _pasoActual == 2) {
          _avanzarGuia();
        }
      } else {
        _mostrarMensaje('No se pudo guardar la grabación.');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        grabando = false;
      });

      _mostrarMensaje(
        'Ocurrió un error al terminar la grabación.',
      );
    } finally {
      _operacionAudio = false;
    }
  }

  Future<void> _reproducirAudio(String ruta) async {
    try {
      if (audioReproduciendose == ruta && reproduciendo) {
        await _audioPlayer.pause();
        return;
      }

      await _audioPlayer.stop();

      setState(() {
        audioReproduciendose = ruta;
      });

      await _audioPlayer.play(DeviceFileSource(ruta));
    } catch (e) {
      _mostrarMensaje('No se pudo reproducir este audio.');
    }
  }

  Future<void> _enviarAudio() async {
    if (audioBorrador == null) {
      _mostrarMensaje('Primero debes grabar un audio.');
      return;
    }

    if (widget.tipo == 'audios' && !_audioEscuchado) {
      _mostrarMensaje(
        'Primero escucha tu grabación completa antes de enviarla.',
      );
      return;
    }

    if (widget.tipo == 'audios' && _pasoActual < 4) {
      _mostrarMensaje(
        'Completa los pasos anteriores primero.',
      );
      return;
    }

    final ruta = audioBorrador!;

    setState(() {
      audiosEnviados.add(ruta);
      audioBorrador = null;
    });

    _mostrarMensaje('¡Audio enviado correctamente!');

    if (widget.tipo == 'audios' && _pasoActual == 4) {
      _avanzarGuia();
    }
  }

  void _descartarAudio() {
    setState(() {
      audioBorrador = null;
      _audioEscuchado = false;
    });
  }

  // ---------------------------------------------------------------------------
  // ESTADOS
  // -----------------------------------------------------------------------------

  void _publicarEstadoTexto() {
    final texto = estadoController.text.trim();

    if (texto.isEmpty) {
      _mostrarMensaje('Escribe un mensaje antes de publicar.');
      return;
    }

    if (widget.tipo == 'estados' && _pasoActual < 2) {
      _mostrarMensaje(
        'Completa primero los pasos anteriores.',
      );
      return;
    }

    setState(() {
      estadoPublicado = texto;
      fotoEstado = null;
      estadoFotoPublicada = false;
      estadoController.clear();
    });

    _mostrarMensaje('¡Tu estado de texto ha sido publicado!');

    if (widget.tipo == 'estados' && _pasoActual == 2) {
      _avanzarGuia();
    }
  }

  void _publicarEstadoFoto() {
    if (fotoEstado == null) {
      _mostrarMensaje('Primero selecciona una fotografía.');
      return;
    }

    if (widget.tipo == 'estados' && _pasoActual < 2) {
      _mostrarMensaje(
        'Completa primero los pasos anteriores.',
      );
      return;
    }

    setState(() {
      estadoFotoPublicada = true;
      estadoPublicado = null;
    });

    _mostrarMensaje('¡Tu fotografía se publicó como estado!');

    if (widget.tipo == 'estados' && _pasoActual == 2) {
      _avanzarGuia();
    }
  }

  void _verEstadoDemo({
    required String nombre,
    required String texto,
    required Color color,
    required String emoji,
  }) {
    showDialog(
      context: context,
      builder: (contextDialogo) {
        return Dialog(
          insetPadding: const EdgeInsets.all(18),
          child: Container(
            height: MediaQuery.of(contextDialogo).size.height * 0.65,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Text(
                          nombre[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(contextDialogo);

                          if (!_estadoDemoAbierto &&
                              widget.tipo == 'estados' &&
                              _pasoActual == 0) {
                            _estadoDemoAbierto = true;
                            _avanzarGuia();
                          }
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 85),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(
                    texto,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Estado de demostración',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _verMiEstado() {
    if (!estadoFotoPublicada && estadoPublicado == null) return;

    showDialog(
      context: context,
      builder: (contextDialogo) {
        return Dialog(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              color: const Color(0xFF315B53),
              constraints: const BoxConstraints(maxHeight: 550),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: const Text(
                      'Mi estado',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () => Navigator.pop(contextDialogo),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (fotoEstado != null && estadoFotoPublicada)
                    Image.file(
                      File(fotoEstado!.path),
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.contain,
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(35),
                      child: Text(
                        estadoPublicado ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Tu estado está publicado en este simulador',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarOpcionesEstado() {
    showModalBottomSheet(
      context: context,
      builder: (contextModal) {
        return TemaSimulador(
          child: SafeArea(
            child: Wrap(
              children: [
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'Crear una actualización',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF6D5BA6),
                    child: Icon(Icons.text_fields, color: Colors.white),
                  ),
                  title: const Text('Crear estado de texto'),
                  onTap: () {
                    Navigator.pop(contextModal);

                    if (widget.tipo == 'estados' && _pasoActual == 1) {
                      _avanzarGuia();
                    }

                    _abrirEditorEstado();
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF3D967D),
                    child: Icon(Icons.photo, color: Colors.white),
                  ),
                  title: const Text('Compartir una foto'),
                  onTap: () {
                    Navigator.pop(contextModal);

                    if (widget.tipo == 'estados' && _pasoActual == 1) {
                      _avanzarGuia();
                    }

                    _abrirGaleria(paraEstado: true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _abrirEditorEstado() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF5C548D),
      builder: (contextModal) {
        return TemaSimulador(
          child: StatefulBuilder(
            builder: (contextModal, setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 25,
                  bottom:
                  MediaQuery.of(contextModal).viewInsets.bottom + 25,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Crear estado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: estadoController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                      onChanged: (_) => setModalState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Escribe lo que quieras compartir',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: estadoController.text.trim().isEmpty
                            ? null
                            : () {
                          Navigator.pop(contextModal);
                          _publicarEstadoTexto();
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Publicar estado'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _abrirFichaContacto(String nombre) {
    if (!_contactoBuscado || !_resultadoConfirmado) {
      _mostrarMensaje('Primero busca e identifica un contacto.');
      return;
    }

    setState(() {
      contacto = nombre;
    });

    if (widget.tipo == 'contactos' && _pasoActual == 3) {
      _avanzarGuia();
    }
  }

  void _seleccionarResultadoContacto(String nombre) {
    if (!_contactoBuscado) {
      _mostrarMensaje(
        'Primero escribe un nombre en el buscador.',
      );
      return;
    }

    if (!_resultadoConfirmado && _pasoActual == 2) {
      setState(() {
        _resultadoConfirmado = true;
      });

      _avanzarGuia();
      return;
    }

    _abrirFichaContacto(nombre);
  }

  @override
  Widget build(BuildContext context) {
    if (llamadaActiva) {
      return _pantallaLlamada();
    }

    return Scaffold(
      backgroundColor: fondoWhatsapp,
      appBar: AppBar(
        backgroundColor: verdeWhatsapp,
        foregroundColor: Colors.white,
        title: Text(
          _mostrandoContactos
              ? 'Nuevo chat'
              : widget.tipo == 'contactos'
              ? 'Contactos'
              : widget.tipo == 'estados'
              ? 'Novedades'
              : contacto.isEmpty
              ? 'WhatsApp'
              : contacto,
        ),
        leading: _mostrandoContactos || contacto.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _mostrandoContactos = false;
              contacto = '';
            });
          },
        )
            : null,
        actions: [
          IconButton(
            tooltip: 'Ayuda de la práctica',
            icon: const Icon(Icons.help_outline),
            onPressed: _mostrarAyuda,
          ),
          if (widget.tipo != 'contactos' &&
              widget.tipo != 'estados' &&
              !_mostrandoContactos &&
              contacto.isEmpty)
            IconButton(
              tooltip: 'Buscar contactos',
              icon: const Icon(Icons.search),
              onPressed: _abrirNuevoChat,
            ),
          IconButton(
            tooltip: 'Volver a elegir lección',
            icon: const Icon(Icons.list_alt),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _contenidoLeccion(),
    );
  }

  void _abrirNuevoChat() {
    setState(() {
      _mostrandoContactos = true;
      busquedaController.clear();
    });
  }

  Widget _contenidoLeccion() {
    switch (widget.tipo) {
      case 'mensajes':
        if (_mostrandoContactos) {
          return _listaContactos(
            titulo: 'Selecciona un contacto',
            buscador: true,
            onSeleccionar: _seleccionarContacto,
          );
        }
        return contacto.isEmpty ? _listaChats() : _leccionMensajes();

      case 'audios':
        if (_mostrandoContactos) {
          return _listaContactos(
            titulo: 'Selecciona un contacto',
            buscador: true,
            onSeleccionar: _seleccionarContacto,
          );
        }
        return contacto.isEmpty ? _listaChats() : _leccionAudios();

      case 'llamadas':
        if (_mostrandoContactos) {
          return _listaContactos(
            titulo: 'Selecciona un contacto',
            buscador: true,
            onSeleccionar: _seleccionarContacto,
          );
        }
        return contacto.isEmpty ? _listaChats() : _leccionLlamadas();

      case 'fotos':
        if (_mostrandoContactos) {
          return _listaContactos(
            titulo: 'Selecciona un contacto',
            buscador: true,
            onSeleccionar: _seleccionarContacto,
          );
        }
        return contacto.isEmpty ? _listaChats() : _leccionFotos();

      case 'estados':
        return _leccionEstados();

      case 'contactos':
        return _leccionContactos();

      default:
        return const Center(
          child: Text('Lección no disponible'),
        );
    }
  }

  Widget _listaChats() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...contactosDemo.map(
                    (c) => _FilaContacto(
                  contacto: c,
                  onTap: () => _seleccionarContacto(
                    c['nombre'] as String,
                  ),
                  esChat: true,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: verdeClaro,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _abrirNuevoChat,
              icon: const Icon(Icons.chat),
              label: const Text('Nuevo chat'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listaContactos({
    required String titulo,
    required ValueChanged<String> onSeleccionar,
    bool buscador = false,
  }) {
    final texto = busquedaController.text.toLowerCase().trim();

    final filtrados = contactosDemo.where((c) {
      return (c['nombre'] as String).toLowerCase().contains(texto);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: textoOscuro,
            ),
          ),
        ),
        if (buscador)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: busquedaController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar nombre',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        Expanded(
          child: filtrados.isEmpty
              ? const Center(
            child: Text('No se encontraron contactos'),
          )
              : ListView(
            children: filtrados.map((c) {
              return _FilaContacto(
                contacto: c,
                onTap: () => onSeleccionar(
                  c['nombre'] as String,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _leccionMensajes() {
    return _chatBase(
      contenido: [
        const _BurbujaChat(
          texto: '¡Hola! ¿Cómo estás?',
          esMio: false,
          hora: '10:30',
        ),
        ...mensajesEnviados.map(
              (mensaje) => _BurbujaChat(
            texto: mensaje,
            esMio: true,
            hora: '10:32',
          ),
        ),
      ],
      campo: Row(
        children: [
          Expanded(
            child: TextField(
              controller: mensajeController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (texto) {
                if (widget.tipo == 'mensajes' &&
                    _pasoActual == 1 &&
                    texto.trim().isNotEmpty &&
                    !_mensajeEscrito) {
                  _mensajeEscrito = true;
                  _avanzarGuia();
                }
              },
              onSubmitted: (_) => _enviarMensaje(),
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: verdeClaro,
            child: IconButton(
              tooltip: 'Enviar mensaje',
              onPressed: _enviarMensaje,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leccionAudios() {
    return _chatBase(
      contenido: [
        const _BurbujaChat(
          texto: 'Hola, ¿puedes enviarme un audio?',
          esMio: false,
          hora: '10:30',
        ),
        ...audiosEnviados.map(
              (ruta) => _BurbujaAudio(
            ruta: ruta,
            esMio: true,
            reproduciendo:
            audioReproduciendose == ruta && reproduciendo,
            onTap: () => _reproducirAudio(ruta),
          ),
        ),
      ],
      campo: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (audioBorrador != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.audiotrack, color: verdeWhatsapp),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Audio listo para enviar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Escuchar grabación',
                        onPressed: () =>
                            _reproducirAudio(audioBorrador!),
                        icon: Icon(
                          audioReproduciendose == audioBorrador &&
                              reproduciendo
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          color: verdeWhatsapp,
                          size: 35,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Escucha tu grabación antes de enviarla.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _descartarAudio,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Descartar'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: verdeClaro,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _enviarAudio,
                          icon: const Icon(Icons.send),
                          label: const Text('Enviar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    grabando
                        ? 'Grabando... suelta para terminar'
                        : 'Mantén presionado el micrófono',
                    style: TextStyle(
                      color: grabando ? Colors.red : Colors.black54,
                      fontWeight:
                      grabando ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                GestureDetector(
                  onLongPressStart: (_) => _iniciarGrabacion(),
                  onLongPressEnd: (_) => _detenerGrabacion(),
                  child: CircleAvatar(
                    radius: 27,
                    backgroundColor:
                    grabando ? Colors.red : verdeClaro,
                    child: Icon(
                      grabando ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 29,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Mantén presionado el botón para grabar y suéltalo para terminar.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _leccionLlamadas() {
    final datos = _contactoActual!;

    return Column(
      children: [
        const SizedBox(height: 35),
        _AvatarContacto(contacto: datos, radio: 55),
        const SizedBox(height: 18),
        Text(
          contacto,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Disponible',
          style: TextStyle(color: Colors.black54),
        ),
        const Spacer(),
        if (llamadaFinalizada)
          const Text(
            'Llamada finalizada',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        Padding(
          padding: const EdgeInsets.all(25),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: verdeClaro,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _iniciarLlamada,
              icon: const Icon(Icons.call),
              label: const Text('Llamar'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pantallaLlamada() {
    final datos = _contactoActual;

    return Scaffold(
      backgroundColor: const Color(0xFF173C36),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 70),
            if (datos != null)
              _AvatarContacto(contacto: datos, radio: 58),
            const SizedBox(height: 20),
            Text(
              contacto,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Llamada simulada...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BotonLlamada(
                  icono: _silenciado ? Icons.mic_off : Icons.mic,
                  texto: 'Silenciar',
                  activo: _silenciado,
                  onTap: () => _usarControlLlamada('Silenciar'),
                ),
                _BotonLlamada(
                  icono:
                  _altavoz ? Icons.volume_up : Icons.volume_down,
                  texto: 'Altavoz',
                  activo: _altavoz,
                  onTap: () => _usarControlLlamada('Altavoz'),
                ),
                _BotonLlamada(
                  icono: Icons.videocam,
                  texto: 'Video',
                  activo: _videoActivado,
                  onTap: () => _usarControlLlamada('Video'),
                ),
              ],
            ),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: _finalizarLlamada,
              child: const CircleAvatar(
                radius: 33,
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 31,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Finalizar llamada',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 45),
          ],
        ),
      ),
    );
  }

  Widget _leccionFotos() {
    return _chatBase(
      contenido: [
        const _BurbujaChat(
          texto: '¡Envíame una foto cuando puedas!',
          esMio: false,
          hora: '10:30',
        ),
        ...fotosEnviadas.map(
              (foto) => _BurbujaFoto(imagen: foto, enviada: true),
        ),
        if (fotoBorrador != null)
          GestureDetector(
            onTap: () {
              if (widget.tipo == 'fotos' && _pasoActual == 2) {
                _avanzarGuia();
              }
            },
            child: _BurbujaFoto(
              imagen: fotoBorrador!,
              enviada: false,
            ),
          ),
      ],
      campo: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fotoBorrador != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: verdeClaro, width: 1.5),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: verdeWhatsapp),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Esta fotografía aún no se ha enviado. Toca la vista previa y pulsa Enviar fotografía.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _cancelarFoto,
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verdeClaro,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _enviarFoto,
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar fotografía'),
                  ),
                ),
              ],
            ),
          ] else
            Row(
              children: [
                IconButton(
                  tooltip: 'Adjuntar fotografía',
                  onPressed: () => _abrirGaleria(),
                  icon: const Icon(
                    Icons.add_circle,
                    color: verdeWhatsapp,
                    size: 32,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Selecciona una fotografía',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                IconButton(
                  tooltip: 'Abrir cámara',
                  onPressed: () =>
                      _seleccionarImagen(ImageSource.camera),
                  icon: const Icon(
                    Icons.camera_alt,
                    color: verdeWhatsapp,
                    size: 28,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _leccionEstados() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: _mostrarOpcionesEstado,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 29,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                      fotoEstado != null && estadoFotoPublicada
                          ? FileImage(File(fotoEstado!.path))
                          : null,
                      child: fotoEstado == null || !estadoFotoPublicada
                          ? const Icon(
                        Icons.person,
                        size: 34,
                        color: Colors.white,
                      )
                          : null,
                    ),
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: verdeClaro,
                        child: Icon(
                          Icons.add,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: GestureDetector(
                  onTap: _mostrarOpcionesEstado,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mi estado',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        estadoPublicado ??
                            (estadoFotoPublicada
                                ? 'Fotografía publicada'
                                : fotoEstado != null
                                ? 'Fotografía lista para publicar'
                                : 'Añade una actualización'),
                        style: const TextStyle(color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: _mostrarOpcionesEstado,
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: verdeWhatsapp,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        if (fotoEstado != null && !estadoFotoPublicada) ...[
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(fotoEstado!.path),
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Vista previa: todavía no has publicado esta fotografía.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => fotoEstado = null);
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: verdeClaro,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _publicarEstadoFoto,
                        icon: const Icon(Icons.send),
                        label: const Text('Publicar estado'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              'Actualizaciones recientes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
        ),
        _FilaEstado(
          nombre: 'María',
          inicial: 'M',
          color: const Color(0xFFB66B91),
          onTap: () => _verEstadoDemo(
            nombre: 'María',
            texto: '¡Disfrutando un hermoso día! 🌷',
            color: const Color(0xFFB66B91),
            emoji: '🌷',
          ),
        ),
        _FilaEstado(
          nombre: 'David',
          inicial: 'D',
          color: const Color(0xFF527DA3),
          onTap: () => _verEstadoDemo(
            nombre: 'David',
            texto: 'Un saludo para todos. 😊',
            color: const Color(0xFF527DA3),
            emoji: '☀️',
          ),
        ),
        _FilaEstado(
          nombre: 'Carlos',
          inicial: 'C',
          color: const Color(0xFFB58B51),
          onTap: () => _verEstadoDemo(
            nombre: 'Carlos',
            texto: '¡Que tengan un excelente día!',
            color: const Color(0xFFB58B51),
            emoji: '🌄',
          ),
        ),
        if (estadoPublicado != null || estadoFotoPublicada) ...[
          const Divider(height: 20),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: verdeWhatsapp,
              backgroundImage:
              estadoFotoPublicada && fotoEstado != null
                  ? FileImage(File(fotoEstado!.path))
                  : null,
              child: estadoFotoPublicada && fotoEstado != null
                  ? null
                  : const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Tu actualización',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              estadoPublicado ?? 'Fotografía publicada',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: _verMiEstado,
          ),
        ],
      ],
    );
  }

  Widget _leccionContactos() {
    final consulta = busquedaController.text.toLowerCase().trim();

    final filtrados = contactosDemo.where((c) {
      return (c['nombre'] as String).toLowerCase().contains(consulta);
    }).toList();

    if (contacto.isNotEmpty) {
      final datos = _contactoActual!;

      return Column(
        children: [
          const SizedBox(height: 35),
          _AvatarContacto(contacto: datos, radio: 48),
          const SizedBox(height: 15),
          Text(
            contacto,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text('Contacto encontrado'),
          const SizedBox(height: 25),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.person, color: verdeWhatsapp),
                  title: Text('Nombre'),
                  subtitle: Text('Información del contacto'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.message,
                    color: verdeWhatsapp,
                  ),
                  title: const Text('Mensaje de ejemplo'),
                  subtitle: Text(datos['mensaje'] as String),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                contacto = '';
                busquedaController.clear();
                _contactoBuscado = false;
                _resultadoConfirmado = false;
              });
            },
            icon: const Icon(Icons.search),
            label: const Text('Buscar otro contacto'),
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            controller: busquedaController,
            onTap: () {
              if (widget.tipo == 'contactos' && _pasoActual == 0) {
                _avanzarGuia();
              }
            },
            onChanged: (texto) {
              final consultaActual = texto.trim().toLowerCase();

              final existeResultado = contactosDemo.any(
                    (c) => (c['nombre'] as String)
                    .toLowerCase()
                    .contains(consultaActual),
              );

              setState(() {
                _contactoBuscado = false;
                _resultadoConfirmado = false;
              });

              if (consultaActual.isNotEmpty && existeResultado) {
                _contactoBuscado = true;

                if (widget.tipo == 'contactos' && _pasoActual == 1) {
                  _avanzarGuia();
                }
              }
            },
            decoration: InputDecoration(
              hintText: 'Buscar contacto',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: filtrados.isEmpty
              ? const Center(
            child: Text('No se encontraron contactos'),
          )
              : ListView(
            children: filtrados.map((c) {
              return _FilaContacto(
                contacto: c,
                onTap: () => _seleccionarResultadoContacto(
                  c['nombre'] as String,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _chatBase({
    required List<Widget> contenido,
    required Widget campo,
  }) {
    final datos = _contactoActual;

    return Column(
      children: [
        Container(
          color: verdeWhatsapp,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          child: Row(
            children: [
              if (datos != null)
                _AvatarContacto(contacto: datos, radio: 21),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacto,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const Text(
                      'En línea',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _iniciarLlamada,
                icon: const Icon(Icons.call, color: Colors.white),
              ),
              const Icon(Icons.more_vert, color: Colors.white),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFECE5DD),
            ),
            child: ListView(
              padding: const EdgeInsets.all(13),
              children: [
                const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        'HOY',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
                ...contenido,
              ],
            ),
          ),
        ),
        Container(
          color: fondoWhatsapp,
          padding: const EdgeInsets.all(8),
          child: campo,
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// AVATAR DE CONTACTO
// -----------------------------------------------------------------------------

class _AvatarContacto extends StatelessWidget {
  final Map<String, dynamic> contacto;
  final double radio;

  const _AvatarContacto({
    required this.contacto,
    required this.radio,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radio,
      backgroundColor: contacto['color'] as Color,
      child: Text(
        contacto['inicial'] as String,
        style: TextStyle(
          color: Colors.white,
          fontSize: radio * 0.85,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// FILA DE CONTACTO O CHAT
// -----------------------------------------------------------------------------

class _FilaContacto extends StatelessWidget {
  final Map<String, dynamic> contacto;
  final VoidCallback onTap;
  final bool esChat;

  const _FilaContacto({
    required this.contacto,
    required this.onTap,
    this.esChat = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          child: Row(
            children: [
              _AvatarContacto(contacto: contacto, radio: 27),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacto['nombre'] as String,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contacto['mensaje'] as String,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    contacto['hora'] as String,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Icon(
                    esChat ? Icons.done_all : Icons.chevron_right,
                    color: esChat ? Colors.blue : Colors.grey,
                    size: 21,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// BURBUJA DE MENSAJE
// -----------------------------------------------------------------------------

class _BurbujaChat extends StatelessWidget {
  final String texto;
  final bool esMio;
  final String hora;

  const _BurbujaChat({
    required this.texto,
    required this.esMio,
    required this.hora,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.fromLTRB(12, 9, 9, 6),
        decoration: BoxDecoration(
          color: esMio ? const Color(0xFFD9FDD3) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(texto, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hora,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black45,
                  ),
                ),
                if (esMio) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all,
                    size: 15,
                    color: Colors.blue,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// BURBUJA DE AUDIO
// -----------------------------------------------------------------------------

class _BurbujaAudio extends StatelessWidget {
  final String ruta;
  final bool esMio;
  final bool reproduciendo;
  final VoidCallback onTap;

  const _BurbujaAudio({
    required this.ruta,
    required this.esMio,
    required this.reproduciendo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        width: 270,
        decoration: BoxDecoration(
          color: esMio ? const Color(0xFFD9FDD3) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: reproduciendo ? 'Pausar audio' : 'Reproducir audio',
              onPressed: onTap,
              icon: Icon(
                reproduciendo
                    ? Icons.pause_circle
                    : Icons.play_circle,
                color: verdeWhatsapp,
                size: 37,
              ),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Audio de voz',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Toca para escuchar',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (esMio)
              const Icon(
                Icons.done_all,
                size: 16,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// BURBUJA DE FOTOGRAFÍA
// -----------------------------------------------------------------------------

class _BurbujaFoto extends StatelessWidget {
  final XFile imagen;
  final bool enviada;

  const _BurbujaFoto({
    required this.imagen,
    required this.enviada,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 245,
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: const Color(0xFFD9FDD3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(imagen.path),
                width: 230,
                height: 190,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 190,
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image,
                      size: 45,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  enviada ? '10:32' : 'Vista previa',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                if (enviada)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.done_all,
                      size: 15,
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// FILA DE ESTADO
// -----------------------------------------------------------------------------

class _FilaEstado extends StatelessWidget {
  final String nombre;
  final String inicial;
  final Color color;
  final VoidCallback onTap;

  const _FilaEstado({
    required this.nombre,
    required this.inicial,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      leading: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: verdeClaro, width: 2),
        ),
        child: CircleAvatar(
          backgroundColor: color,
          child: Text(
            inicial,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      title: Text(
        nombre,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('Hace unos minutos'),
      onTap: onTap,
    );
  }
}

// -----------------------------------------------------------------------------
// BOTONES DE LLAMADA
// -----------------------------------------------------------------------------

class _BotonLlamada extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool activo;
  final VoidCallback onTap;

  const _BotonLlamada({
    required this.icono,
    required this.texto,
    required this.onTap,
    this.activo = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: activo ? verdeClaro : Colors.white24,
            child: Icon(icono, color: Colors.white),
          ),
          const SizedBox(height: 7),
          Text(
            texto,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}