// lib/services/product_service.dart
import 'package:dio/dio.dart';

class ProductService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://certus-2e723-default-rtdb.firebaseio.com';

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await _dio.get('$baseUrl/producto.json');

    if (response.data == null) return [];

    final List<Map<String, dynamic>> productos = [];

    response.data.forEach((key, value) {
      productos.add({
        'codigo': key,
        'nombre': value['nombre'] ?? 'Producto sin nombre',
        'precio': (value['precio'] as num).toDouble(),
        'imagen': value['imagen'] ?? '',
      });
    });

    return productos;
  }
}
