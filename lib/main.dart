import 'package:flutter/material.dart';
import 'package:flutter_camera/home.dart';


void main() => runApp(
  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplicación de Cámara Flutter",
      home: Home(),
      theme: ThemeData(
      brightness: Brightness.dark,
    ),
  )
);