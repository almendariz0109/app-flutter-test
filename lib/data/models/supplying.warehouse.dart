class SupplyingWarehouse {
  final String cdWarehouseGroupLabel;
  final String cdWarehouse;
  final String dsWarehouse;
  final int idFlag;
  final int sumFlagStock;
  final String idColour1;
  final String idColour2;
  final int qtWarehouseStock;
  final String codItemPk;
  final String dsProduct;
  final String cdMu;
  final String cdCoverage;

  SupplyingWarehouse({
    required this.cdWarehouseGroupLabel,
    required this.cdWarehouse,
    required this.dsWarehouse,
    required this.idFlag,
    required this.sumFlagStock,
    required this.idColour1,
    required this.idColour2,
    required this.qtWarehouseStock,
    required this.codItemPk,
    required this.dsProduct,
    required this.cdMu,
    required this.cdCoverage
  });

  factory SupplyingWarehouse.fromJson(Map<String, dynamic> json) {
    return SupplyingWarehouse(
      cdWarehouseGroupLabel: json['CD_WAREHOUSE_GROUP_LABEL'] ?? '',
      cdWarehouse: json['CD_WAREHOUSE'] ?? '',
      dsWarehouse: json['DS_WAREHOUSE'] ?? '',
      idFlag: int.tryParse(json['ID_FLAG'].toString()) ?? 0,
      sumFlagStock: int.tryParse(json['QT_FLAG_STOCK'].toString()) ?? 0,
      idColour1: json['ID_COLOUR_1'] ?? '',
      idColour2: json['ID_COLOUR_2'] ?? '',
      qtWarehouseStock: int.tryParse(json['QT_WAREHOUSE_STOCK'].toString()) ?? 0,
      codItemPk: json['COD_ITEM_PK'] ?? '',
      dsProduct: json['DS_PRODUCT'] ?? '',
      cdMu: json['CD_MU'] ?? '',
      cdCoverage: json['CD_COVERAGE'] ?? ''
    );
  }
}