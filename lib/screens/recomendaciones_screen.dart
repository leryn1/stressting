import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/customAppBar.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  String? activeCategory;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir $url';
    }
  }

  // Mapa de contenido para Lectura y Ejercicios
  final Map<String, List<Map<String, String>>> categoryData = {
    "Lectura": [
      {"titulo": "Manejo del tiempo", "url": "https://pau.edu/blog/time-management-for-students/"},
      {"titulo": "Higiene del sueño", "url": "https://www.sleepfoundation.org/sleep-hygiene"},
      {"titulo": "Superar el Procrastinar", "url": "https://www.psychologytoday.com/intl/basics/procrastination"},
    ],
    "Ejercicios": [
      {"titulo": "Respiración 4-7-8", "url": "https://youtu.be/1mR-H6Sre_g"},
      {"titulo": "Relajación Muscular", "url": "https://youtu.be/ClqPtWzozXs"},
      {"titulo": "Yoga en 5 minutos", "url": "https://youtu.be/s7Zp86lO4p0"},
    ],
    "Música": [
      {"titulo": "Lofi Hip Hop", "url": "https://youtu.be/jfKfPfyJRdk"},
      {"titulo": "Sonidos de Lluvia", "url": "https://youtu.be/mPZkdNFkNps"},
      {"titulo": "Mozart Relajante", "url": "https://youtu.be/Rb0UmrreWZA"},
    ],
    "Videos": [
      {"titulo": "Naturaleza 4K", "url": "https://youtu.be/BHACKCNDMW8"},
      {"titulo": "Acuario Virtual", "url": "https://youtu.be/263Vb6xiifo"},
      {"titulo": "Paisajes de Japón", "url": "https://youtu.be/7FgZGMdtsT0"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF), // Fondo consistente
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Inicio", style: TextStyle(color: Colors.black54, fontSize: 20))
                ),
                const Text("Recomendaciones", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            Image.asset('assets/logo_stressting.png', height: 65),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Recomendaciones",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 10),
            Text(
              activeCategory == null
                  ? "Selecciona una categoría para relajarte."
                  : "Explora estas opciones de $activeCategory:",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 30),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: activeCategory == null
                  ? _buildMainGrid()
                  : _buildSubCategoryView(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMainGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1.1,
      children: [
        _buildCategoryCard("Música", Icons.headset_mic, Colors.indigo),
        _buildCategoryCard("Lectura", Icons.menu_book, Colors.teal),
        _buildCategoryCard("Videos", Icons.play_circle_fill, Colors.redAccent),
        _buildCategoryCard("Ejercicios", Icons.self_improvement, Colors.green),
      ],
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () => setState(() => activeCategory = title),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)],
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategoryView() {
    final items = categoryData[activeCategory!] ?? [];

    return SizedBox(
      width: double.infinity,
      child: Column(
        key: ValueKey(activeCategory),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: items.map((item) => _buildLinkButton(item["titulo"]!, item["url"]!)).toList(),
          ),
          const SizedBox(height: 50),
          ElevatedButton.icon(
            onPressed: () => setState(() => activeCategory = null),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            label: const Text("REGRESAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: const Size(220, 55),
              shape: const StadiumBorder(),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(String label, String url) {
    return ElevatedButton(
      onPressed: () => _launchURL(url),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF90CAF9),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}
