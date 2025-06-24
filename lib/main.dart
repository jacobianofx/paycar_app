import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'presentation/screens/login_screen.dart';

void main() => runApp(const PaycarApp());

class PaycarApp extends StatelessWidget {
  const PaycarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paycar App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
