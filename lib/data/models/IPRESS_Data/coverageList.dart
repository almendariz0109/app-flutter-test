class WarehouseCoverageList {
  final String cdWarehouseGroupLabel;
  final String dsEstab;
  final int qtWarehouseStock;
  final String bgColor;
  final String color;

  WarehouseCoverageList({
    required this.cdWarehouseGroupLabel,
    required this.dsEstab,
    required this.qtWarehouseStock,
    required this.bgColor,
    required this.color,
  });

  factory WarehouseCoverageList.fromJson(Map<String, dynamic> json) {
    return WarehouseCoverageList(
      cdWarehouseGroupLabel: json['CD_WAREHOUSE_GROUP_LABEL'] ?? '',
      dsEstab: json['DS_ESTAB'] ?? '',
      qtWarehouseStock: (json['QT_WAREHOUSE_STOCK'] != null)
          ? int.tryParse(json['QT_WAREHOUSE_STOCK'].toString()) ?? 0
          : (json['totalStock'] != null)
              ? int.tryParse(json['totalStock'].toString()) ?? 0
              : 0,
      bgColor: json['BGCOLOR'] ?? '',
      color: json['COLOR'] ?? '',
    );
  }
}
