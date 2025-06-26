import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_login/data/models/IPRESS_Data/ipress.dart';
import '../../data/models/IPRESS_Data/coverageList.dart';
import '../../data/models/IPRESS_Data/criterion.dart';
import '../../data/models/IPRESS_Data/ipressDetails.dart';
import '../../data/models/supplying.warehouse.dart';

class SKUsCoverageIPRESSService {
  //final String baseUrl = 'http://localhost:3000/api'; // Cambia si usas Android
  final String baseUrl = 'http://192.168.8.193:8080/api';

  Future<Map<String, dynamic>> fetchDashboardData({String? cdWarehouseGroupLabel, String? idGroup }) async {
    final uri = Uri.parse('$baseUrl/skusCoverage/skusCoverageLvlIPRESS').replace(queryParameters: {
      if (cdWarehouseGroupLabel != null) 'cdWarehouseGroupLabel': cdWarehouseGroupLabel,
      if (idGroup != null) 'idGroup': idGroup,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final data = jsonBody['data'];

      final warehouseCoverage = (data['warehouseCoverage'] as List)
          .map((e) => WarehouseCoverageList.fromJson(e))
          .toList();

      final coverageCriteria = (data['coverageCriteria'] as List)
          .map((e) => CoverageCriterion.fromJson(e))
          .toList();

      final ipressStock = (data['ipressStock'] as List?)
          ?.map((e) => IPRESSStockData.fromJson(e))
          .toList() ?? [];

      return {
        'warehouseCoverage': warehouseCoverage,
        'coverageCriteria': coverageCriteria,
        'ipressStock': ipressStock, 

      };
    } else {
      throw Exception('Error al obtener los datos del dashboard');
    }
  }

  Future<Map<String, dynamic>> fetchDashboardIPRESSDetails({required String cdWarehouseGroupLabel, required String idFlag, String? idGroup}) async {
    final uri = Uri.parse('$baseUrl/skusCoverage/skusCoverageLvlIPRESS/IPRESSDetails').replace(queryParameters: {
      'idFlag': idFlag,
      'cdWarehouseGroupLabel': cdWarehouseGroupLabel,
      if (idGroup != null) 'idGroup': idGroup,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // Verificamos que sea una lista de mapas
      final List<dynamic> list = decoded['data'];

      // Convertimos cada item a IPRESSDetails
      final List<IPRESSDetails> ipressDetailsData = list.map((item) => IPRESSDetails.fromJson(item)).toList();

      return {
        'ipressDetailsData': ipressDetailsData,
      };
    } else {
      throw Exception('Error al cargar datos IPRESS');
    }
  }

    Future<List<SupplyingWarehouse>> fetchSKUsReportsxCoverage({required String idFlag, required String cdWarehouse}) async {
    final url = Uri.parse('$baseUrl/skusCoverage/skusCoverageLvlIPRESS/SKUsReportsByCoverage')
        .replace(queryParameters: {
          'idFlag': idFlag,
          'cdWarehouse': cdWarehouse,
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
