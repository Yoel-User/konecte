import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importamos FirebaseAuth
import 'add_property_screen.dart'; // Asegúrate de importar la pantalla AddPropertyScreen
import 'property_list_screen.dart'; // Asegúrate de importar la pantalla PropertyListScreen
import 'login_screen.dart'; // Importamos la pantalla LoginScreen para redirigir al login

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Función para cerrar sesión
  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut(); // Cerrar sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginScreen()), // Redirigir al Login después de cerrar sesión
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Fondo que cubra el AppBar
      appBar: AppBar(
        title: Text(
          'Konecte - Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background_home.jpg'), // Ruta de fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(100),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Espacio para el logo de Konecte en la parte superior
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Image.asset(
                      'assets/images/konecte_logo.jpg', // Ruta del logo
                      height: 120, // Tamaño del logo
                    ),
                  ),
                  SizedBox(height: 40),
                  // Botón de Agregar Propiedad
                  ElevatedButton(
                    onPressed: () {
                      // Redirige a la pantalla de "Agregar Propiedad"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPropertyScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Color del botón
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      'Agregar Propiedad',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botón de Ver Propiedades
                  ElevatedButton(
                    onPressed: () {
                      // Redirige a la pantalla de "Ver Propiedades"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PropertyListScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent, // Color del botón
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      'Ver Propiedades',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botón de Cerrar Sesión
                  ElevatedButton(
                    onPressed: () => _signOut(
                        context), // Llamamos a la función de cierre de sesión
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .redAccent, // Color rojo para llamar la atención
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
