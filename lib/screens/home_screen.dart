import 'package:flutter/material.dart';

  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // Esta parte es el header del Inicio / Perfil
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton(onPressed: () {},
                            child: const Text(
                                "Inicio", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold))),
                        TextButton(onPressed: () {},
                            child: const Text(
                                "Perfil", style: TextStyle(color: Colors.grey))),
                      ],
                    ),
                    Image.asset('assets/logo_stressting.png', height: 40),
                  ],
                ),
                const SizedBox(height: 30),

                const Text("Inicio", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 20),
                const Text("¿Qué es el estrés?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "Una respuesta de adaptación individual a amenazas internas o externas.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 20),

                _buildHomeButton("+ Informacion Del Estres", const Color(0xFF99CC33), () {}),
                _buildHomeButton("Realizar Diagnostico", const Color(0xFF90CAF9), () {}),
                _buildHomeButton("Instituciones de Apoyo", const Color(0xFF99CC33), () {}),
                _buildHomeButton("Recomendaciones", const Color(0xFF90CAF9), () {}),
                _buildHomeButton("Seguimiento", const Color(0xFF99CC33), () {}),
                _buildHomeButton("Comentarios", const Color(0xFF90CAF9), () {}),

                const SizedBox(height: 40),
                const Text("Permite sentir paz y tranquilidad", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.indigo)),
              ],
            ),
          ),
        )
      );
    }

    Widget _buildHomeButton(String text, Color color, VoidCallback onPressed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: const StadiumBorder(),
              elevation: 2,
            ),
            onPressed: onPressed,
            child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          )
        ),
      );
    }
  }