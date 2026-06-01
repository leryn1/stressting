import 'package:flutter/material.dart';
import 'package:stressting/widgets/customAppBar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ComentariosScreen extends StatefulWidget {
  const ComentariosScreen({super.key});

  @override
  State<ComentariosScreen> createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  final _supabase = Supabase.instance.client;
  final _commentCtrl = TextEditingController();
  List<dynamic> _misComentarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarComentarios();
  }

  Future<void> _cargarComentarios() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = await _supabase
          .from('comentarios')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        _misComentarios = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _enviarComentario() async {
    if (_commentCtrl.text.trim().isEmpty) return;

    final userId = _supabase.auth.currentUser?.id;
    final texto = _commentCtrl.text.trim();

    Navigator.pop(context);
    _commentCtrl.clear();

    try {
      await _supabase.from('comentarios').insert({
        'user_id': userId,
        'texto': texto,
      });

      _cargarComentarios();

      if (!mounted) return;
      _mostrarDialogoExito();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al enviar: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _mostrarDialogoEscribir() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: const Color(0xFFE3EDFF),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Comentario",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black26),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _commentCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Añade un comentario...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7CB3F5),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: _enviarComentario,
                    child: const Text("Enviar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9CCC65),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoExito() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: const Color(0xFFE3EDFF),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "¡Gracias por sus comentarios!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Su comentario se ha registrado\nexitosamente",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CB3F5),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),

      // --- TU NAVBAR ORIGINAL RESTAURADO Y CONECTADO ---
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    "Inicio",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const Text(
                    "Perfil",
                    style: TextStyle(color: Colors.black54, fontSize: 20),
                  ),
                ),
              ],
            ),
            Image.asset('assets/logo_stressting.png', height: 65),
          ],
        ),
      ),

      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 24, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Comentarios",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ),
          ),

          // Sección de "Mis comentarios"
          Container(
            width: double.infinity,
            color: const Color(0xFFD6E4FF),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: const Text(
              "Mis comentarios",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),

          // Lista de comentarios
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _misComentarios.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Aún no tienes comentarios registrados",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: _misComentarios.length,
              itemBuilder: (context, index) {
                final item = _misComentarios[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(item['texto'] ?? ''),
                    subtitle: Text(
                      (item['created_at'] as String).substring(0, 10),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                );
              },
            ),
          ),

          // Añadir comentario
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD6E4FF),
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            onPressed: _mostrarDialogoEscribir,
            child: const Text("Añadir comentario", style: TextStyle(fontSize: 15)),
          ),
          const SizedBox(height: 25),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7CB3F5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/diagnostico');
                    },
                    child: const Text("REALIZAR DIAGNÓSTICO", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9CCC65),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/infoEstres');
                    },
                    child: const Text("+ INFORMACIÓN DEL ESTRÉS", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text("Permite sentir paz y tranquilidad", style: TextStyle(fontSize: 14, color: Colors.black54, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }
}