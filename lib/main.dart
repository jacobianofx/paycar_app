import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'config/theme/app_theme.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/catalog_screen.dart';
import 'presentation/screens/cart_screen.dart';

void main() {
  runApp(const PaycarApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/catalogo',
      builder: (context, state) => const CatalogScreen(),
    ),
    GoRoute(path: '/carrito', builder: (context, state) => const CartScreen()),
  ],
);

class PaycarApp extends StatelessWidget {
  const PaycarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
