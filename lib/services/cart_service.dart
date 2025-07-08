import 'package:dio/dio.dart';

class CartService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://certus-2e723-default-rtdb.firebaseio.com';

  final String cartKey = 'compra_temporal'; // Clave local para 1 carrito

  Future<void> agregarProducto(String codigo, double precio) async {
    final cartUrl = '$baseUrl/compras/$cartKey.json';

    final response = await _dio.get(cartUrl);
    Map<String, dynamic> compra = response.data ?? {};

    double total = (compra['totalCompra'] ?? 0.0) + precio;

    Map<String, dynamic> detalle = Map<String, dynamic>.from(
      compra['detalleCompra'] ?? {},
    );

    if (detalle.containsKey(codigo)) {
      detalle[codigo]['cantidad'] += 1;
    } else {
      detalle[codigo] = {'codigoProducto': codigo, 'cantidad': 1};
    }

    final dataActualizada = {
      'numeroCompra':
          compra['numeroCompra'] ?? DateTime.now().millisecondsSinceEpoch,
      'totalCompra': total,
      'detalleCompra': detalle,
    };

    await _dio.put(cartUrl, data: dataActualizada);
  }

  Future<void> borrarCarrito() async {
    final cartUrl = '$baseUrl/compras/$cartKey.json';
    await _dio.delete(cartUrl);
  }
}
