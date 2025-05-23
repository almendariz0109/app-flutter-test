class Suggestion {
  final String codProd;
  final String desProd;
  final String cdMu;
  final String curveXyz;
  final String descCurveXyz;
  final String qtSuggesEnd0501;
  final String qtSuggesEnd0599;
  final String qtSuggesEnd0601;
  final String qtSuggesEnd0699;
  final String qtSuggesEnd0701;
  final String qtSuggesEnd0799;
  final String qtSuggesEnd9201;
  final String qtSuggesEnd9501;
  final String qtSuggesEnd9907;
  final int qtSuggesEnd;
  final int qtMonth;

  Suggestion({
    required this.codProd,
    required this.desProd,
    required this.cdMu,
    required this.curveXyz,
    required this.descCurveXyz,
    required this.qtSuggesEnd0501,
    required this.qtSuggesEnd0599,
    required this.qtSuggesEnd0601,
    required this.qtSuggesEnd0699,
    required this.qtSuggesEnd0701,
    required this.qtSuggesEnd0799,
    required this.qtSuggesEnd9201,
    required this.qtSuggesEnd9501,
    required this.qtSuggesEnd9907,
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
      qtSuggesEnd0501: json['QT_SUGGESTION_END_0501'] ?? '',
      qtSuggesEnd0599: json['QT_SUGGESTION_END_0599'] ?? '',
      qtSuggesEnd0601: json['QT_SUGGESTION_END_0601'] ?? '',
      qtSuggesEnd0699: json['QT_SUGGESTION_END_0699'] ?? '',
      qtSuggesEnd0701: json['QT_SUGGESTION_END_0701'] ?? '',
      qtSuggesEnd0799: json['QT_SUGGESTION_END_0799'] ?? '',
      qtSuggesEnd9201: json['QT_SUGGESTION_END_9201'] ?? '',
      qtSuggesEnd9501: json['QT_SUGGESTION_END_9501'] ?? '',
      qtSuggesEnd9907: json['QT_SUGGESTION_END_9907'] ?? '',
      qtSuggesEnd: json['QT_SUGGESTION_END'] ?? 0,
      qtMonth: json['QT_MONTH'] ?? 0,
    );
  }
}
