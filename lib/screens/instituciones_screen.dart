import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/customAppBar.dart';

class InstitucionesScreen extends StatefulWidget {
  const InstitucionesScreen({super.key});

  @override
  State<InstitucionesScreen> createState() => _InstitucionesScreenState();
}

class CentroApoyo {
  final String nombre;
  final String descripcion;
  final String telefono;
  final String mapaUrl;

  CentroApoyo(this.nombre, this.descripcion, this.telefono, this.mapaUrl);
}

class _InstitucionesScreenState extends State<InstitucionesScreen> {
  String selectedCategory = "Guadalajara";

  final Map<String, List<CentroApoyo>> institucionesPorMunicipio = {
    "CUCEA": [
      CentroApoyo(
        "Unidad Psicológica Edificio A - Aula 201",
        "Lunes a Viernes 7am a 9pm y Sábados de 8am a 2pm.",
        "3337703300 ext. 25976",
        "https://maps.google.com/?q=CUCEA",
      ),
      CentroApoyo(
        "Unidad Médica Edificio A - Aula 101",
        "Lunes a Viernes 8am a 9pm y Sábados de 8am a 5pm.",
        "3337703300 ext. 25414",
        "https://maps.google.com/?q=CUCEA",
      ),
    ],
    "Guadalajara": [
      CentroApoyo(
        "Hospital Puerta de Hierro Andares",
        "Atención 24/7",
        "3338482100",
        "https://maps.app.goo.gl/GJxxEw93ENCDpei98",
      ),
      CentroApoyo(
        "Centro Integral de Servicios (CISAME) Guadalajara",
        "Centro Integral de Salud Mental.",
        "3318169579",
        "https://maps.app.goo.gl/Pfowyu1LzReqeREs6",
      ),
      CentroApoyo(
        "Clínica Hospital Mariana",
        "Atención de Lunes a Sábado de 8am a 9pm.",
        "3313197873",
        "https://maps.app.goo.gl/RwhojtFtBofMY45r9",
      ),
      CentroApoyo(
        "Hospital MAC Guadalajara - Bernardette",
        "Atención 24/7",
        "5541698514",
        "https://maps.app.goo.gl/oThEeqPGV8GZvMQB9",
      ),
    ],
    "Zapopan": [
      CentroApoyo(
        "Sanatorio Guadalajara",
        "Atención 24/7",
        "3336150079",
        "https://maps.app.goo.gl/HfAybFvf3PiS1f6aA",
      ),
      CentroApoyo(
        "Centro De Atención Integral En Salud Mental Estancia Breve (Caisame Eb)",
        "Atención 24/7",
        "3330309990",
        "https://maps.app.goo.gl/VMCLycF7ei1U1gty6",
      ),
      CentroApoyo(
        "Hospital General de Zapopan",
        "De 7am a 8pm todos los días.",
        "3346832480",
        "https://maps.app.goo.gl/oW5eqpM49RX6Uw1Q7",
      ),
      CentroApoyo(
        "Hospitalito Sur de Zapopan",
        "Atención 24/7",
        "3346832480",
        "https://maps.app.goo.gl/ce5Qu6KFMZ6w5o1C6",
      ),
    ],
    "Tlaquepaque": [
      CentroApoyo(
        "Hospital Tlaquepaque",
        "Atención médica general",
        "(33) 3635 5315",
        "https://maps.app.goo.gl/RVKvbtf8Xq7ix1T86",
      ),
      CentroApoyo(
        "Centro Integral de Servicios (CISAME) Tlaquepaque",
        "Centro Integral de Salud Mental",
        "(33) 1224 1713",
        "https://maps.app.goo.gl/946kvZMtJi7CoQLr8",
      ),
      CentroApoyo(
        "Hospital Santa Clara",
        "Atención 24 hrs",
        "(33) 3659 6423",
        "https://goo.gl/maps/...https://maps.app.goo.gl/J3kpfrbM4PaHLRxM8",
      ),
      CentroApoyo(
        "Clínica San Pedro Apóstol",
        "Atención 24 hrs",
        "(33) 1233 0200",
        "https://maps.app.goo.gl/cJC93KFXLDDcWWq87",
      ),
    ],
    "Tlajomulco de Zúñiga": [
      CentroApoyo(
        "Hospital de Alta Especialidad ISSSTE Tlajomulco",
        "Atención médica general",
        "---",
        "https://maps.app.goo.gl/jNtcV6FWEvkDTK4s7",
      ),
      CentroApoyo(
        "Clínica San Gregorio",
        "Atención 24/7",
        "3337960167",
        "https://maps.app.goo.gl/w7xwk5ZewXMzRKz17",
      ),
      CentroApoyo(
        "Clínica de Especialidades Tlajomulco",
        "Atención 24/7",
        "3337980445",
        "https://maps.app.goo.gl/xfT6hHrpcuNvA2vj6",
      ),
      CentroApoyo(
        "Hospital General Regional 180 IMSS",
        "Atención 24/7",
        "---",
        "https://maps.app.goo.gl/MWPcry3kmzMR9FyG8",
      ),
    ],
  };

  // Función reutilizable para abrir enlaces y llamadas
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
                  onPressed: () => Navigator.pop(context),
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
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
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
            const SizedBox(height: 25),
            const Text(
              "Instituciones de Apoyo",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Text(
                "Selecciona tu ubicación para encontrar ayuda cercana.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),

            // SECCIÓN DE MUNICIPIOS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: institucionesPorMunicipio.keys.map((nombreMunicipio) {
                  return _buildCategoryButton(nombreMunicipio);
                }).toList(),
              ),
            ),

            const SizedBox(height: 15),
            const Divider(indent: 40, endIndent: 40),

            // LISTA DE INSTITUCIONES
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildInstitutionList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label) {
    bool isSelected = selectedCategory == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => selectedCategory = label),
      selectedColor: const Color(0xFF90CAF9),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(color: isSelected ? Colors.blue : Colors.transparent),
      ),
    );
  }

  Widget _buildInstitutionList() {
    // Buscamos la lista correspondiente al municipio seleccionado
    final centros = institucionesPorMunicipio[selectedCategory] ?? [];

    if (centros.isEmpty) {
      return const Center(
        child: Text("No hay centros registrados para este municipio."),
      );
    }

    return Column(
      children: centros.map((centro) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildInstitutionCard(
            centro.nombre,
            centro.descripcion,
            centro.telefono,
            centro.mapaUrl,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInstitutionCard(
    String title,
    String desc,
    String phone,
    String mapUrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL("tel:$phone"),
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text("LLAMAR"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF92D050),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL(mapUrl),
                  icon: const Icon(Icons.location_on, size: 18),
                  label: const Text("UBICACIÓN"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8AC2FE),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
