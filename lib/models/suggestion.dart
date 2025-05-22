class Suggestion {
  final String codProd;
  final String desProd;
  final String cdMu;
  final String curveXyz;
  final String descCurveXyz;
  final int qtSuggesEnd;
  final int qtMonth;

  Suggestion({
    required this.codProd,
    required this.desProd,
    required this.cdMu,
    required this.curveXyz,
    required this.descCurveXyz,
    required this.qtSuggesEnd,
    required this.qtMonth,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      codProd: json['COD_ITEM_PK'] ?? '',
      desProd: json['DS_PRODUCT'] ?? '',
      cdMu: json['CD_MU'] ?? '',
      curveXyz: json['CURVE_XYZ'] ?? '',
      descCurveXyz: json['DESC_CURVE_XYZ'] ?? '',
      qtSuggesEnd: json['QT_SUGGESTION_END'] ?? 0,
      qtMonth: json['QT_MONTH'] ?? 0,
    );
  }
}
