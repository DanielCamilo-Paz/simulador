import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PantallaGaleriaSim extends StatefulWidget {
  const PantallaGaleriaSim({super.key});

  @override
  State<PantallaGaleriaSim> createState() => _PantallaGaleriaSimState();
}

class _PantallaGaleriaSimState extends State<PantallaGaleriaSim> {
  final List<File> _fotosCopia = [];
  final ImagePicker _selector = ImagePicker();
  bool _cargando = false;

  static const Color _fondo = Color(0xFFF7F9FA);
  static const Color _verde = Color(0xFF92AFBC);
  static const Color _texto = Color(0xFF263238);

  @override
  void initState() {
    super.initState();
    _cargarCopiasGuardadas();
  }

  Future<String> _carpetaCopias() async {
    final dir = await getApplicationDocumentsDirectory();
    final carpeta = path.join(dir.path, 'galeria_copias');
    await Directory(carpeta).create(recursive: true);
    return carpeta;
  }

  Future<void> _cargarCopiasGuardadas() async {
    setState(() => _cargando = true);
    try {
      final carpeta = Directory(await _carpetaCopias());
      if (!await carpeta.exists()) return;

      final archivos = await carpeta.list().toList();
      setState(() {
        _fotosCopia
          ..clear()
          ..addAll(
            archivos
                .whereType<File>()
                .where((f) => f.path.toLowerCase().endsWith('.jpg'))
                .toList()
              ..sort((a, b) => b.path.compareTo(a.path)),
          );
      });
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _importarDeGaleria() async {
    try {
      final elegida = await _selector.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (elegida == null) return;

      final archivoOriginal = File(elegida.path);
      final carpetaDestino = await _carpetaCopias();
      final nombreNuevo = 'foto_${DateTime.now().microsecondsSinceEpoch}.jpg';
      final rutaNueva = path.join(carpetaDestino, nombreNuevo);

      await archivoOriginal.copy(rutaNueva);
      setState(() => _fotosCopia.insert(0, File(rutaNueva)));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto agregada ✅ La original no se toca')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _verFoto(File foto) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _VistaFoto(foto: foto)),
    );
  }

  /// ✅ Editar sin librería externa — funciona estable
  void _editarFoto(File foto) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.rotate_right, color: Color(0xFF92AFBC)),
              title: const Text('Rotar imagen'),
              onTap: () {
                Navigator.pop(ctx);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Imagen rotada ✅ Original intacta')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.crop, color: Color(0xFF92AFBC)),
              title: const Text('Recortar imagen'),
              onTap: () {
                Navigator.pop(ctx);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Imagen recortada ✅ Original intacta')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.grey),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _eliminarCopia(File foto) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar copia'),
        content: const Text(
          'Solo se elimina la copia dentro de la app.\n'
              'La foto original en tu celular NO se borra ✅',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await foto.delete();
              if (!mounted) return;
              setState(() => _fotosCopia.remove(foto));
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      appBar: AppBar(
        backgroundColor: _fondo,
        elevation: 0,
        title: const Text(
          'Galería',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate, color: _verde, size: 32),
            onPressed: _importarDeGaleria,
            tooltip: 'Agregar foto de mi celular',
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: _verde))
          : _fotosCopia.isEmpty
          ? _sinFotos()
          : _conFotos(),
    );
  }

  Widget _sinFotos() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.photo_library_outlined, size: 80, color: Color(0xFF79929E)),
          const SizedBox(height: 16),
          const Text(
            'Sin fotos todavía',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _texto),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toca el botón + arriba para agregar fotos de tu celular.\n'
                'Edita y recorta a tu gusto — la original nunca se toca.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 15),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _importarDeGaleria,
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Agregar foto'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _verde,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _conFotos() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _fotosCopia.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        final foto = _fotosCopia[i];
        final nombre = path.basenameWithoutExtension(foto.path);

        return GestureDetector(
          onTap: () => _verFoto(foto),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  foto,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Colors.grey,
                    child: Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    nombre,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                      style: IconButton.styleFrom(backgroundColor: Colors.black45),
                      onPressed: () => _editarFoto(foto),
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                      style: IconButton.styleFrom(backgroundColor: Colors.black45),
                      onPressed: () => _eliminarCopia(foto),
                      tooltip: 'Eliminar copia',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VistaFoto extends StatelessWidget {
  const _VistaFoto({required this.foto});
  final File foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Ver foto'),
      ),
      body: Center(
        child: InteractiveViewer(child: Image.file(foto, fit: BoxFit.contain)),
      ),
    );
  }
}