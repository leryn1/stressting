import 'package:flutter/material.dart';
import '../widgets/customAppBar.dart';
import '../widgets/action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  onPressed: () {},
                  child: const Text(
                    "Inicio",
                    style: TextStyle(
                      color: Colors.indigo,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Inicio",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "¿Qué es el estrés?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "Una respuesta de adaptación individual a amenazas internas o externas.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              ActionButton(
                text: "+ Información Del Estrés",
                color: const Color(0xFF99CC33),
                onPressed: () {
                  Navigator.pushNamed(context, '/infoEstres');
                },
              ),
              ActionButton(
                text: "Realizar Diagnóstico",
                color: const Color(0xFF90CAF9),
                onPressed: () => {Navigator.pushNamed(context, '/diagnostico')},
              ),
              ActionButton(
                text: "Instituciones de Apoyo",
                color: const Color(0xFF99CC33),
                onPressed: () {
                  Navigator.pushNamed(context, '/instituciones');
                },
              ),
              ActionButton(
                text: "Recomendaciones",
                color: const Color(0xFF90CAF9),
                onPressed: () {
                  Navigator.pushNamed(context, '/recomendaciones');
                },
              ),
              ActionButton(
                text: "Seguimiento",
                color: const Color(0xFF99CC33),
                onPressed: () {
                  Navigator.pushNamed(context, '/seguimiento');
                },
              ),
              ActionButton(
                text: "Comentarios",
                color: const Color(0xFF90CAF9),
                onPressed: () {},
              ),

              const SizedBox(height: 40),
              const Text(
                "Permite sentir paz y tranquilidad",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
