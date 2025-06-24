import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF215EAB), // Azul del logo
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF215EAB),
        secondary: const Color(0xFFFEC430), // Amarillo del logo
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF215EAB),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
