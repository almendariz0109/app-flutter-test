import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/suggestion.dart';

class AlertService {
  final String baseUrl = 'http://localhost:3000/api'; // Emulador Web

  Future<List<Suggestion>> fetchSuggestions({
    required String months,
    required String product,
    String curve = '',
  }) async {
    final uri = Uri.parse('$baseUrl/alerts')
        .replace(queryParameters: {
          'months': months,
          'product': product,
          if (curve.isNotEmpty) 'curve': curve,
        });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'];

      return results.map((json) => Suggestion.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener sugerencias');
    }
  }
}
