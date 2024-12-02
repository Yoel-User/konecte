import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPropertyScreen extends StatefulWidget {
  final String propertyId;

  EditPropertyScreen({required this.propertyId});

  @override
  _EditPropertyScreenState createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _roomsController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _loadPropertyData();
  }

  // Cargar los datos actuales de la propiedad
  void _loadPropertyData() async {
    try {
      DocumentSnapshot property = await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .get();

      setState(() {
        _titleController.text = property['title'];
        _priceController.text = property['price'].toString();
        _locationController.text = property['location'];
        _roomsController.text = property['rooms'].toString();
        _descriptionController.text = property['description'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar la propiedad')));
    }
  }

  // Función para actualizar la propiedad en Firestore
  void _updateProperty() async {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _roomsController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .update({
        'title': _titleController.text,
        'price': int.parse(_priceController.text),
        'location': _locationController.text,
        'rooms': int.parse(_roomsController.text),
        'description': _descriptionController.text,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Propiedad actualizada')));
      Navigator.pop(context); // Regresar a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la propiedad')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Propiedad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator()) // Mostrar carga mientras se obtienen los datos
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Título'),
                  ),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Ubicación'),
                  ),
                  TextField(
                    controller: _roomsController,
                    decoration:
                        InputDecoration(labelText: 'Número de Habitaciones'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProperty,
                    child: Text('Actualizar Propiedad'),
                  ),
                ],
              ),
      ),
    );
  }
}
