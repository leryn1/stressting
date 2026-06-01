import 'package:flutter/material.dart';
import 'resultado_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/widgets/customAppBar.dart';
import '/widgets/question_card.dart';

class DiagnosticoScreen extends StatefulWidget {
  const DiagnosticoScreen({super.key});

  @override
  State<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class PreguntaEEP {
  final String texto;
  final bool esInversa;
  int? respuestaSeleccionada;

  PreguntaEEP(this.texto, {this.esInversa = false});
}

class _DiagnosticoScreenState extends State<DiagnosticoScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<PreguntaEEP> _preguntas = [
    PreguntaEEP(
      "1. ¿Con qué frecuencia ha estado afectado por algo que ha ocurrido inesperadamente?",
    ),
    PreguntaEEP(
      "2. ¿Con qué frecuencia se ha sentido incapaz de controlar las cosas importantes en su vida?",
    ),
    PreguntaEEP(
        "3. ¿Con qué frecuencia se ha sentido nervioso o estresado?"
    ),
    PreguntaEEP(
      "4. ¿Con qué frecuencia ha estado seguro sobre su capacidad para manejar sus problemas personales?",
      esInversa: true,
    ),
    PreguntaEEP(
      "5. ¿Con qué frecuencia ha sentido que las cosas le van bien?",
      esInversa: true,
    ),
    PreguntaEEP(
      "6. ¿Con qué frecuencia ha sentido que no podía afrontar todas las cosas que tenía que hacer?",
    ),
    PreguntaEEP(
      "7. ¿Con qué frecuencia ha podido controlar las dificultades de su vida?",
      esInversa: true,
    ),
    PreguntaEEP(
      "8. ¿Con qué frecuencia se ha sentido que tenía todo bajo control?",
      esInversa: true,
    ),
    PreguntaEEP(
      "9. ¿Con qué frecuencia ha estado enfadado porque las cosas que le han ocurrido estaban fuera de su control?",
    ),
    PreguntaEEP(
      "10. ¿Con qué frecuencia ha sentido que las dificultades se acumulan tanto que no puede superarlas?",
    ),
  ];

  //bool get _todoRespondido => _preguntas.every((p) => p.respuestaSeleccionada != null);
  int get _totalRespondidas =>
      _preguntas.where((p) => p.respuestaSeleccionada != null).length;

  Future<void> _finalizarDiagnostico() async {
    int puntajeTotal = 0;
    Map<String, int> respuestasMap = {};

    for (int i = 0; i < _preguntas.length; i++) {
      int valor = _preguntas[i].respuestaSeleccionada ?? 0;
      puntajeTotal += valor;
      respuestasMap["p${i + 1}"] = valor;
    }

    String nivel = "";
    if (puntajeTotal <= 17) {
      nivel = "Bajo";
    } else if (puntajeTotal <= 24) {
      nivel = "Medio";
    } else {
      nivel = "Alto";
    }

    try {
      final user = Supabase.instance.client.auth.currentUser;

      // Inserción de los datos en Supabase
      await Supabase.instance.client.from('stress_assessments').insert({
        'user_id': user?.id,
        'puntaje_total': puntajeTotal,
        'respuestas': respuestasMap,
        'nivel_estres': nivel,
      });

      if (!mounted) return;
      _mostrarResultado(nivel, puntajeTotal);
    } catch (e) {
      //print("Error al guardar en Supabase: $e");
      (e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar el diagnóstico: $e")),
        );
      }
    }
  }

  void _mostrarResultado(String nivel, int puntos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadoScreen(nivel: nivel, puntos: puntos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Diagnóstico",
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Image.asset('assets/logo_stressting.png', height: 65),
          ],
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _totalRespondidas / _preguntas.length,
            backgroundColor: Colors.white,
            color: const Color(0xFF99CC33), //
            minHeight: 10,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildIntroPage(),
                _buildQuestionsPage(0, 5),
                _buildQuestionsPage(5, 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F0FF),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.orange,
                  size: 22,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "A continuación, va a realizar su diagnóstico con el instrumento de Escala de Estrés Percibido EEP-10 para determinar su nivel de estrés.\n\n"
              "Se puntúa de la siguiente manera:\n\n"
              "• Estrés Bajo: 0 - 17 puntos\n"
              "• Estrés Medio: 18 - 24 puntos\n"
              "• Estrés Alto: 25 - 40 puntos",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4, // Interlineado más cómodo
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF92D050), // El verde del mockup
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
              ),
              child: const Text(
                "COMENZAR",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsPage(int start, int end) {
    bool rangoRespondido = _preguntas
        .sublist(start, end)
        .every((p) => p.respuestaSeleccionada != null);

    return SingleChildScrollView(
      child: Column(
        children: [
          ..._preguntas.sublist(start, end).map((pregunta) {
            return QuestionCard(
              texto: pregunta.texto,
              esInversa: pregunta.esInversa,
              respuestaSeleccionada: pregunta.respuestaSeleccionada,
              onSelected: (valor) {
                setState(() {
                  pregunta.respuestaSeleccionada = valor;
                });
              },
            );
          }),

          // Boton para Proseguir
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: rangoRespondido
                      ? const Color(0xFF90CAF9)
                      : Colors.grey[400],
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: rangoRespondido
                    ? (end == 10
                          ? _finalizarDiagnostico
                          : () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            })
                    // Boton de siguiente pantalla deshabilitado si no han respondido las 5 actuales
                    : null,
                child: Text(
                  end == 10 ? "FINALIZAR DIAGNÓSTICO" : "SIGUIENTE PÁGINA",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
