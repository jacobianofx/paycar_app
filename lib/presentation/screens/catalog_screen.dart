import 'package:flutter/material.dart';
import 'package:paycar_app/presentation/screens/shopping';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        'title': 'Cartulina Opalina A4 180 Gr. x 25 Hojas',
        'price': 'S/9.00',
        'image': 'lib/assets/opalina.png',
      },
      {
        'title': 'Block cartulina de colores arcoíris A4 x 20 hojas Justus',
        'price': 'S/9.00',
        'image': 'lib/assets/arcoiris.png',
      },
    ];
=======
  State<CatalogScreen> createState() => _CatalogScreenState();
}
>>>>>>> bebb7ec6fc219a090531f26a406f43811874d911

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
<<<<<<< HEAD
        title: const Text(
          'Productos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('lib/assets/icon.png', height: 32),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Busqueda',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            product['image']!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product['price']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[100],
                                        foregroundColor: Colors.green[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: const Text('Agrega al Carrito'),
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
                },
=======
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
>>>>>>> bebb7ec6fc219a090531f26a406f43811874d911
              ),
            ),
          ],
        ),
      ),
    );
  }
}
