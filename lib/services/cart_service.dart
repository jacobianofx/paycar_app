import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> finalizarCompra() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? 'desconocido';

    final compra = await obtenerCarritoTemporal();
    if (compra.isEmpty) return;

    // Clona el detalle y agrega precio real a cada ítem
    final Map<String, dynamic> detalle = Map<String, dynamic>.from(
      compra['detalleCompra'],
    );
    final updatedDetalle = <String, dynamic>{};

    for (final codigo in detalle.keys) {
      final producto = await getProductoDesdeCatalogo(codigo);
      updatedDetalle[codigo] = {
        'cantidad': detalle[codigo]['cantidad'],
        'precio_unitario': producto['precio'] ?? 0,
        'nombre': producto['nombre'] ?? '',
      };
    }

    final compraFinal = {
      'usuario': email,
      'fecha': DateTime.now().toIso8601String(),
      'detalleCompra': updatedDetalle,
      'totalCompra': compra['totalCompra'],
    };

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _dio.put(
      '$baseUrl/compras_finalizadas/$timestamp.json',
      data: compraFinal,
    );

    await borrarCarrito();
  }

  Future<Map<String, dynamic>> getProductoDesdeCatalogo(String codigo) async {
    final response = await _dio.get('$baseUrl/producto/$codigo.json');
    if (response.statusCode == 200 && response.data != null) {
      return Map<String, dynamic>.from(response.data);
    }
    return {};
  }

  Future<void> eliminarProducto(String codigoProducto) async {
    final carrito = await obtenerCarritoTemporal();
    carrito['detalleCompra']?.remove(codigoProducto);

    final detalle = carrito['detalleCompra'] ?? {};
    double nuevoTotal = 0.0;

    for (var entry in detalle.entries) {
      final producto = await getProductoPorCodigo(entry.key);
      final precio = double.tryParse('${producto['precio']}') ?? 0.0;
      final cantidad = entry.value['cantidad'] ?? 1;
      nuevoTotal += precio * cantidad;
    }

    carrito['totalCompra'] = nuevoTotal;
    await _guardarCarrito(carrito);
  }

  Future<void> _guardarCarrito(Map<String, dynamic> carrito) async {
    await _dio.put('$baseUrl/compras/compra_temporal.json', data: carrito);
  }
}
