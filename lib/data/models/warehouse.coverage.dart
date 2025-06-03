class WarehouseCoverage {
  final int idFlag;
  final String cdCoverage;
  final String dsCoverage;
  final double qtFlagStock;
  final String idColour1;
  final String idColour2;
  final int idGroup;

  WarehouseCoverage({
    required this.idFlag,
    required this.cdCoverage,
    required this.dsCoverage,
    required this.qtFlagStock,
    required this.idColour1,
    required this.idColour2,
    required this.idGroup,
  });

  factory WarehouseCoverage.fromJson(Map<String, dynamic> json) {
    return WarehouseCoverage(
      idFlag: json['ID_FLAG'] ?? 0,
      cdCoverage: json['CD_COVERAGE'] ?? '',
      dsCoverage: json['DS_COVERAGE'] ?? '',
      qtFlagStock: double.tryParse(json['QT_FLAG_STOCK'].toString()) ?? 0,
      idColour1: json['ID_COLOUR_1'] ?? '',
      idColour2: json['ID_COLOUR_2'] ?? '',
      idGroup: json['ID_GROUP'] ?? 0,
    );
  }
}
