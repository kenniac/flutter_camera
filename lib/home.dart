
import 'package:flutter/material.dart';

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