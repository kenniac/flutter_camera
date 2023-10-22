
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

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