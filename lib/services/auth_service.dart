import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

// Cambia la IP según tu entorno
const String baseUrl = 'http://10.0.2.2:3000/api'; // Emulador Android
const String baseUrl2 = 'http://localhost:3000/api';

class AuthService {
  Future<User?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl2/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('login', data['user']['id']);
        return User.fromJson(data['user']);
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Error al conectar con el servidor');
    }
  }

  Future<void> saveLoginSession(String login) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', login);
  }
}
