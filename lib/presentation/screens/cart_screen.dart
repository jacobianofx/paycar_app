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
  final _cartService = CartService();
  Map<String, dynamic> _detalle = {};
  double _total = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCarrito();
  }

  Future<void> _loadCarrito() async {
    final compra = await _cartService.obtenerCarritoTemporal();
    final rawDetalle = compra['detalleCompra'];
    final detalle =
        rawDetalle != null
            ? Map<String, dynamic>.from(rawDetalle)
            : <String, dynamic>{};

    double total = 0.0;

    for (final entry in detalle.entries) {
      final codigo = entry.key;
      final cantidad = entry.value['cantidad'] ?? 0;

      final producto = await _cartService.getProductoPorCodigo(codigo);
      final precio = double.tryParse('${producto['precio'] ?? 0}') ?? 0.0;

      total += cantidad * precio;
    }

    setState(() {
      _detalle = detalle;
      _total = total;
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
                              key: ValueKey(entry.key),
                              entry: entry,
                              onCantidadCambiada: (nuevaCantidad) async {
                                if (nuevaCantidad == -1) {
                                  await _loadCarrito();
                                } else {
                                  await _cartService.actualizarCantidad(
                                    entry.key,
                                    nuevaCantidad,
                                  );
                                  await _loadCarrito();
                                }

                                // 🔁 Verifica si ya no hay productos y redirige
                                if (_detalle.isEmpty && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Carrito vacío. Redirigiendo al catálogo...',
                                      ),
                                    ),
                                  );
                                  await Future.delayed(
                                    const Duration(milliseconds: 800),
                                  );
                                  context.go('/catalogo');
                                }
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
                            if (mounted) context.go('/gracias');
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
