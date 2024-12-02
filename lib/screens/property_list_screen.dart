import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'property_detail_screen.dart'; // Importamos la pantalla de detalle

class PropertyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Propiedades'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('properties').snapshots(),
        builder: (context, snapshot) {
          // Cargando datos
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Indicador de carga mientras se obtienen datos
          }

          // Error al obtener datos
          if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar los datos',
                    style: TextStyle(color: Colors.red)));
          }

          // Si no hay datos
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay propiedades disponibles.'));
          }

          // Si tenemos datos, los procesamos
          final properties = snapshot.data!.docs;

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];

              // Renderizar cada propiedad como una tarjeta
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    property['title'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'Precio: \$${property['price']}',
                        style: TextStyle(color: Colors.green),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Habitaciones: ${property['rooms']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navegar a la pantalla de detalles de la propiedad
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailScreen(
                          propertyId:
                              property.id, // Pasamos el ID de la propiedad
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
