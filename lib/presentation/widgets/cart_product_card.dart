// lib/presentation/widgets/cart_product_card.dart
import 'package:flutter/material.dart';
import 'package:paycar_app/services/product_service.dart';
import 'package:paycar_app/services/cart_service.dart';

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
  final _cartService = CartService();

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

  void _eliminarProducto() async {
    await _cartService.eliminarProducto(widget.entry.key);
    // Llamamos a setState en el padre para que se recargue
    if (mounted) {
      widget.onCantidadCambiada(-1); // Señal para que recargue
    }
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
      child: SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Imagen del producto
              imagen.isNotEmpty
                  ? Image.network(
                    imagen,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                  : const Icon(Icons.image_not_supported, size: 100),

              const SizedBox(width: 12),

              // Contenido de texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    Text(
                      nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Precios
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('P/U: S/ ${precio.toStringAsFixed(2)}'),
                        Text('Total: S/ ${total.toStringAsFixed(2)}'),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Controles de cantidad y eliminar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: _eliminarProducto,
                          tooltip: 'Eliminar',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
