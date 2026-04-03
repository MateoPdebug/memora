import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<Map<String, dynamic>> registrarUsuario({
    required String idUsuario,
    required String nombre,
    required String correo,
    required String contrasena,
  }) async {
    final url = Uri.parse('$baseUrl/usuarios');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id_usuario": idUsuario,
        "nombre": nombre,
        "correo": correo,
        "contrasena": contrasena,
      }),
    );

    print("STATUS REGISTRO: ${response.statusCode}");
    print("BODY REGISTRO: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        "ok": true,
        "message": "Usuario registrado correctamente"
      };
    } else {
      String mensaje = "Error al registrar usuario";

      try {
        final data = jsonDecode(response.body);
        if (data["detail"] != null) {
          mensaje = data["detail"];
        }
      } catch (_) {}

      return {
        "ok": false,
        "message": mensaje
      };
    }
  }

  static Future<bool> loginUsuario({
    required String correo,
    required String contrasena,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "correo": correo,
        "contrasena": contrasena,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Error login: ${response.body}");
      return false;
    }
  }
}

