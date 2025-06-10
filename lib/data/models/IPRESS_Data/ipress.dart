class IPRESSStockData {
  final String cdWarehouseGroupLabel;
  final String dsEstab;
  final int qtWarehouseStock;
  final int totalStock;

  IPRESSStockData({
    required this.cdWarehouseGroupLabel,
    required this.dsEstab,
    required this.qtWarehouseStock,
    required this.totalStock,
  });

  factory IPRESSStockData.fromJson(Map<String, dynamic> json) {
    return IPRESSStockData(
      cdWarehouseGroupLabel: json['CD_WAREHOUSE_GROUP_LABEL']?.toString() ?? '',
      dsEstab: json['DS_ESTAB']?.toString() ?? '',
      qtWarehouseStock: int.tryParse(json['QT_WAREHOUSE_STOCK']?.toString() ?? '0') ?? 0,
      totalStock: int.tryParse(json['totalStock']?.toString() ?? '0') ?? 0,
    );
  }
}

