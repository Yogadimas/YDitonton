import 'package:flutter/material.dart';

// colors
const Color richBlack = Color(0xFF000814);
const Color oxfordBlue = Color(0xFF001D3D);
const Color prussianBlue = Color(0xFF003566);
const Color mikadoYellow = Color(0xFFffc300);
const Color davysGrey = Color(0xFF4B5358);
const Color grey = Color(0xFF303030);

const colorScheme = ColorScheme(
  primary: mikadoYellow,
  secondary: prussianBlue,
  secondaryContainer: prussianBlue,
  surface: richBlack,
  error: Colors.red,
  onPrimary: richBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
