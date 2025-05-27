import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/pendingorder.dart';

class PendingOrderService {
  //final String baseUrl = 'http://localhost:3000/api'; // Emulador Web Local
  final String baseUrl = 'http://192.168.8.172:3000/api'; // Emulador Android

  Future<List<PendingOrder>> fetchPendingOrder() async {
    final uri = Uri.parse('$baseUrl/pendingOrder');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'];

      return results.map((json) => PendingOrder.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener sugerencias');
    }
  }
}
