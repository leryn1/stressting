import 'package:flutter/material.dart';
import 'package:stressting/screens/home_screen.dart';
import 'package:stressting/widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      if (response.user != null && mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bienvenidx de vuelta."), backgroundColor: Color(0xFF689F38)));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: Email o Contraseña incorrectos"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black54)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30), // Un espacio superior un poco más sutil
            Image.asset(
              'assets/logo_stressting.png',
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Icon(Icons.psychology, size: 60, color: Colors.blue),
            ),
            const SizedBox(height: 35),

            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.6, // Sube un poco para abrazar mejor la pantalla baja
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFE3EDFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("Complete los datos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Email",
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val!.trim().isEmpty ? "Ingresa tu correo" : null,
                    ),
                    CustomTextField(
                      label: "Contraseña",
                      controller: _passwordCtrl,
                      obscureText: true,
                      validator: (val) => val!.isEmpty ? "Ingresa tu contraseña" : null,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7CB3F5),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: _isLoading ? null : _iniciarSesion,
                        child: _isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("INICIAR SESIÓN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}