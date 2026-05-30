import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),

            Image.asset('assets/logo_stressting.png', height: 300),

            //const Text(
            //'Stressting',
            //style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            //),

            // Descripción
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                'Esta aplicación está diseñada para realizar un diagnóstico con el uso de la Escala de Estrés Percibido (EEP).',
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            // Cuadro de Bienvenida
            Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Color(0xFFE0E9FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),

              child: Column(
                children: [
                  const Text(
                    "Bienvenido",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Text('A la app de bienestar y equilibrio'),
                  const SizedBox(height: 30),

                  // Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Registro
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[300],
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/registro');
                      },
                      child: const Text(
                        'Registro',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
