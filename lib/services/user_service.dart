import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  final String baseUrl = 'http://localhost:3000/api'; // reemplaza con tu IP

  Future<User?> fetchUserDetails(String login) async {
    print("Obteniendo datos del perfil para login: $login");
    final response = await http.get(Uri.parse('$baseUrl/user-details?login=$login'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      return null;
    }
  }
}
