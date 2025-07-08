// lib/presentation/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paycar_app/services/cart_service.dart';
import '../widgets/cart_product_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, dynamic> _detalle = {};
  double _total = 0.0;
  bool _loading = true;

  final _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _loadCarrito();
  }

  Future<void> _loadCarrito() async {
    final compra = await _cartService.obtenerCarritoTemporal();
    setState(() {
      _detalle = compra['detalleCompra'] ?? {};
      _total = (compra['totalCompra'] ?? 0).toDouble();
      _loading = false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _cartService.borrarCarrito();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.store),
            tooltip: 'Seguir comprando',
            onPressed: () => context.go('/catalogo'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _detalle.isEmpty
              ? const Center(child: Text('Tu carrito está vacío'))
              : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children:
                          _detalle.entries.map((entry) {
                            return CartProductCard(
                              entry: entry,
                              onCantidadCambiada: (nuevaCantidad) async {
                                await _cartService.actualizarCantidad(
                                  entry.key,
                                  nuevaCantidad,
                                );
                                _loadCarrito();
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Total: S/ ${_total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {
                            await _cartService.finalizarCompra();
                            if (mounted) {
                              context.go('/gracias');
                            }
                          },

                          child: const Text('Procesar Compra'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
