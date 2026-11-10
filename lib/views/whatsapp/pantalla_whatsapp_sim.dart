import 'package:flutter/material.dart';

import '../../controllers/whatsapp_controller.dart';
import '../../models/whatsapp/leccion_whatsapp_model.dart';
import 'seleccion_lecciones_view.dart';

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
        builder: (_) => SeleccionLeccionesView(
          controller: widget.controller,
          onSeleccionarLeccion: (LeccionWhatsappModel leccion) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PantallaLeccionSim(
                  tipo: leccion.tipo,
                  titulo: leccion.titulo,
                  controller: widget.controller,
                ),
              ),
            );
          },
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
// TARJETA DE OPCIÓN INICIAL
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
                backgroundColor: color.withOpacity(0.15),
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
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
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
  final TextEditingController mensajeController =
  TextEditingController();

  final TextEditingController busquedaController =
  TextEditingController();

  final TextEditingController estadoController =
  TextEditingController();

  String contacto = '';
  String? fotoSeleccionada;
  String? estadoPublicado;
  String? fotoEstado;

  bool grabando = false;
  bool audioEnviado = false;
  bool llamadaActiva = false;
  bool llamadaFinalizada = false;
  bool mensajeEnviado = false;
  bool fotoEnviada = false;

  @override
  void dispose() {
    mensajeController.dispose();
    busquedaController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  // Registra una práctica terminada y actualiza el progreso general.
  void _registrarLeccion(String id) {
    widget.controller.marcarCompletada(id);
  }

  void _seleccionarContacto(String nombre) {
    setState(() {
      contacto = nombre;
    });

    // Buscar y seleccionar un contacto completa esta lección.
    if (widget.tipo == 'contactos') {
      _registrarLeccion('contactos');
    }
  }

  void _enviarMensaje() {
    if (mensajeController.text.trim().isEmpty) return;

    setState(() {
      mensajeEnviado = true;
    });
    _registrarLeccion('mensajes');
  }

  void _iniciarLlamada() {
    setState(() {
      llamadaActiva = true;
      llamadaFinalizada = false;
    });
  }

  void _finalizarLlamada() {
    setState(() {
      llamadaActiva = false;
      llamadaFinalizada = true;
    });
    _registrarLeccion('llamadas');
  }

  // ---------------------------------------------------------------------------
  // GALERÍA SIMULADA
  // ---------------------------------------------------------------------------

  void _abrirGaleria({bool paraEstado = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (contextGaleria) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecciona una foto',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 9,
                  crossAxisSpacing: 9,
                  children: [
                    _FotoDemo(
                      nombre: 'Paisaje',
                      emoji: '🏞️',
                      color: const Color(0xFF80B8A0),
                      onTap: () {
                        Navigator.pop(contextGaleria);
                        _elegirFoto('Paisaje', paraEstado);
                      },
                    ),
                    _FotoDemo(
                      nombre: 'Flores',
                      emoji: '🌷',
                      color: const Color(0xFFD9A0B7),
                      onTap: () {
                        Navigator.pop(contextGaleria);
                        _elegirFoto('Flores', paraEstado);
                      },
                    ),
                    _FotoDemo(
                      nombre: 'Familia',
                      emoji: '👨‍👩‍👧',
                      color: const Color(0xFFE6C18B),
                      onTap: () {
                        Navigator.pop(contextGaleria);
                        _elegirFoto('Familia', paraEstado);
                      },
                    ),
                    _FotoDemo(
                      nombre: 'Playa',
                      emoji: '🏖️',
                      color: const Color(0xFF77B8D2),
                      onTap: () {
                        Navigator.pop(contextGaleria);
                        _elegirFoto('Playa', paraEstado);
                      },
                    ),
                    _FotoDemo(
                      nombre: 'Comida',
                      emoji: '🍓',
                      color: const Color(0xFFE7A08E),
                      onTap: () {
                        Navigator.pop(contextGaleria);
                        _elegirFoto('Comida', paraEstado);
                      },
                    ),
                    _FotoDemo(
                      nombre: 'Mascota',
                      emoji: '🐶',
                      color: const Color(0xFFB6A1D4),
                      onTap: () {
                        Navigator.pop(contextGaleria);
                        _elegirFoto('Mascota', paraEstado);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _elegirFoto(String nombre, bool paraEstado) {
    setState(() {
      if (paraEstado) {
        fotoEstado = nombre;
        estadoPublicado = null;
      } else {
        fotoSeleccionada = nombre;
        fotoEnviada = false;
      }
    });

    // En este simulador, elegir una foto para el estado la publica.
    if (paraEstado) {
      _registrarLeccion('estados');
    }
  }

  void _publicarEstadoTexto() {
    if (estadoController.text.trim().isEmpty) return;

    setState(() {
      estadoPublicado = estadoController.text.trim();
      fotoEstado = null;
    });
    _registrarLeccion('estados');
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
        title: Text(widget.titulo),
        actions: [
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

  Widget _contenidoLeccion() {
    switch (widget.tipo) {
      case 'mensajes':
        return _leccionMensajes();
      case 'audios':
        return _leccionAudios();
      case 'llamadas':
        return _leccionLlamadas();
      case 'fotos':
        return _leccionFotos();
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

  Widget _listaContactos({
    required String titulo,
    required ValueChanged<String> onSeleccionar,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: contactosDemo.map((c) {
              return _FilaContacto(
                contacto: c,
                onTap: () =>
                    onSeleccionar(c['nombre'] as String),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LECCIÓN: MENSAJES
  // ---------------------------------------------------------------------------

  Widget _leccionMensajes() {
    if (contacto.isEmpty) {
      return _listaContactos(
        titulo: 'Elige con quién quieres conversar',
        onSeleccionar: _seleccionarContacto,
      );
    }

    return _chatBase(
      contenido: [
        const _BurbujaChat(
          texto: '¡Hola! ¿Cómo estás?',
          esMio: false,
          hora: '10:30',
        ),
        if (mensajeEnviado)
          _BurbujaChat(
            texto: mensajeController.text.trim(),
            esMio: true,
            hora: '10:32',
          ),
      ],
      campo: Row(
        children: [
          Expanded(
            child: TextField(
              controller: mensajeController,
              enabled: !mensajeEnviado,
              onChanged: (_) {
                setState(() {});
              },
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
              onPressed: mensajeEnviado ? null : _enviarMensaje,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LECCIÓN: AUDIOS
  // ---------------------------------------------------------------------------

  Widget _leccionAudios() {
    if (contacto.isEmpty) {
      return _listaContactos(
        titulo: 'Elige a quién quieres enviar un audio',
        onSeleccionar: _seleccionarContacto,
      );
    }

    return _chatBase(
      contenido: [
        const _BurbujaChat(
          texto: 'Hola, ¿puedes enviarme un audio?',
          esMio: false,
          hora: '10:30',
        ),
        if (grabando)
          const _BurbujaChat(
            texto: '● Grabando audio...',
            esMio: true,
            hora: '10:31',
          ),
        if (audioEnviado)
          const _BurbujaAudio(esMio: true),
      ],
      campo: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.grey,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Mensaje de voz',
                style: TextStyle(color: Colors.black45),
              ),
            ),
            CircleAvatar(
              backgroundColor: grabando ? Colors.red : verdeClaro,
              child: IconButton(
                onPressed: audioEnviado
                    ? null
                    : () {
                  setState(() {
                    if (!grabando) {
                      grabando = true;
                    } else {
                      grabando = false;
                      audioEnviado = true;
                    }
                  });
                  if (audioEnviado) {
                    _registrarLeccion('audios');
                  }
                },
                icon: Icon(
                  grabando ? Icons.stop : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LECCIÓN: LLAMADAS
  // ---------------------------------------------------------------------------

  Widget _leccionLlamadas() {
    if (contacto.isEmpty) {
      return _listaContactos(
        titulo: '¿A quién quieres llamar?',
        onSeleccionar: _seleccionarContacto,
      );
    }

    return Column(
      children: [
        const SizedBox(height: 35),
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.blueGrey,
          child: Text(
            contacto[0],
            style: const TextStyle(
              fontSize: 42,
              color: verdeWhatsapp,
            ),
          ),
        ),
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
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
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
              onPressed:
              llamadaFinalizada ? null : _iniciarLlamada,
              icon: const Icon(Icons.call),
              label: const Text('Llamar'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pantallaLlamada() {
    return Scaffold(
      backgroundColor: const Color(0xFF173C36),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 70),
            CircleAvatar(
              radius: 58,
              backgroundColor: Colors.white24,
              child: Text(
                contacto.isEmpty ? '?' : contacto[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                ),
              ),
            ),
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
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BotonLlamada(
                  icono: Icons.mic_off,
                  texto: 'Silenciar',
                ),
                _BotonLlamada(
                  icono: Icons.volume_up,
                  texto: 'Altavoz',
                ),
                _BotonLlamada(
                  icono: Icons.videocam,
                  texto: 'Video',
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

  // ---------------------------------------------------------------------------
  // LECCIÓN: FOTOS
  // ---------------------------------------------------------------------------

  Widget _leccionFotos() {
    if (contacto.isEmpty) {
      return _listaContactos(
        titulo: 'Elige a quién quieres enviar la foto',
        onSeleccionar: _seleccionarContacto,
      );
    }

    return _chatBase(
      contenido: [
        const _BurbujaChat(
          texto: '¡Envíame una foto cuando puedas!',
          esMio: false,
          hora: '10:30',
        ),
        if (fotoSeleccionada != null)
          _BurbujaFoto(
            nombre: fotoSeleccionada!,
            enviada: fotoEnviada,
          ),
      ],
      campo: Row(
        children: [
          IconButton(
            onPressed: () => _abrirGaleria(),
            icon: const Icon(
              Icons.add_circle,
              color: verdeWhatsapp,
              size: 31,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'Mensaje',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (fotoSeleccionada != null && !fotoEnviada)
            CircleAvatar(
              backgroundColor: verdeClaro,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    fotoEnviada = true;
                  });
                  _registrarLeccion('fotos');
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LECCIÓN: ESTADOS
  // ---------------------------------------------------------------------------

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
                      radius: 28,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 34,
                        color: Colors.white,
                      ),
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
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        estadoPublicado ??
                            (fotoEstado == null
                                ? 'Añade una actualización'
                                : 'Foto: $fotoEstado'),
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
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
                ),
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              'Actualizaciones recientes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ),
        _FilaEstado(
          nombre: 'María',
          inicial: 'M',
          color: Colors.pink.shade200,
        ),
        _FilaEstado(
          nombre: 'David',
          inicial: 'D',
          color: Colors.blue.shade200,
        ),
        _FilaEstado(
          nombre: 'Carlos',
          inicial: 'C',
          color: Colors.orange.shade200,
        ),
      ],
    );
  }

  void _mostrarOpcionesEstado() {
    showModalBottomSheet(
      context: context,
      builder: (contextModal) {
        return SafeArea(
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
                  child: Icon(
                    Icons.text_fields,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Crear estado de texto'),
                onTap: () {
                  Navigator.pop(contextModal);
                  _abrirEditorEstado();
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF3D967D),
                  child: Icon(
                    Icons.photo,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Compartir una foto'),
                onTap: () {
                  Navigator.pop(contextModal);
                  _abrirGaleria(paraEstado: true);
                },
              ),
            ],
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
        return StatefulBuilder(
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
                    onChanged: (_) {
                      setModalState(() {});
                    },
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
                      label: const Text('Compartir estado'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // LECCIÓN: BUSCAR CONTACTOS
  // ---------------------------------------------------------------------------

  Widget _leccionContactos() {
    final filtrados = contactosDemo.where((c) {
      return (c['nombre'] as String)
          .toLowerCase()
          .contains(busquedaController.text.toLowerCase());
    }).toList();

    if (contacto.isNotEmpty) {
      return Column(
        children: [
          const SizedBox(height: 35),
          CircleAvatar(
            radius: 45,
            backgroundColor: verdeClaro.withOpacity(0.2),
            child: Text(
              contacto[0],
              style: const TextStyle(
                fontSize: 38,
                color: verdeWhatsapp,
              ),
            ),
          ),
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
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                contacto = '';
                busquedaController.clear();
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
            onChanged: (_) {
              setState(() {});
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
                onTap: () =>
                    _seleccionarContacto(c['nombre'] as String),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ESTRUCTURA BASE DEL CHAT
  // ---------------------------------------------------------------------------

  Widget _chatBase({
    required List<Widget> contenido,
    required Widget campo,
  }) {
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
              CircleAvatar(
                backgroundColor: Colors.white24,
                child: Text(
                  contacto.isEmpty ? '?' : contacto[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  contacto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              if (widget.tipo == 'llamadas')
                IconButton(
                  onPressed: _iniciarLlamada,
                  icon: const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                ),
              if (widget.tipo != 'llamadas')
                const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
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
// FILA DE CONTACTO
// -----------------------------------------------------------------------------

class _FilaContacto extends StatelessWidget {
  final Map<String, dynamic> contacto;
  final VoidCallback onTap;

  const _FilaContacto({
    required this.contacto,
    required this.onTap,
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
            vertical: 11,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: contacto['color'] as Color,
                child: Text(
                  contacto['inicial'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacto['nombre'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contacto['mensaje'] as String,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
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
      alignment:
      esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.fromLTRB(12, 9, 9, 6),
        decoration: BoxDecoration(
          color: esMio
              ? const Color(0xFFD9FDD3)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              texto,
              style: const TextStyle(fontSize: 16),
            ),
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
  final bool esMio;

  const _BurbujaAudio({
    required this.esMio,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
      esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        width: 260,
        decoration: BoxDecoration(
          color: esMio
              ? const Color(0xFFD9FDD3)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              backgroundColor: verdeWhatsapp,
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '━━━━ ▂▅▃▇▂▅▃▆▂▃',
                    style: TextStyle(
                      color: verdeWhatsapp,
                      fontSize: 15,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '0:08',
                      style: TextStyle(fontSize: 11),
                    ),
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
// DATOS DE FOTOS
// -----------------------------------------------------------------------------

Map<String, dynamic> _datosFoto(String nombre) {
  switch (nombre) {
    case 'Paisaje':
      return {
        'emoji': '🏞️',
        'color': const Color(0xFF80B8A0),
      };
    case 'Flores':
      return {
        'emoji': '🌷',
        'color': const Color(0xFFD9A0B7),
      };
    case 'Familia':
      return {
        'emoji': '👨‍👩‍👧',
        'color': const Color(0xFFE6C18B),
      };
    case 'Playa':
      return {
        'emoji': '🏖️',
        'color': const Color(0xFF77B8D2),
      };
    case 'Comida':
      return {
        'emoji': '🍓',
        'color': const Color(0xFFE7A08E),
      };
    default:
      return {
        'emoji': '🐶',
        'color': const Color(0xFFB6A1D4),
      };
  }
}

// -----------------------------------------------------------------------------
// BURBUJA DE FOTO
// -----------------------------------------------------------------------------

class _BurbujaFoto extends StatelessWidget {
  final String nombre;
  final bool enviada;

  const _BurbujaFoto({
    required this.nombre,
    required this.enviada,
  });

  @override
  Widget build(BuildContext context) {
    final datos = _datosFoto(nombre);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 230,
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: const Color(0xFFD9FDD3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 145,
              decoration: BoxDecoration(
                color: datos['color'] as Color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  datos['emoji'] as String,
                  style: const TextStyle(fontSize: 65),
                ),
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
// FOTO DE GALERÍA
// -----------------------------------------------------------------------------

class _FotoDemo extends StatelessWidget {
  final String nombre;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _FotoDemo({
    required this.nombre,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 39),
            ),
            const SizedBox(height: 5),
            Text(
              nombre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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

  const _FilaEstado({
    required this.nombre,
    required this.inicial,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      leading: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: verdeClaro,
            width: 2,
          ),
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
      onTap: () {},
    );
  }
}

// -----------------------------------------------------------------------------
// BOTÓN DE LLAMADA
// -----------------------------------------------------------------------------

class _BotonLlamada extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _BotonLlamada({
    required this.icono,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white24,
          child: Icon(
            icono,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          texto,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}