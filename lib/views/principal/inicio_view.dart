
import 'package:flutter/material.dart';

import 'simulador_view.dart';

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {

  // PALETA DE COLORES
  static const Color naranja = Color(0xFFF77F11);
  static const Color amarillo = Color(0xFFF8E8A0);
  static const Color fondo = Color(0xFFF6F9D8);
  static const Color texto = Color(0xFF333333);
  static const Color blanco = Colors.white;

  // ÚLTIMA SIMULACIÓN SELECCIONADA
  String ultimaLeccion = 'Realizar llamada';

  String descripcionLeccion =
      'Haz una llamada a un contacto conocido';

  IconData iconoLeccion = Icons.phone_in_talk_rounded;

  // PANTALLA DE LA ÚLTIMA SIMULACIÓN
  Widget? ultimaPantalla;

  // ACTUALIZAR LA ÚLTIMA PRÁCTICA
  void _actualizarUltimaLeccion(
      String nombre,
      String descripcion,
      IconData icono,
      Widget pantalla,
      ) {
    setState(() {
      ultimaLeccion = nombre;
      descripcionLeccion = descripcion;
      iconoLeccion = icono;
      ultimaPantalla = pantalla;
    });
  }

  // ABRIR MENÚ DE LECCIONES
  Future<void> _abrirLecciones() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SimuladorView(
          onSeleccionarPractica: _actualizarUltimaLeccion,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // ABRIR ÚLTIMA SIMULACIÓN
  Future<void> _continuarLeccion() async {

    if (ultimaPantalla == null) {
      await _abrirLecciones();
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ultimaPantalla!,
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // ENCABEZADO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Expanded(
                    child: Text(
                      'App de Aprendizaje',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: texto,
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: amarillo,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: IconButton(
                      onPressed: null,
                      icon: const Icon(
                        Icons.settings,
                        color: texto,
                        size: 27,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // SALUDO
              const Text(
                '¡Hola, Usuario!',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: texto,
                ),
              ),

              const SizedBox(height: 28),

              // SECCIÓN PRINCIPAL
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    flex: 5,
                    child: _tarjetaContinuar(),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    flex: 5,
                    child: _tarjetaProgreso(),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // OPCIONES PRINCIPALES
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 13,
                mainAxisSpacing: 13,
                childAspectRatio: 1.25,

                children: [

                  // LECCIONES
                  _tarjetaOpcion(
                    icono: Icons.menu_book_rounded,
                    titulo: 'Lecciones',
                    onTap: _abrirLecciones,
                  ),

                  // REPASO
                  _tarjetaOpcion(
                    icono: Icons.extension_rounded,
                    titulo: 'Actividades de repaso',
                  ),

                  // PROGRESO
                  _tarjetaOpcion(
                    icono: Icons.pie_chart_rounded,
                    titulo: 'Progreso',
                  ),

                  // PERFIL
                  _tarjetaOpcion(
                    icono: Icons.person_outline_rounded,
                    titulo: 'Mi perfil',
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // TARJETA SIGUE CON TU LECCIÓN
  Widget _tarjetaContinuar() {

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _continuarLeccion,

      child: Container(
        height: 185,
        padding: const EdgeInsets.all(11),

        decoration: BoxDecoration(
          color: naranja.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: naranja.withOpacity(0.35),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            const Text(
              'Sigue con tu lección',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
            ),

            Icon(
              iconoLeccion,
              size: 49,
              color: naranja,
            ),

            Text(
              descripcionLeccion,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: texto,
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9),

              decoration: BoxDecoration(
                color: naranja,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Text(
                ultimaLeccion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: blanco,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TARJETA DE PROGRESO
  Widget _tarjetaProgreso() {

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},

      child: Container(
        height: 185,
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: naranja.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: naranja.withOpacity(0.35),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [

            const Text(
              'Tu progreso general',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
            ),

            const Icon(
              Icons.pie_chart_rounded,
              size: 55,
              color: naranja,
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),

              decoration: BoxDecoration(
                color: naranja,
                borderRadius: BorderRadius.circular(12),
              ),

              child: const Text(
                'Consultar progreso',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blanco,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TARJETAS DEL MENÚ
  Widget _tarjetaOpcion({
    required IconData icono,
    required String titulo,
    VoidCallback? onTap,
  }) {

    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: naranja.withOpacity(0.17),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: naranja.withOpacity(0.30),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icono,
              size: 39,
              color: naranja,
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),

              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: texto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}