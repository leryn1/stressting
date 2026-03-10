import 'package:flutter/material.dart';
import 'package:stressting/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

  class LoginScreen extends StatefulWidget {
    const LoginScreen({super.key});

    @override
    State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {

    final _emailCtrl = TextEditingController();
    final _passwordCtrl = TextEditingController();
    bool _isLoading = false;

    Future<void> _iniciarSesion() async {
      setState(() => _isLoading = true);

      try {
        final response = await Supabase.instance.client.auth.signInWithPassword(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text.trim(),
        );

        if (response.user != null) {
          Navigator.pushAndRemoveUntil(
            context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Bienvenidx de vuelta.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Email o Contraseña incorrectos"), backgroundColor: Colors.red,)
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Text("Complete los datos faltantes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  onPressed: _isLoading ? null : _iniciarSesion,
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Iniciar Sesion", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        )
      );
    }
  }