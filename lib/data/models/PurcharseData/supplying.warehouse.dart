class SupplyingWarehousePurchase {
  final String cdWarehouseGroupLabel;
  final String dsWarehouse;
  final int idFlag;
  final int qtFlagPurchase0;
  final String idColour1;
  final String idColour2;
  final int qtWarehouseStock;
  final int qtFlagPurchase;
  final int qtFlagPurchase1;
  final int idGroup;

  SupplyingWarehousePurchase({
    required this.cdWarehouseGroupLabel,
    required this.dsWarehouse,
    required this.idFlag,
    required this.qtFlagPurchase0,
    required this.idColour1,
    required this.idColour2,
    required this.qtWarehouseStock,
    required this.qtFlagPurchase,
    required this.qtFlagPurchase1,
    required this.idGroup,
  });

  factory SupplyingWarehousePurchase.fromJson(Map<String, dynamic> json) {
    return SupplyingWarehousePurchase(
      cdWarehouseGroupLabel: json['CD_WAREHOUSE_GROUP_LABEL'] ?? '',
      dsWarehouse: json['DS_WAREHOUSE'] ?? '',
      idFlag: int.tryParse(json['ID_FLAG'].toString()) ?? 0,
      qtFlagPurchase0: int.tryParse(json['QT_FLAG_PURCHASE_0'].toString()) ?? 0,
      idColour1: json['ID_COLOUR_1'] ?? '',
      idColour2: json['ID_COLOUR_2'] ?? '',
      qtWarehouseStock: int.tryParse(json['QT_WAREHOUSE_STOCK'].toString()) ?? 0,
      qtFlagPurchase: int.tryParse(json['QT_FLAG_PURCHASE'].toString()) ?? 0,
      qtFlagPurchase1: int.tryParse(json['QT_FLAG_PURCHASE_1'].toString()) ?? 0,
      idGroup: int.tryParse(json['ID_GROUP'].toString()) ?? 0,
    );
  }
}