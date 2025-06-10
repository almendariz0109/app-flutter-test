class IPRESSDetails {
  final int idFlag;
  final String cdWarehouse;
  final String dsWarehouse;
  final int qtFlagStock;
  final String idColour1;
  final String idColour2;
  final int qtWarehouseStock;

  IPRESSDetails({
    required this.idFlag,
    required this.cdWarehouse,
    required this.dsWarehouse,
    required this.qtFlagStock,
    required this.idColour1,
    required this.idColour2,
    required this.qtWarehouseStock
  });

  factory IPRESSDetails.fromJson(Map<String, dynamic> json) {
    return IPRESSDetails(
      idFlag: int.tryParse(json['ID_FLAG'].toString()) ?? 0,
      cdWarehouse: json['CD_WAREHOUSE'] ?? '',
      dsWarehouse: json['DS_WAREHOUSE'] ?? '',
      qtFlagStock: int.tryParse(json['QT_FLAG_STOCK'].toString()) ?? 0,
      idColour1: json['ID_COLOUR_1'] ?? '',
      idColour2: json['ID_COLOUR_2'] ?? '',
      qtWarehouseStock: int.tryParse(json['QT_WAREHOUSE_STOCK'].toString()) ?? 0,
    );
  }
}