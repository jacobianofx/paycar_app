// lib/presentation/widgets/cart_item_card.dart
import 'package:flutter/material.dart';
import '../../../services/product_service.dart';

class CartItemCard extends StatefulWidget {
  final MapEntry<String, dynamic> entry;

  const CartItemCard({super.key, required this.entry});

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  Map<String, dynamic> _producto = {};
  final _productService = ProductService();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducto();
  }

  Future<void> _loadProducto() async {
    final data = await _productService.getProductoPorCodigo(widget.entry.key);
    if (mounted) {
      setState(() {
        _producto = data;
        _loading = false;
      });
      print('Producto cargado: $_producto');
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.entry.value;
    final cantidad = item['cantidad'] ?? 0;
    final precioU = double.tryParse('${_producto['precio'] ?? '0'}') ?? 0.0;
    final nombre = _producto['nombre'] ?? 'Producto';
    final imagen = _producto['imagen'] ?? '';
    final total = precioU * cantidad;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                  children: [
                    imagen.isNotEmpty
                        ? Image.network(
                          imagen,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.image_not_supported, size: 60),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Cantidad: $cantidad'),
                          Text('P/U: S/ ${precioU.toStringAsFixed(2)}'),
                          Text('Total: S/ ${total.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
