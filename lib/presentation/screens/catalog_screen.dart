import 'package:flutter/material.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {'title': 'Libro de Arquitectura', 'price': 'S/ 45.00'},
      {'title': 'Arte y Diseño Moderno', 'price': 'S/ 60.00'},
      {'title': 'Historia del Perú', 'price': 'S/ 30.00'},
      {'title': 'Cómic Ilustrado', 'price': 'S/ 25.00'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.book, color: Color(0xFF215EAB)),
              title: Text(product['title']!),
              subtitle: Text(product['price']!),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // Aquí podrías añadir lógica para agregar al carrito
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
