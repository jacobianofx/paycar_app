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

  Future<Map<String, dynamic>> obtenerCarritoTemporal() async {
    final response = await _dio.get('$baseUrl/compras/$cartKey.json');

    if (response.data != null) {
      return Map<String, dynamic>.from(response.data);
    }
    return {};
  }

  Future<void> actualizarCantidad(
    String codigoProducto,
    int nuevaCantidad,
  ) async {
    final url =
        '$baseUrl/compras/compra_temporal/detalleCompra/$codigoProducto/cantidad.json';

    await _dio.put(url, data: nuevaCantidad);

    // Recalcular total
    final carrito = await obtenerCarritoTemporal();
    double nuevoTotal = 0.0;

    if (carrito.containsKey('detalleCompra')) {
      final productos = carrito['detalleCompra'] as Map<String, dynamic>;
      for (var entry in productos.entries) {
        final producto = await getProductoPorCodigo(entry.key);

        final precio = (producto['precio'] ?? 0).toDouble();
        final cantidad = (entry.value['cantidad'] ?? 0).toDouble();
        nuevoTotal += precio * cantidad;
      }

      await _dio.put(
        '$baseUrl/compras/compra_temporal/totalCompra.json',
        data: nuevoTotal,
      );
    }
  }

  Future<Map<String, dynamic>> getProductoPorCodigo(String codigo) async {
    final response = await _dio.get('$baseUrl/producto/$codigo.json');
    if (response.statusCode == 200 && response.data != null) {
      return Map<String, dynamic>.from(response.data);
    }
    return {};
  }
}
