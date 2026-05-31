import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <--- CRUCIAL: Para usar los Formatters
import 'package:stressting/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart'; // Manteniendo tu estilo visual

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  // Clave global para validar el formulario completo de manera nativa
  final _formKey = GlobalKey<FormState>();

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
  final List<String> _opcionesRH = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
  String? _selectedSexo;
  bool _esUdg = false;

  Future<void> _crearCuenta() async {
    // Primero, validamos que todos los campos requeridos cumplan las condiciones
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, corrige los campos marcados en rojo."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedSexo == null || _selectedRH == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, selecciona Sexo y Tipo de Sangre (RH)."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
          'edad': int.tryParse(_edadCtrl.text.trim()) ?? 0, // Lo parseamos a número para tu DB
          'sexo': _selectedSexo,
          'genero': _generoCtrl.text.trim().isEmpty ? 'N/A' : _generoCtrl.text.trim(),
          'rh': _selectedRH,
          'celular': _celularCtrl.text.trim(),
          'emergencia_nombre': _emergenciaNombreCtrl.text.trim(),
          'emergencia_telefono': _emergenciaTelCtrl.text.trim(),
          'es_udg': _esUdg,
          'codigo': _esUdg ? _codigoCtrl.text.trim() : null,
          'carrera': _esUdg ? _carreraCtrl.text.trim() : null,
          'centro': _esUdg ? _centroCtrl.text.trim() : null,
          'ciclo': _esUdg ? _cicloCtrl.text.trim() : null,
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
            backgroundColor: Color(0xFF689F38),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text("Ingresar datos"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey, // Envolvemos todo en un widget Form para activar los validadores
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Datos Generales",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              _buildTextField(
                "Nombre *",
                _nombreCtrl,
                // Expresión Regular: Solo permite letras de la A-Z (mayúsculas, minúsculas, acentos y espacios)
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]'))],
                validator: (val) => val!.trim().isEmpty ? "El nombre es obligatorio" : null,
              ),
              _buildTextField(
                "Edad *",
                _edadCtrl,
                keyboardType: TextInputType.number,
                // Solo números enteros directos
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val!.trim().isEmpty) return "La edad es obligatoria";
                  final edad = int.tryParse(val);
                  if (edad == null || edad <= 0 || edad > 120) return "Ingresa una edad válida";
                  return null;
                },
              ),
              _buildDropdown("Sexo *", ["Masculino", "Femenino", "Otro"],
                      (val) => setState(() => _selectedSexo = val)),
              _buildTextField(
                "Género",
                _generoCtrl,
                hint: "Ej: No binarix, Transgénero, etc.",
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]'))],
              ),
              _buildDropdown("RH *", _opcionesRH,
                      (val) => setState(() => _selectedRH = val)),
              _buildTextField(
                "Celular *",
                _celularCtrl,
                keyboardType: TextInputType.phone,
                // Permite números de teléfono puros sin letras
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val!.trim().isEmpty) return "El celular es obligatorio";
                  if (val.trim().length < 10) return "El número debe tener al menos 10 dígitos";
                  return null;
                },
              ),

              const Divider(height: 40, thickness: 5),
              const Text(
                "Contacto de emergencia",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildTextField(
                "Nombre del contacto *",
                _emergenciaNombreCtrl,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]'))],
                validator: (val) => val!.trim().isEmpty ? "Este campo es requerido" : null,
              ),
              _buildTextField(
                "Teléfono del contacto *",
                _emergenciaTelCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val!.trim().isEmpty) return "El teléfono de emergencia es obligatorio";
                  if (val.trim().length < 10) return "Debe tener al menos 10 dígitos";
                  return null;
                },
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
                validator: (val) {
                  if (val!.trim().isEmpty) return "El email es obligatorio";
                  // Validación estructurada de sintaxis de correo electrónico (RegEx estándar)
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(val.trim())) return "Ingresa un correo electrónico válido";
                  return null;
                },
              ),
              _buildTextField(
                "Contraseña *",
                _passwordCtrl,
                obscureText: true,
                validator: (val) {
                  if (val!.isEmpty) return "La contraseña es obligatoria";
                  if (val.length < 6) return "La contraseña debe tener mínimo 6 caracteres";
                  return null;
                },
              ),

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
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                _buildTextField(
                  "Código *",
                  _codigoCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (val) => (_esUdg && val!.trim().isEmpty) ? "El código es obligatorio" : null,
                ),
                _buildTextField(
                  "Centro Universitario *",
                  _centroCtrl,
                  hint: "Ej: CUCEI, CUCEA...",
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]'))],
                  validator: (val) => (_esUdg && val!.trim().isEmpty) ? "El centro universitario es obligatorio" : null,
                ),
                _buildTextField(
                  "Carrera *",
                  _carreraCtrl,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]'))],
                  validator: (val) => (_esUdg && val!.trim().isEmpty) ? "La carrera es obligatoria" : null,
                ),
                _buildTextField(
                  "Ciclo *",
                  _cicloCtrl,
                  hint: "Ej: 2026A",
                  // Los ciclos llevan números y letras combinados, por lo que bloqueamos caracteres especiales raros
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                  validator: (val) => (_esUdg && val!.trim().isEmpty) ? "El ciclo es obligatorio" : null,
                ),
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
                  child: const Text("REGISTRO", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // REFACTORIZACIÓN: Añadimos soporte nativo para 'inputFormatters' y 'validator'
  Widget _buildTextField(
      String label,
      TextEditingController? controller, {
        TextInputType? keyboardType,
        bool obscureText = false,
        String? hint,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters, // Aplica el filtro en tiempo de escritura
        validator: validator, // Dispara el aviso visual en rojo si está mal
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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