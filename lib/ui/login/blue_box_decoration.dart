import 'package:flutter/material.dart';
var blueBoxDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Colors.blue,
      Colors.blue[900]!,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);
