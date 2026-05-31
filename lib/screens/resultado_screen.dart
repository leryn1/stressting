import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/customAppBar.dart';
import 'instituciones_screen.dart';

class Recomendacion {
  final String titulo;
  final String url;
  const Recomendacion(this.titulo, this.url);
}

class ResultadoScreen extends StatelessWidget {
  final String nivel;
  final int puntos;

  const ResultadoScreen({super.key, required this.nivel, required this.puntos});

  // Mapa actualizado con tus nuevos enlaces
  static const Map<String, Map<String, List<Recomendacion>>> _recomendacionMap =
      {
        "Bajo": {
          "Musica": [
            Recomendacion("El cóndor pasa", "https://youtu.be/8kQZHYbZkLs"),
            Recomendacion("Laguna el Tabacal", "https://youtu.be/-grEOU2y-Tk"),
          ],
          "Video": [
            Recomendacion(
              "Alivio de estrés",
              "https://www.youtube.com/live/3GJ-Ljnq1ME",
            ),
            Recomendacion("Relajación visual", "https://youtu.be/7FgZGMdtsT0"),
          ],
        },
        "Medio": {
          "Musica": [
            Recomendacion("Piano relajante", "https://youtu.be/kiPbVfJYozg"),
            Recomendacion("Instrumental", "https://youtu.be/263Vb6xiifo"),
          ],
          "Video": [
            Recomendacion("Meditación", "https://youtu.be/1_mQTOsxack"),
            Recomendacion("Fondos marinos", "https://youtu.be/p9ChOBD1FVI"),
          ],
        },
        "Alto": {
          "Musica": [
            Recomendacion("Lofi Hip-Hop", "https://youtu.be/n61ULEU7CO0"),
            Recomendacion("Flauta Curativa", "https://youtu.be/QCRZWdnN9Fg"),
          ],
          "Video": [
            Recomendacion("Relajación visual", "https://youtu.be/7FgZGMdtsT0"),
            Recomendacion(
              "Escenarios naturales",
              "https://youtu.be/BHACKCNDMW8",
            ),
          ],
        },
      };

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene las recomendaciones según el nivel (si no existe, lista vacía)
    final recs = _recomendacionMap[nivel] ?? {"Musica": [], "Video": []};

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text(
                    "Inicio",
                    style: TextStyle(color: Colors.black54, fontSize: 20),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Resultado",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Gracias por completar las preguntas.\n¡Su diagnóstico está listo!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 30),
              const Text(
                "Su nivel de estrés es:",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 10),
              _buildLevelBox(),
              const SizedBox(height: 5),
              Text("$puntos Puntos", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
              const Text(
                "Recomendaciones",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecCategory("Música", recs["Musica"]!),
                  _buildRecCategory("Video", recs["Video"]!),
                ],
              ),
              const SizedBox(height: 50),

              // Botones de acción inferiores
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      "INSTITUCIONES\nDE APOYO",
                      const Color(0xFF92D050),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InstitucionesScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildActionButton(
                      "INICIO",
                      const Color(0xFF8AC2FE),
                      () => Navigator.of(
                        context,
                      ).popUntil((route) => route.isFirst),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                "Permite sentir paz y tranquilidad",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        nivel.toUpperCase(),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRecCategory(String title, List<Recomendacion> items) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...items.map((item) => _buildRecommendationButton(item)),
      ],
    );
  }

  Widget _buildRecommendationButton(Recomendacion item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDBE8FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 1,
          minimumSize: const Size(150, 45),
        ),
        onPressed: () => _launchURL(item.url),
        child: Text(
          item.titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.indigo,
            decoration: TextDecoration.underline,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const StadiumBorder(),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
