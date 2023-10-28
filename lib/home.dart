
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _ImagenState createState() => _ImagenState();
}
class _ImagenState extends State<Home> {
  File? imagen; // Variable para almacenar la imagen seleccionada
  final picker = ImagePicker(); // Instancia de picker para tomar o seleccionar imágenes
  bool fromCamera = false; // Para determinar si la imagen proviene de la cámara

  // Método para tomar una foto con la cámara
  Future _takePicture() async {
    // Verificar si se tiene permiso de cámara
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    // Si no se tiene permiso, solicitarlo
    status = await Permission.camera.request();
    if (!status.isGranted) {
      // El usuario rechazó el permiso, puedes mostrar un mensaje o realizar alguna acción aquí.
      return;
    }
  }

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imagen = File(pickedFile.path); // Establece la imagen seleccionada
        fromCamera = true; // Indica que la imagen proviene de la cámara
      });
      _saveImage(pickedFile.path, fromCamera); // Guarda la imagen y muestra la alerta si proviene de la cámara
    }
  }

  // Método para seleccionar una imagen de la galería
  Future _selectImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagen = File(pickedFile.path); // Establece la imagen seleccionada
        fromCamera = false; // Indica que la imagen proviene de la galería
      });
      _saveImage(pickedFile.path, fromCamera); // Guarda la imagen y muestra la alerta si proviene de la cámara
    }
  }

  // Método para guardar la imagen y mostrar una alerta de que ha sido guardada en la galería
  Future<void> _saveImage(String imagePath, bool fromCamera) async {
    final result = await ImageGallerySaver.saveFile(imagePath);
    if (result != null && result['isSuccess'] && fromCamera) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Foto guardada'),
            content: Text('La foto se ha guardado en la galería.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Método para mostrar las opciones de tomar una foto o seleccionar de la galería
  opciones(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _takePicture(); // Llama al método para tomar una foto
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tomar una foto',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(Icons.camera_alt, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectImage(); // Llama al método para seleccionar una imagen de la galería
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Seleccionar de galería', style: TextStyle(fontSize: 16)),
                        ),
                        Icon(Icons.image, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 112, 112, 112),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplicación de Cámara Flutter'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    opciones(context); // Llama al método para mostrar las opciones
                  },
                  child: Text('Seleccione una imagen'),
                ),
                SizedBox(height: 30),
                imagen == null ? Center() : Image.file(imagen!) // Muestra la imagen seleccionada
              ],
            ),
          ),
        ],
      ),
    );
  }
}