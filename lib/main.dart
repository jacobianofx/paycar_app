import 'package:flutter/material.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  try {
    runApp(const PaycarApp());
  } catch (e) {
    print('Error al iniciar la app: $e');
  }
}

class PaycarApp extends StatelessWidget {
  const PaycarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paycar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF215EAB), // Azul del logo
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF215EAB),
          secondary: const Color(0xFFFEC430), // Amarillo del logo
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF215EAB), //0xFF215EAB
            foregroundColor: Colors.white, // texto en blanco por defecto
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
