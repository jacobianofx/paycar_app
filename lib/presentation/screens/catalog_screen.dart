import 'package:flutter/material.dart';
import 'package:paycar_app/presentation/screens/shopping';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final List<Map<String, String>> cart = [];
  final List<Map<String, String>> products = [
    {'title': 'Libro de Arquitectura', 'price': 'S/ 45.00'},
    {'title': 'Arte y Diseño Moderno', 'price': 'S/ 60.00'},
    {'title': 'Historia del Perú', 'price': 'S/ 30.00'},
    {'title': 'Cómic Ilustrado', 'price': 'S/ 25.00'},
  ];
  void addtocart(Map<String, String> product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${product['title']}" agregando al carrito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarShop(carts: cart)),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
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
                onPressed: () => addtocart(product),

                // Aquí podrías añadir lógica para agregar al carrito
              ),
            ),
          );
        },
      ),
    );
  }
}
