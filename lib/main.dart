import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stressting/screens/seguimiento_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registro_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/infoEstres_screen.dart';
import 'screens/sitiosWeb_screen.dart';
import 'screens/diagnostico_screen.dart';
import 'screens/instituciones_screen.dart';
import 'screens/recomendaciones_screen.dart';
import 'screens/comentarios_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    (e);
    //print("Error: No se pudo cargar el archivo .env: $e");
  }
  //print("URL Cargada: '${dotenv.env['SUPABASE_URL']}'");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stressting',
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/infoEstres': (context) => const InfoEstresScreen(),
        '/sitiosWeb': (context) => const SitiosWebScreen(),
        '/diagnostico': (context) => const DiagnosticoScreen(),
        '/instituciones': (context) => const InstitucionesScreen(),
        '/recomendaciones': (context) => const RecommendationsScreen(),
        '/seguimiento': (context) => const SeguimientoScreen(),
        '/comentarios': (context) => const ComentariosScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
