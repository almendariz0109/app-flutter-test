import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/models/PurcharseData/coverage.criteria.dart';
import '../../data/models/PurcharseData/purcharse.order.dart';
import '../../data/models/PurcharseData/supplying.warehouse.dart';
import '../../data/models/detail.suggestion.dart';

class PurchaseOrdersConditionService {
  //final String baseUrl = 'http://localhost:3000/api'; // Cambia si usas Android
  final String baseUrl = 'http://192.168.8.193:8080/api';

  Future<Map<String, dynamic>> fetchDashboardData({String? idGroup, String? idFlag }) async {
    final uri = Uri.parse('$baseUrl/purcharse/purcharseCondition').replace(queryParameters: {
      if (idFlag != null) 'idFlag': idFlag,
      if (idGroup != null) 'idGroup': idGroup,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final data = jsonBody['data'];

      final coverageCriteria = (data['coverageCriteria'] as List? ?? [])
          .map((e) => CoverageCriteria.fromJson(e))
          .toList();

      final purchaseOrder = (data['purchaseOrder'] as List? ?? [])
          .map((e) => PurchaseOrder.fromJson(e))
          .toList();

      final supplyingWarehouse = (data['supplyingWarehouse'] as List? ?? [])
          .map((e) => SupplyingWarehousePurchase.fromJson(e))
          .toList();
      
      return {
        'coverageCriteria': coverageCriteria,
        'purchaseOrder': purchaseOrder,
        'supplyingWarehouse': supplyingWarehouse, 

      };
    } else {
      throw Exception('Error al obtener los datos del dashboard');
    }
  }

  Future<List<SuggestionDetail>> fetchSKUsReportsxCoverage({required String stPurcharse, required String cdWarehouseGroupLabel, String? curve, String? idFlag, String? idGroup}) async {
    final url = Uri.parse('$baseUrl/purcharse/purcharseCondition/purcharseSKUsReport')
        .replace(queryParameters: {
          'stPurcharse': stPurcharse,
          'cdWarehouseGroupLabel': cdWarehouseGroupLabel,
      if (curve != null && curve != '0') 'curve': curve,
      if (idFlag != null && idFlag != '0') 'idFlag': idFlag,
      if (idGroup != null && idGroup != '0') 'idGroup': idGroup,
    });

    final response = await http.get(url);

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'];
      return results.map((json) => SuggestionDetail.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar el reporte');
    }
    
  }

}