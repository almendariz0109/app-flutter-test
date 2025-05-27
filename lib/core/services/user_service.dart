import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/user.dart';

class UserService {
  //final String baseUrl = 'http://localhost:3000/api'; // Emulador Web Local
  final String baseUrl = 'http://192.168.8.172:3000/api'; // Emulador Android

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
