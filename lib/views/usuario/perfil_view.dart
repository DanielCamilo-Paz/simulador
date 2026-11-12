
import 'package:flutter/material.dart';

import '../../controllers/PerfilController.dart';
import '../../controllers/progreso_general_controller.dart';
import '../../controllers/configuracion_controller.dart';

import '../progreso/progreso_general_view.dart';
import '../configuracion/configuracion_view.dart';

class PerfilView extends StatefulWidget {
  final ProgresoGeneralController progresoController;
  final ConfiguracionController configuracionController;

  const PerfilView({
    super.key,
    required this.progresoController,
    required this.configuracionController,
  });

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  // ==========================================
  // COLORES DE SAFETAP
  // ==========================================

  static const Color azul = Color(0xFF92AFBC);
  static const Color fondo = Color(0xFFF7F9FA);
  static const Color verde = Color(0xFF299764);
  static const Color texto = Color(0xFF333333);

  late final PerfilController perfilController;

  // AVATARES: HOMBRE Y MUJER
  final List<IconData> avatares = const [
    Icons.face_rounded,
    Icons.face_3_rounded,
  ];

  @override
  void initState() {
    super.initState();

    perfilController = PerfilController();
    perfilController.cargarDatos();
  }

  @override
  void dispose() {
    perfilController.dispose();
    super.dispose();
  }

  // ==========================================
  // SELECCIONAR AVATAR
  // ==========================================

  void _mostrarOpcionesAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: fondo,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Selecciona tu avatar',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Elige el personaje que más te guste.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: _opcionAvatar(
                        indice: 0,
                        titulo: 'Hombre',
                        modalContext: modalContext,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: _opcionAvatar(
                        indice: 1,
                        titulo: 'Mujer',
                        modalContext: modalContext,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _opcionAvatar({
    required int indice,
    required String titulo,
    required BuildContext modalContext,
  }) {
    final seleccionado =
        perfilController.avatarSeleccionado == indice;

    return InkWell(
      onTap: () async {
        try {
          await perfilController.cambiarAvatar(indice);

          if (!mounted) return;

          if (modalContext.mounted) {
            Navigator.pop(modalContext);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Avatar actualizado correctamente',
              ),
              backgroundColor: verde,
            ),
          );
        } catch (_) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No se pudo guardar el avatar',
              ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: seleccionado ? verde : azul,
            width: seleccionado ? 3 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              avatares[indice],
              size: 70,
              color: azul,
            ),

            const SizedBox(height: 12),

            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (seleccionado) ...[
              const SizedBox(height: 8),

              const Icon(
                Icons.check_circle,
                color: verde,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EDITAR DATOS PERSONALES
  // ==========================================

  Future<void> _editarDatos() async {
    final nombreController = TextEditingController(
      text: perfilController.nombre,
    );

    final edadController = TextEditingController(
      text: perfilController.edad?.toString() ?? '',
    );

    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Editar mis datos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    textCapitalization:
                    TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon:
                      Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Escribe tu nombre';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: edadController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Edad',
                      prefixIcon:
                      Icon(Icons.cake_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final numero = int.tryParse(
                        value?.trim() ?? '',
                      );

                      if (numero == null ||
                          numero < 1 ||
                          numero > 120) {
                        return 'Escribe una edad válida';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('CANCELAR'),
            ),

            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                try {
                  await perfilController.actualizarDatos(
                    nombre: nombreController.text,
                    edad: int.parse(
                      edadController.text.trim(),
                    ),
                  );

                  if (!mounted) return;

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Datos actualizados correctamente',
                      ),
                      backgroundColor: verde,
                    ),
                  );
                } catch (_) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No se pudieron guardar los datos',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: azul,
                foregroundColor: Colors.white,
              ),
              child: const Text('GUARDAR'),
            ),
          ],
        );
      },
    );

    nombreController.dispose();
    edadController.dispose();
  }

  // ==========================================
  // ABRIR PROGRESO GENERAL
  // ==========================================

  void _abrirProgreso() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgresoGeneralView(
          controller: widget.progresoController,
        ),
      ),
    );
  }

  // ==========================================
  // ABRIR AJUSTES
  // ==========================================

  void _abrirAjustes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfiguracionView(
          controller: widget.configuracionController,
        ),
      ),
    );
  }

  // ==========================================
  // MENSAJE PROXIMAMENTE
  // ==========================================

  void _proximamente(String seccion) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Próximamente',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            'La sección "$seccion" estará disponible '
                'en una próxima actualización de SafeTap.',
            style: const TextStyle(
              fontSize: 17,
            ),
          ),

          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: azul,
                foregroundColor: Colors.white,
              ),
              child: const Text('ENTENDIDO'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // TARJETAS DEL PERFIL
  // ==========================================

  Widget _opcion({
    required IconData icono,
    required String titulo,
    required String descripcion,
    required VoidCallback onTap,
    bool pronto = false,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: BorderSide(
          color: azul.withOpacity(0.18),
        ),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 18,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0F4),
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Icon(
                  icono,
                  color: azul,
                  size: 28,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: texto,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      descripcion,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              if (pronto)
                const Text(
                  'PRONTO',
                  style: TextStyle(
                    color: verde,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: azul,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // PANTALLA PRINCIPAL DEL PERFIL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        title: const Text(
          'Mi perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: texto,
          ),
        ),
      ),

      body: AnimatedBuilder(
        animation: perfilController,
        builder: (context, child) {
          if (perfilController.cargando) {
            return const Center(
              child: CircularProgressIndicator(
                color: azul,
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  // =================================
                  // INFORMACIÓN DEL USUARIO
                  // =================================

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 125,
                          height: 125,
                          alignment: Alignment.center,
                          decoration:
                          const BoxDecoration(
                            color: Color(0xFFE4EDF1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            avatares[
                            perfilController.avatarSeleccionado],
                            size: 80,
                            color: azul,
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextButton.icon(
                          onPressed:
                          _mostrarOpcionesAvatar,
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: verde,
                          ),
                          label: const Text(
                            'CAMBIAR AVATAR',
                            style: TextStyle(
                              color: verde,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          perfilController.nombre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: texto,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          perfilController.edad == null
                              ? 'Edad no registrada'
                              : '${perfilController.edad} años',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =================================
                  // EDITAR DATOS
                  // =================================

                  _opcion(
                    icono:
                    Icons.manage_accounts_rounded,
                    titulo:
                    'Editar mis datos personales',
                    descripcion:
                    'Cambiar mi nombre y edad',
                    onTap: _editarDatos,
                  ),

                  // =================================
                  // MI PROGRESO
                  // =================================

                  _opcion(
                    icono: Icons.bar_chart_rounded,
                    titulo: 'Mi progreso',
                    descripcion:
                    'Consultar mis avances',
                    onTap: _abrirProgreso,
                  ),

                  // =================================
                  // MIS LOGROS
                  // =================================

                  _opcion(
                    icono:
                    Icons.emoji_events_outlined,
                    titulo: 'Mis logros',
                    descripcion: 'Próximamente',
                    pronto: true,
                    onTap: () =>
                        _proximamente('Mis logros'),
                  ),

                  // =================================
                  // AJUSTES
                  // =================================

                  _opcion(
                    icono: Icons.settings_rounded,
                    titulo: 'Ajustes',
                    descripcion:
                    'Personalizar la aplicación',
                    onTap: _abrirAjustes,
                  ),

                  // =================================
                  // CENTRO DE AYUDA
                  // =================================

                  _opcion(
                    icono: Icons.help_outline_rounded,
                    titulo: 'Centro de ayuda',
                    descripcion: 'Próximamente',
                    pronto: true,
                    onTap: () =>
                        _proximamente('Centro de ayuda'),
                  ),

                  const SizedBox(height: 15),

                  // =================================
                  // REGRESAR AL INICIO
                  // =================================

                  SizedBox(
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      label: const Text(
                        'REGRESAR AL INICIO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azul,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
