import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/customAppBar.dart';
import '../widgets/action_button.dart';

class SitiosWebScreen extends StatelessWidget {
  const SitiosWebScreen({super.key});

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
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text("Inicio", style: TextStyle(color: Colors.black54, fontSize: 20)),
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
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.orange, size: 20),
                    onPressed: () => Navigator.pop(context)
                ),
                const Text("Regresar a Información", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Sitios web sobre estrés",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 25),

            _buildWebLink("¿Qué es el estrés?", "https://www.who.int/es/news-room/questions-and-answers/item/stress",
                const Color(0xFF8AC2FE)),
            _buildWebLink("El estrés y su salud", "https://medlineplus.gov/spanish/ency/article/003211.htm",
                const Color(0xFF92D050)),
            _buildWebLink("Estrés Laboral", "https://www.imss.gob.mx/salud-en-linea/estres-laboral",
                const Color(0xFF8AC2FE)),
            _buildWebLink("¿Cómo manejarlo?", "https://www.cigna.com/es-us/knowledge-center/hw/alivio-del-estrs-y-relajacin-af1003spec",
                const Color(0xFF92D050)),
            _buildWebLink("Control del estrés", "https://www.mayoclinic.org/es-es/healthy-lifestyle/stress-management/basics/stress-relief/hlv-20049495",
                const Color(0xFF8AC2FE)),

            const SizedBox(height: 40),
            const Divider(indent: 50, endIndent: 50),
            const SizedBox(height: 20),

            ActionButton(
              text: "REALIZAR DIAGNÓSTICO",
              color: const Color(0xFF8AC2FE),
              onPressed: () {
                Navigator.pushNamed(context, '/diagnostico');
              },
            ),
            ActionButton(
                text: "INSTITUCIONES DE APOYO",
                color: const Color(0xFF92D050),
                onPressed: () {
                  Navigator.pushNamed(context, '/instituciones');
                }
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildWebLink(String title, String url, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 35),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 2,
            shape: const StadiumBorder(),
            minimumSize: const Size(double.infinity, 50)
        ),
        onPressed: () => _launchURL(url),
        child: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500
            )
        ),
      ),
    );
  }
}
