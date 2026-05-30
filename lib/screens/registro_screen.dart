import 'package:flutter/material.dart';
import 'package:stressting/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _nombreCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _celularCtrl = TextEditingController();
  final _generoCtrl = TextEditingController();
  final _emergenciaNombreCtrl = TextEditingController();
  final _emergenciaTelCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _codigoCtrl = TextEditingController();
  final _carreraCtrl = TextEditingController();
  final _centroCtrl = TextEditingController();
  final _cicloCtrl = TextEditingController();

  String? _selectedRH;
  final List<String> _opcionesRH = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];
  String? _selectedSexo;
  bool _esUdg = false;

  Future<void> _crearCuenta() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // 1. Registro en Supabase Auth
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        data: {
          'nombre': _nombreCtrl.text.trim(),
          'edad': _edadCtrl.text.trim(),
          'sexo': _selectedSexo,
          'genero': _generoCtrl.text.trim(),
          'rh': _selectedRH,
          'celular': _celularCtrl.text.trim(),
          'emergencia_nombre': _emergenciaNombreCtrl.text.trim(),
          'emergencia_telefono': _emergenciaTelCtrl.text.trim(),
          'es_udg': _esUdg,
          'codigo': _codigoCtrl.text.trim(),
          'carrera': _carreraCtrl.text.trim(),
          'centro': _centroCtrl.text.trim(),
          'ciclo': _cicloCtrl.text.trim(),
        },
      );

      if (!mounted) return;
      Navigator.pop(context); // Cerramos el CircularProgressIndicator

      if (res.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Cuenta creada con éxito! Bienvenidx."),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  // --- UI Original ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text("Ingresar datos"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Datos Generales",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            _buildTextField("Nombre *", _nombreCtrl),
            _buildTextField(
              "Edad *",
              _edadCtrl,
              keyboardType: TextInputType.number,
            ),
            _buildDropdown("Sexo *", [
              "Masculino",
              "Femenino",
              "Otro",
            ], (val) => setState(() => _selectedSexo = val)),
            _buildTextField(
              "Género",
              _generoCtrl,
              hint: "Ej: No binarix, Transgénero, etc.",
            ),
            _buildDropdown(
              "RH *",
              _opcionesRH,
              (val) => setState(() => _selectedRH = val),
            ),
            _buildTextField(
              "Celular *",
              _celularCtrl,
              keyboardType: TextInputType.phone,
            ),

            const Divider(height: 40, thickness: 5),
            const Text(
              "Contacto de emergencia",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildTextField("Nombre del contacto *", _emergenciaNombreCtrl),
            _buildTextField(
              "Teléfono del contacto *",
              _emergenciaTelCtrl,
              keyboardType: TextInputType.phone,
            ),

            const Divider(height: 40, thickness: 5),
            const Text(
              "Correo y Contraseña",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildTextField(
              "Email *",
              _emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField("Contraseña *", _passwordCtrl, obscureText: true),

            SwitchListTile(
              title: const Text("¿Es de la UDG? *"),
              value: _esUdg,
              onChanged: (bool value) => setState(() => _esUdg = value),
            ),

            if (_esUdg) ...[
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Datos Universitarios",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              _buildTextField(
                "Código *",
                _codigoCtrl,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                "Centro Universitario *",
                _centroCtrl,
                hint: "Ej: CUCEI, CUCEA...",
              ),
              _buildTextField("Carrera *", _carreraCtrl),
              _buildTextField("Ciclo *", _cicloCtrl, hint: "Ej: 2026A"),
            ],

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF689F38),
                  shape: const StadiumBorder(),
                ),
                onPressed: _crearCuenta,
                child: const Text(
                  "REGISTRO",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widgets Auxiliares
  Widget _buildTextField(
    String label,
    TextEditingController? controller, {
    TextInputType? keyboardType,
    bool obscureText = false,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        items: options
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _edadCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _celularCtrl.dispose();
    _emergenciaNombreCtrl.dispose();
    _emergenciaTelCtrl.dispose();
    _codigoCtrl.dispose();
    _carreraCtrl.dispose();
    _centroCtrl.dispose();
    _cicloCtrl.dispose();
    _generoCtrl.dispose();
    super.dispose();
  }
}
