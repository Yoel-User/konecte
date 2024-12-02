import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'property_view_screen.dart'; // Pantalla para ver detalles (clientes)
import 'property_detail_screen.dart'; // Pantalla de detalles (corredores)
import 'login_screen.dart'; // Pantalla de Login

class ClienteHomeScreen extends StatelessWidget {
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
      extendBodyBehindAppBar: true, // Para que el fondo cubra el AppBar
      appBar: AppBar(
        title: Text(
          'Propiedades para Clientes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.jpg'), // Ruta de tu fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Título principal (separado de la lista)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Lista de propiedades
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('properties')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error al cargar propiedades',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }

                    final properties = snapshot.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: ListTile(
                            leading: Icon(Icons.home,
                                color: Colors.blueAccent, size: 30),
                            title: Text(
                              property['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                              'Precio: \$${property['price']} - Habitaciones: ${property['rooms']}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            onTap: () {
                              // Verifica si el usuario es un cliente o un corredor
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .get()
                                    .then((doc) {
                                  String role = doc['role'];
                                  if (role == 'corredor') {
                                    // Si es corredor, redirige a PropertyDetailScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PropertyDetailScreen(
                                                propertyId: property.id),
                                      ),
                                    );
                                  } else {
                                    // Si es cliente, redirige a PropertyViewScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PropertyViewScreen(
                                                propertyId: property.id),
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
