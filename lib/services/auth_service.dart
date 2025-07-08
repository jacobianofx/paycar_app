import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://certus-2e723-default-rtdb.firebaseio.com';

  Future<bool> login(String correo, String clave) async {
    try {
      final response = await _dio.get('$_baseUrl/usuario.json');
      final data = response.data as Map<String, dynamic>;
      for (final user in data.values) {
        if (user['email'] == correo && user['password'] == clave) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error al conectar con Firebase: $e');
      return false;
    }
  }
}
