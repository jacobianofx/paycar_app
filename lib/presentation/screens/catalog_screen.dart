import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paycar_app/services/cart_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/primary_button.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String username = '';
  final ProductService _productService = ProductService();
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initScreen();
  }

  Future<void> _initScreen() async {
    await Future.wait([_loadUsername(), _loadProducts()]);
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? '';
    final name = email.split('@').first;
    setState(() {
      username =
          name.isNotEmpty
              ? name[0].toUpperCase() + name.substring(1)
              : 'Invitado';
    });
  }

  Future<void> _loadProducts() async {
    try {
      final fetched = await _productService.fetchProducts();
      setState(() {
        _products = fetched;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar productos: $e')));
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final cartService = CartService();
    await cartService.borrarCarrito(); // 👈 Esto es clave

    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos  [Bienvenido $username]'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset('lib/assets/icon.png', height: 32),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return ProductCard(product: product);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    PrimaryButton(
                      text: 'Ver Carrito',
                      onPressed: () => context.go('/carrito'),
                      color: Colors.green,
                    ),
                  ],
                ),
      ),
    );
  }
}
