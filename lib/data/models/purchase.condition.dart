import 'PurcharseData/coverage.criteria.dart';
import 'PurcharseData/purcharse.order.dart';
import 'PurcharseData/supplying.warehouse.dart';

class PurchaseCondition {
  final List<CoverageCriteria> coverageCriteria;
  final List<PurchaseOrder> purchaseOrder;
  final List<SupplyingWarehousePurchase> supplyingWarehouse;

  PurchaseCondition({
    required this.coverageCriteria,
    required this.purchaseOrder,
    required this.supplyingWarehouse,
  });

  factory PurchaseCondition.fromJson(Map<String, dynamic> json) {
    return PurchaseCondition(
      coverageCriteria: (json['coverageCriteria'] as List)
          .map((e) => CoverageCriteria.fromJson(e))
          .toList(),
      purchaseOrder: (json['purchaseOrder'] as List)
          .map((e) => PurchaseOrder.fromJson(e))
          .toList(),
      supplyingWarehouse: (json['supplyingWarehouse'] as List)
          .map((e) => SupplyingWarehousePurchase.fromJson(e))
          .toList(),
    );
  }
}