import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/supplying.warehouse.dart';
import '../../data/models/warehouse.coverage.dart';

class WareHouseService {
  final String baseUrl = 'http://localhost:3000/api'; // Emulador Web Local
  //final String baseUrl = 'http://192.168.8.172:3000/api'; // Emulador Android

  Future<List<WarehouseCoverage>> fetchWarehouseCoverage() async {
    final uri = Uri.parse('$baseUrl/warehouseCoverage');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'];

      return results.map((json) => WarehouseCoverage.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los datos');
    }
  }

  Future<List<WarehouseCoverage>> fetchCoverageByProduct({String? idGroup}) async {
    final uri = Uri.parse('$baseUrl/warehouseCoverage/coverageByProduct')
            .replace(queryParameters: {
              'idGroup': idGroup,
        });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'];
      return results.map((json) => WarehouseCoverage.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar cobertura');
    }
  }

  Future<List<SupplyingWarehouse>> fetchSupplyingWarehouse({String? idFlag}) async {
    final uri = Uri.parse('$baseUrl/warehouseCoverage/supplyingWarehouse')
            .replace(queryParameters: {
          'idFlag': idFlag,
        });
  
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'];
      
      return results.map((json) => SupplyingWarehouse.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los almacenes suministradores');
    }
  }

  Future<List<SupplyingWarehouse>>  fetchSupplyingWarehousexTypeProduct({String? idGroup, String? idFlag}) async {
    final uri = Uri.parse('$baseUrl/warehouseCoverage/supplyingWarehouseByProduct')
        .replace(queryParameters: {
          'idGroup': idGroup,
          'idFlag' : idFlag
        });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'];
      return results.map((json) => SupplyingWarehouse.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar cobertura');
    }
  }

  Future<List<SupplyingWarehouse>> fetchSKUsReportsxCoverage({String? idFlag, String? cdWarehouseGroupLabel}) async {
    final url = Uri.parse('$baseUrl/warehouseCoverage/SKUsReportsByCoverage')
        .replace(queryParameters: {
          'idFlag': idFlag,
          'cdWarehouseGroupLabel': cdWarehouseGroupLabel,
        });
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'];
      return results.map((json) => SupplyingWarehouse.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar el reporte');
    }
  }
}
