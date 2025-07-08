import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paycar_app/services/cart_service.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final formatter = NumberFormat.currency(
      locale: 'es_PE',
      symbol: 'S/',
      decimalDigits: 2,
      customPattern: '¤#,##0.00', // "¤" = símbolo, antes del número
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 190,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧾 Nombre del producto (más grande y hasta 2 líneas)
              Text(
                product['nombre'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),

              // 📸 Imagen + 💵 Precio y botón
              Expanded(
                child: Row(
                  children: [
                    // Imagen centrada total
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Image.network(
                          product['imagen'],
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const Icon(
                                Icons.image_not_supported,
                                size: 48,
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Precio y botón centrados total
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formatter.format(
                                double.tryParse(product['precio'].toString()) ??
                                    0.0,
                              ),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () async {
                                final cartService = CartService();
                                await cartService.agregarProducto(
                                  product['codigo'],
                                  product['precio'],
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Producto agregado al carrito',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Agregar al Carrito'),
                            ),
                          ],
                        ),
                      ),
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
