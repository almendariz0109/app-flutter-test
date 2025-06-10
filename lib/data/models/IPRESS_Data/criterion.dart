class CoverageCriterion {
  final int idFlag;
  final int idGroup;
  final String cdCoverage;
  final String dsCoverage;
  final int qtFlagStock;
  final String idColour1;
  final String idColour2;

  CoverageCriterion({
    required this.idFlag,
    required this.idGroup,
    required this.cdCoverage,
    required this.dsCoverage,
    required this.qtFlagStock,
    required this.idColour1,
    required this.idColour2,
  });

  factory CoverageCriterion.fromJson(Map<String, dynamic> json) {
    return CoverageCriterion(
      idFlag: int.tryParse(json['ID_FLAG'].toString()) ?? 0,
      idGroup: json['ID_GROUP'] ?? 0,
      cdCoverage: json['CD_COVERAGE'] ?? '',
      dsCoverage: json['DS_COVERAGE'] ?? '',
      qtFlagStock: int.tryParse(json['QT_FLAG_STOCK'].toString()) ?? 0,
      idColour1: json['ID_COLOUR_1'] ?? '',
      idColour2: json['ID_COLOUR_2'] ?? '',
    );
  }
}