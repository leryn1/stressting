import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stressting/screens/home_screen.dart';
// IMPORTANTE: Asegúrate de ajustar estas rutas según el nombre de tu proyecto
import 'package:stressting/widgets/custom_text_field.dart';
import 'package:stressting/widgets/custom_dropdown_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _celularCtrl = TextEditingController();
  final _emergenciaNombreCtrl = TextEditingController();
  final _emergenciaTelCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _codigoCtrl = TextEditingController();
  final _carreraCtrl = TextEditingController();
  final _cicloCtrl = TextEditingController();
  final _otroGeneroCtrl = TextEditingController();

  String? _selectedTipoSangre;
  final List<String> _opcionesTipoSangre = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

  String? _selectedGenero;
  final List<String> _opcionesGenero = [
    "Cisgénero", "Transgénero", "Hombre Trans", "Mujer Trans", "No binarix",
    "Género Fluido", "Agénero", "Bigénero", "Demichico", "Demichica",
    "Género Neutro", "Género Queer", "Andróginx", "Otro"
  ];

  String? _selectedCentro;
  final List<String> _opcionesCentro = [
    "CUCEA", "CUCSH", "CUAAD", "CUCBA", "CUGDL",
    "CUCS", "CUCEI", "CUTLAQUE", "CUTONALA", "CUTLAJO"
  ];

  String? _selectedSexo;
  bool _esUdg = false;
  bool _mostrarEspecificarGenero = false;

  Future<void> _crearCuenta() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, corrige los campos marcados en rojo."), backgroundColor: Colors.red),
      );
      return;
    }

    if (_selectedSexo == null || _selectedTipoSangre == null || _selectedGenero == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecciona Sexo, Género y Tipo de Sangre."), backgroundColor: Colors.red),
      );
      return;
    }

    if (_esUdg && _selectedCentro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecciona tu Centro Universitario."), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        data: {
          'nombre': _nombreCtrl.text.trim(),
          'edad': int.tryParse(_edadCtrl.text.trim()) ?? 0,
          'sexo': _selectedSexo,
          'genero': _selectedGenero == "Otro"
              ? (_otroGeneroCtrl.text.trim().isEmpty ? 'Otro' : _otroGeneroCtrl.text.trim())
              : (_selectedGenero ?? 'N/A'),
          'rh': _selectedTipoSangre,
          'celular': _celularCtrl.text.trim(),
          'emergencia_nombre': _emergenciaNombreCtrl.text.trim(),
          'emergencia_telefono': _emergenciaTelCtrl.text.trim(),
          'es_udg': _esUdg,
          'codigo': _esUdg ? _codigoCtrl.text.trim() : null,
          'carrera': _esUdg ? _carreraCtrl.text.trim() : null,
          'centro': _esUdg ? _selectedCentro : null,
          'ciclo': _esUdg ? _cicloCtrl.text.trim() : null,
        },
      );

      if (!mounted) return;
      Navigator.pop(context);

      if (res.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Cuenta creada con éxito! Bienvenidx."), backgroundColor: Color(0xFF689F38)),
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
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Datos Generales", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

              CustomTextField(
                label: "Nombre *",
                controller: _nombreCtrl,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]'))],
                validator: (val) => val!.trim().isEmpty ? "El nombre es obligatorio" : null,
              ),
              CustomTextField(
                label: "Edad *",
                controller: _edadCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val!.trim().isEmpty) return "La edad es obligatoria";
                  final edad = int.tryParse(val);
                  if (edad == null || edad <= 0 || edad > 120) return "Ingresa una edad válida";
                  return null;
                },
              ),
              CustomDropdownField(
                label: "Sexo *",
                options: const ["Masculino", "Femenino", "Otro"],
                currentValue: _selectedSexo,
                onChanged: (val) => setState(() => _selectedSexo = val),
                validator: (val) => val == null ? "El sexo es obligatorio" : null,
              ),
              CustomDropdownField(
                label: "Género *",
                options: _opcionesGenero,
                currentValue: _selectedGenero,
                onChanged: (val) {
                  setState(() {
                    _selectedGenero = val;
                    _mostrarEspecificarGenero = (val == "Otro");
                  });
                },
                validator: (val) => val == null ? "El género es obligatorio" : null,
              ),

              if (_mostrarEspecificarGenero)
                CustomTextField(
                  label: "Especifica tu género *",
                  controller: _otroGeneroCtrl,
                  hint: "Ej: Trigénero",
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]'))],
                  validator: (val) => (_mostrarEspecificarGenero && val!.trim().isEmpty) ? "Por favor especifica tu género" : null,
                ),

              CustomDropdownField(
                label: "Tipo de Sangre (RH) *",
                options: _opcionesTipoSangre,
                currentValue: _selectedTipoSangre,
                onChanged: (val) => setState(() => _selectedTipoSangre = val),
                validator: (val) => val == null ? "El tipo de sangre es obligatorio" : null,
              ),
              CustomTextField(
                label: "Celular *",
                controller: _celularCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val!.trim().isEmpty) return "El celular es obligatorio";
                  if (val.trim().length < 10) return "El número debe tener al menos 10 dígitos";
                  return null;
                },
              ),

              const Divider(height: 40, thickness: 5),
              const Text("Contacto de emergencia", style: TextStyle(fontWeight: FontWeight.bold)),

              CustomTextField(
                label: "Nombre del contacto *",
                controller: _emergenciaNombreCtrl,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]'))],
                validator: (val) => val!.trim().isEmpty ? "Este campo es requerido" : null,
              ),
              CustomTextField(
                label: "Teléfono del contacto *",
                controller: _emergenciaTelCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val!.trim().isEmpty) return "El teléfono de emergencia es obligatorio";
                  if (val.trim().length < 10) return "Debe tener al menos 10 dígitos";
                  return null;
                },
              ),

              const Divider(height: 40, thickness: 5),
              const Text("Correo y Contraseña", style: TextStyle(fontWeight: FontWeight.bold)),

              CustomTextField(
                label: "Email *",
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val!.trim().isEmpty) return "El email es obligatorio";
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(val.trim())) return "Ingresa un correo electrónico válido";
                  return null;
                },
              ),
              CustomTextField(
                label: "Contraseña *",
                controller: _passwordCtrl,
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
                  child: Text("Datos Universitarios", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
                CustomTextField(
                  label: "Código *",
                  controller: _codigoCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (val) => (_esUdg && val!.trim().isEmpty) ? "El código es obligatorio" : null,
                ),
                CustomDropdownField(
                  label: "Centro Universitario *",
                  options: _opcionesCentro,
                  currentValue: _selectedCentro,
                  onChanged: (val) => setState(() => _selectedCentro = val),
                  validator: (val) => (_esUdg && val == null) ? "El centro universitario es obligatorio" : null,
                ),
                CustomTextField(
                  label: "Carrera *",
                  controller: _carreraCtrl,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ ]'))],
                  validator: (val) => (_esUdg && val!.trim().isEmpty) ? "La carrera es obligatoria" : null,
                ),
                CustomTextField(
                  label: "Ciclo *",
                  controller: _cicloCtrl,
                  hint: "Ej: 2026A",
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                  validator: (val) => (_esUdg && val!.trim().isEmpty) ? "El ciclo es obligatorio" : null,
                ),
              ],

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF689F38), shape: const StadiumBorder()),
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
    _cicloCtrl.dispose();
    _otroGeneroCtrl.dispose();
    super.dispose();
  }
}