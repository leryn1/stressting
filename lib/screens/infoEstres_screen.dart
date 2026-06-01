import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/widgets/customAppBar.dart';
import 'sitiosWeb_screen.dart';

class InfoEstresScreen extends StatelessWidget {
  const InfoEstresScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: const Text("Inicio",
                      style: TextStyle(color: Colors.black54, fontSize: 20)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.orange, size: 20),
                    onPressed: () => Navigator.pop(context)
                ),
                const Text("+ Información del estrés",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 30),

            // Sección de contenido principal
            const Text("¿Qué es el estrés académico?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 15),
            const Text(
              "Es un estrés que experimentan estudiantes durante su tránsito escolar o docentes en sus actividades académicas.\n(Silva-Ramon et al., 2020)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),

            const Text("Otros estudios sobre el estrés",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo)),
            const SizedBox(height: 20),

            _buildStudyButton(
                "Estrés académico en estudiantes universitarios (2020)",
                "https://www.redalyc.org/journal/674/67462875008/html/"
            ),
            _buildStudyButton(
                "Estrés académico y salud mental (Perspectiva 2021)",
                "https://www.scielo.org.mx/scielo.php?script=sci_arttext&pid=S2007-74672021000200143"
            ),

            const SizedBox(height: 40),

            // Botón para ir a sitios web
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(280, 55),
                shape: const StadiumBorder(),
                elevation: 3,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SitiosWebScreen())
                );
              },
              child: const Text("SITIOS WEB SOBRE ESTRÉS",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyButton(String title, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFDBE8FF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.indigo.withOpacity(0.1)),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.indigo,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
                fontSize: 15
            ),
          ),
        ),
      ),
    );
  }
}
