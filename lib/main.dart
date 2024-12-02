import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart'; // Asegúrate de importar LoginScreen
import 'screens/home_screen.dart'; // Si lo necesitas para los corredores
import 'screens/cliente_home_screen.dart'; // Si lo necesitas para los clientes
import 'firebase_options.dart'; // Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Konecte',
      initialRoute: '/', // Especificamos la pantalla inicial
      routes: {
        '/': (context) =>
            LoginScreen(), // Aseguramos que la primera pantalla sea LoginScreen
        '/home': (context) => HomeScreen(), // Para los corredores
        '/cliente-home': (context) => ClienteHomeScreen(), // Para los clientes
      },
    );
  }
}
