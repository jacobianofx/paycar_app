// lib/presentation/widgets/cart_product_card.dart
import 'package:flutter/material.dart';
import 'package:paycar_app/services/product_service.dart';

class CartProductCard extends StatefulWidget {
  final MapEntry<String, dynamic> entry;
  final Function(int) onCantidadCambiada;

  const CartProductCard({
    super.key,
    required this.entry,
    required this.onCantidadCambiada,
  });

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  final _productService = ProductService();
  Map<String, dynamic> _producto = {};
  bool _loading = true;
  int _cantidad = 1;

  @override
  void initState() {
    super.initState();
    _cantidad = widget.entry.value['cantidad'] ?? 1;
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final data = await _productService.getProductoPorCodigo(widget.entry.key);
    print('Producto cargado: $data');
    setState(() {
      _producto = data;
      _loading = false;
    });
  }

  void _cambiarCantidad(int nuevaCantidad) {
    if (nuevaCantidad < 1) return;
    setState(() => _cantidad = nuevaCantidad);
    widget.onCantidadCambiada(nuevaCantidad);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final nombre = _producto['nombre'] ?? 'Producto';
    final precio = double.tryParse('${_producto['precio'] ?? 0}') ?? 0.0;
    final imagen = _producto['imagen'] ?? '';
    final total = precio * _cantidad;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Precio: S/ ${precio.toStringAsFixed(2)}'),
                  Text('Total: S/ ${total.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _cambiarCantidad(_cantidad - 1),
                      ),
                      Text('$_cantidad'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _cambiarCantidad(_cantidad + 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
