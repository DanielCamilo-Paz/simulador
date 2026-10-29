import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PantallaRecordatorioSim extends StatefulWidget {
  const PantallaRecordatorioSim({super.key});

  @override
  State<PantallaRecordatorioSim> createState() => _PantallaRecordatorioSimState();
}

class _PantallaRecordatorioSimState extends State<PantallaRecordatorioSim> {
  final List<Map<String, dynamic>> _lista = [];

  static const Color _fondo = Color(0xFFF7F9FA);
  static const Color _verde = Color(0xFF92AFBC);

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<String> _rutaArchivo() async {
    final dir = await getApplicationDocumentsDirectory();
    return path.join(dir.path, 'recordatorios.txt');
  }

  Future<void> _cargar() async {
    try {
      final archivo = File(await _rutaArchivo());
      if (!await archivo.exists()) return;
      final lineas = await archivo.readAsLines();
      setState(() {
        _lista.clear();
        for (var l in lineas) {
          final p = l.split('||');
          _lista.insert(0, {
            'id': p[0], 'nombre': p[1], 'fecha': p[2], 'hora': p[3], 'activo': p[4] == 'true'
          });
        }
      });
    } catch (_) {}
  }

  Future<void> _guardar() async {
    final archivo = File(await _rutaArchivo());
    final lineas = _lista.map((r) =>
    '${r['id']}||${r['nombre']}||${r['fecha']}||${r['hora']}||${r['activo']}'
    ).toList();
    await archivo.writeAsString(lineas.join('\n'));
  }

  void _nuevo() {
    final nomCtrl = TextEditingController();
    String fecha = 'Sin elegir';
    String hora = 'Sin elegir';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setSt) => AlertDialog(
          title: const Text('Nuevo Recordatorio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: _verde),
                title: Text(fecha),
                onTap: () async {
                  final f = await showDatePicker(
                      context: ctx, initialDate: DateTime.now(),
                      firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365))
                  );
                  if (f != null) setSt(() => fecha = '${f.day}/${f.month}/${f.year}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time, color: _verde),
                title: Text(hora),
                onTap: () async {
                  final h = await showTimePicker(context: ctx, initialTime: TimeOfDay.now());
                  if (h != null) setSt(() => hora = '${h.hour}:${h.minute.toString().padLeft(2,'0')}');
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _verde),
              onPressed: () {
                if (nomCtrl.text.isEmpty || fecha == 'Sin elegir' || hora == 'Sin elegir') return;
                setState(() => _lista.insert(0, {
                  'id': DateTime.now().toString(),
                  'nombre': nomCtrl.text, 'fecha': fecha, 'hora': hora, 'activo': true
                }));
                _guardar();
                Navigator.pop(ctx);
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _cambiar(String id) {
    setState(() {
      final r = _lista.firstWhere((x) => x['id'] == id);
      r['activo'] = !r['activo'];
    });
    _guardar();
  }

  void _eliminar(String id) {
    setState(() => _lista.removeWhere((x) => x['id'] == id));
    _guardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      appBar: AppBar(
        backgroundColor: _fondo, elevation: 0,
        title: const Text('Recordatorios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle, color: _verde, size: 32), onPressed: _nuevo),
        ],
      ),
      body: _lista.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_none, size: 70, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No hay recordatorios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _nuevo, icon: const Icon(Icons.add), label: const Text('Crear uno'),
              style: ElevatedButton.styleFrom(backgroundColor: _verde, foregroundColor: Colors.white),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _lista.length,
        itemBuilder: (_, i) {
          final r = _lista[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(r['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${r['fecha']} — ${r['hora']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(value: r['activo'], onChanged: (_) => _cambiar(r['id']), activeColor: _verde),
                  IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => _eliminar(r['id'])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}