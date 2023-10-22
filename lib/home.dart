
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _ImagenState createState() => _ImagenState();
}
class _ImagenState extends State<Home> {
  File? imagen; // Variable para almacenar la imagen seleccionada
  final picker = ImagePicker(); // Instancia de picker para tomar o seleccionar imágenes
  bool fromCamera = false; // Para determinar si la imagen proviene de la cámara