import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../widgets/customAppBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _isEditing = false;
  String? _avatarUrl;

  late TextEditingController _nombreController;
  late TextEditingController _edadController;
  late TextEditingController _sexoController;
  late TextEditingController _generoController;
  late TextEditingController _rhController;
  late TextEditingController _celularController;
  late TextEditingController _emergenciaNombreController;
  late TextEditingController _emergenciaTelController;

  final TextEditingController _carreraController = TextEditingController();
  final TextEditingController _cicloController = TextEditingController();
  final TextEditingController _centroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _edadController = TextEditingController();
    _sexoController = TextEditingController();
    _generoController = TextEditingController();
    _rhController = TextEditingController();
    _celularController = TextEditingController();
    _emergenciaNombreController = TextEditingController();
    _emergenciaTelController = TextEditingController();
    _getProfile();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _sexoController.dispose();
    _generoController.dispose();
    _rhController.dispose();
    _celularController.dispose();
    _emergenciaNombreController.dispose();
    _emergenciaTelController.dispose();
    _carreraController.dispose();
    _cicloController.dispose();
    _centroController.dispose();
    super.dispose();
  }

  Future<void> _getProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('profiles')
          .select('*, udg_data(*)')
          .eq('id', user.id)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _userData = response;
          _avatarUrl = response?['avatar_url'];
          if (response != null) {
            _fillControllers(response);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _fillControllers(Map<String, dynamic> data) {
    _nombreController.text = data['nombre'] ?? '';
    _edadController.text = data['edad']?.toString() ?? '';
    _sexoController.text = data['sexo'] ?? '';
    _generoController.text = data['genero'] ?? '';
    _rhController.text = data['rh'] ?? '';
    _celularController.text = data['celular'] ?? '';
    _emergenciaNombreController.text = data['contacto_emergencia_nombre'] ?? '';
    _emergenciaTelController.text = data['contacto_emergencia_telefono'] ?? '';

    final udg = data['udg_data'];
    final udgInfo = (udg is List && udg.isNotEmpty) ? udg[0] : udg;

    _carreraController.text = udgInfo?['carrera'] ?? '';
    _cicloController.text = udgInfo?['ciclo'] ?? '';
    _centroController.text = udgInfo?['centro_universitario'] ?? '';
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase
          .from('profiles')
          .update({
            'nombre': _nombreController.text,
            'edad': int.tryParse(_edadController.text),
            'sexo': _sexoController.text,
            'genero': _generoController.text,
            'rh': _rhController.text,
            'celular': _celularController.text,
            'contacto_emergencia_nombre': _emergenciaNombreController.text,
            'contacto_emergencia_telefono': _emergenciaTelController.text,
          })
          .eq('id', userId)
          .select();

      if (_userData?['es_udg'] == true) {
        try {
          await supabase
              .from('udg_data')
              .update({
                'ciclo': _cicloController.text,
                'carrera': _carreraController.text,
                'centro_universitario': _centroController.text,
              })
              .eq('id', userId);
        } catch ($e) {
          ($e);
        }
      }

      await _getProfile();

      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Perfil y datos UDG actualizados!")),
        );
      }
    } catch (e) {
      (e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al sincronizar: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;

    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser!;
      final bytes = await image.readAsBytes();

      img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) return;
      img.Image resized = img.copyResize(decoded, width: 250, height: 250);
      final finalImage = img.encodeJpg(resized);

      final fileName =
          '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage
          .from('avatars')
          .uploadBinary(
            fileName,
            finalImage,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final String publicUrl = supabase.storage
          .from('avatars')
          .getPublicUrl(fileName);
      await supabase
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', user.id);

      setState(() => _avatarUrl = publicUrl);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _isEditing
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 28),
                    onPressed: () => setState(() {
                      _isEditing = false;
                      _fillControllers(_userData!);
                    }),
                  )
                : Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: const Text(
                          "Inicio",
                          style: TextStyle(color: Colors.black54, fontSize: 20),
                        ),
                      ),
                      const Text(
                        "Perfil",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
            IconButton(
              icon: Icon(
                _isEditing ? Icons.check_circle : Icons.edit,
                color: _isEditing ? Colors.green : Colors.indigo,
                size: 32,
              ),
              onPressed: () {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  setState(() => _isEditing = true);
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Mi Perfil",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 25),

            Stack(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundColor: const Color(0xFFD1D9FF),
                  backgroundImage: _avatarUrl != null
                      ? NetworkImage(_avatarUrl!)
                      : null,
                  child: _avatarUrl == null
                      ? const Icon(Icons.person, size: 70, color: Colors.indigo)
                      : null,
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 20,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            _buildSectionHeader("Datos personales"),
            _buildField("Nombre", _nombreController, Icons.person_outline),
            _buildInfoRow(
              "Email:",
              _userData?['email'] ?? 'N/A',
              Icons.email_outlined,
            ),
            _buildField(
              "Edad",
              _edadController,
              Icons.calendar_today,
              isNumber: true,
            ),
            _buildField("Sexo", _sexoController, Icons.wc),
            _buildField("Género", _generoController, Icons.face),
            _buildField("RH", _rhController, Icons.bloodtype_outlined),
            _buildField("Celular", _celularController, Icons.phone_android),

            const SizedBox(height: 25),
            _buildSectionHeader("Contacto de emergencia"),
            _buildField(
              "Nombre Emergencia",
              _emergenciaNombreController,
              Icons.contact_emergency_outlined,
            ),
            _buildField(
              "Tel. Emergencia",
              _emergenciaTelController,
              Icons.phone_enabled_outlined,
              isNumber: true,
            ),

            if (_userData?['es_udg'] == true) ...[
              const SizedBox(height: 25),
              _buildSectionHeader("Datos UDG"),
              _buildInfoRow(
                "Código:",
                _userData?['udg_data']?['codigo']?.toString() ?? 'N/A',
                Icons.badge_outlined,
              ),
              _buildField(
                "Ciclo",
                _cicloController,
                Icons.calendar_today_outlined,
              ),
              _buildField("Carrera", _carreraController, Icons.school_outlined),
              _buildField(
                "Centro Universitario",
                _centroController,
                Icons.account_balance_outlined,
              ),
            ],

            const SizedBox(height: 40),
            if (!_isEditing)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  minimumSize: const Size(double.infinity, 50),
                  shape: const StadiumBorder(),
                ),
                onPressed: () async {
                  await supabase.auth.signOut();
                  if (mounted)
                    Navigator.pushReplacementNamed(context, '/welcome');
                },
                child: const Text(
                  "CERRAR SESIÓN",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _isEditing
          ? TextField(
              controller: controller,
              keyboardType: isNumber
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(icon, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            )
          : _buildInfoRow(
              "$label:",
              controller.text.isEmpty ? 'N/A' : controller.text,
              icon,
            ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.indigo.withOpacity(0.7)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
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
        const Divider(color: Colors.orange, thickness: 1.5),
        const SizedBox(height: 10),
      ],
    );
  }
}
