import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_property_screen.dart'; // Asegúrate de importar la pantalla de editar propiedad

class PropertyDetailScreen extends StatelessWidget {
  final String propertyId;

  PropertyDetailScreen({required this.propertyId});

  // Función para eliminar la propiedad con confirmación
  void _deleteProperty(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      // Comprobamos si el usuario es un "corredor"
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String role = userDoc['role'];

      if (role == 'corredor') {
        // Mostrar diálogo de confirmación antes de eliminar
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar eliminación'),
              content:
                  Text('¿Estás seguro de que deseas eliminar esta propiedad?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    // Si se confirma la eliminación
                    await FirebaseFirestore.instance
                        .collection('properties')
                        .doc(propertyId)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Propiedad eliminada')));
                    Navigator.pop(context); // Volver a la lista de propiedades
                  },
                  child: Text('Eliminar'),
                ),
              ],
            );
          },
        );
      } else {
        // Si no es corredor, mostramos un mensaje
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No tienes permiso para eliminar esta propiedad')));
      }
    }
  }

  // Función para navegar a la pantalla de edición
  void _editProperty(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      // Comprobamos si el usuario es un "corredor"
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String role = userDoc['role'];

      if (role == 'corredor') {
        // Si es corredor, redirigimos a la pantalla de edición
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPropertyScreen(
                propertyId:
                    propertyId), // Redirigimos a la pantalla de editar propiedad
          ),
        );
      } else {
        // Si no es corredor, mostramos un mensaje
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No tienes permiso para editar esta propiedad')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Propiedad'),
        actions: [
          // Opciones de "Eliminar" y "Modificar" solo para los corredores
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () =>
                _editProperty(context), // Redirige a la pantalla de editar
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteProperty(
                context), // Llama a la función de eliminar propiedad
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('properties')
            .doc(propertyId)
            .get(), // Cargamos la propiedad usando el ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los detalles.'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Propiedad no encontrada.'));
          }

          var property = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Título: ${property['title']}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Precio: \$${property['price']}',
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Ubicación: ${property['location']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Habitaciones: ${property['rooms']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Descripción:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          property['description'] ?? 'No disponible',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
