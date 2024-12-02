import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPropertyScreen extends StatefulWidget {
  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey =
      GlobalKey<FormState>(); // GlobalKey para validación del formulario
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _roomsController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false; // Indicador de carga

  void addProperty() async {
    if (!_formKey.currentState!.validate()) {
      return; // Si la validación falla, no continúa
    }

    setState(() {
      _isLoading = true; // Empieza la carga
    });

    await FirebaseFirestore.instance.collection('properties').add({
      'title': _titleController.text,
      'price': int.parse(_priceController.text),
      'location': _locationController.text,
      'rooms': int.parse(_roomsController.text),
      'description': _descriptionController.text,
    });

    setState(() {
      _isLoading = false; // Termina la carga
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Propiedad agregada exitosamente')),
    );

    Navigator.pop(context); // Regresar a la pantalla anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Propiedad'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Asignar el GlobalKey al formulario
            child: Column(
              children: [
                // Título
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    hintText: 'Ingresa el título de la propiedad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Precio
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    hintText: 'Ingresa el precio de la propiedad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un precio';
                    }
                    if (int.tryParse(value) == null) {
                      return 'El precio debe ser un número válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Ubicación
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Ubicación',
                    hintText: 'Ingresa la ubicación de la propiedad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una ubicación';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Número de Habitaciones
                TextFormField(
                  controller: _roomsController,
                  decoration: InputDecoration(
                    labelText: 'Número de Habitaciones',
                    hintText: 'Ingresa el número de habitaciones',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el número de habitaciones';
                    }
                    if (int.tryParse(value) == null) {
                      return 'El número de habitaciones debe ser un número válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Escribe una descripción detallada',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Botón de Agregar Propiedad
                _isLoading
                    ? CircularProgressIndicator() // Mostrar el indicador de carga
                    : ElevatedButton(
                        onPressed: addProperty,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Agregar Propiedad',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
