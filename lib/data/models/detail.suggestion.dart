class SuggestionDetail {
  final String codProd;
  final String desProd;
  final String cdPurchaseOrderAsc;
  final String dtEndAsc;
  final int idGroup;
  final String desCdGroup;
  final String cdGroupAsc;
  final int idFlag;
  final String cdCoverage;
  final String cdWarehouseGroupLabel;
  final int stPurchase;
  final String curveXyz;
  final String descCurveXyz;
  final String descStPurchase;
  final String cdMu;
  final int qtPurchaseProduct;
  final int qtSuggestionEnd;
  final int qtPurchaseOrders;

  SuggestionDetail({
    required this.codProd,
    required this.desProd,
    required this.cdPurchaseOrderAsc,
    required this.dtEndAsc,
    required this.idGroup,
    required this.desCdGroup,
    required this.cdGroupAsc,
    required this.idFlag,
    required this.cdCoverage,
    required this.cdWarehouseGroupLabel,
    required this.stPurchase,
    required this.curveXyz,
    required this.descCurveXyz,
    required this.descStPurchase,
    required this.cdMu,
    required this.qtPurchaseProduct,
    required this.qtSuggestionEnd,
    required this.qtPurchaseOrders,
  });

  factory SuggestionDetail.fromJson(Map<String, dynamic> json) {
    return SuggestionDetail(
      codProd: json['COD_ITEM_PK'] ?? '',
      desProd: json['DS_PRODUCT'] ?? '',
      cdPurchaseOrderAsc: json['CD_PURCHASE_ORDER_ASC'] ?? '',
      dtEndAsc: json['DT_END_ASC'] ?? '',
      idGroup: int.tryParse(json['ID_GROUP'].toString()) ?? 0,
      desCdGroup: json['DESC_CD_GROUP'] ?? '',
      cdGroupAsc: json['CD_GROUP_ASC'] ?? '',
      idFlag: int.tryParse(json['ID_FLAG'].toString()) ?? 0,
      cdCoverage: json['CD_COVERAGE'] ?? '',
      cdWarehouseGroupLabel: json['CD_WAREHOUSE_GROUP_LABEL'] ?? '',
      stPurchase: int.tryParse(json['ST_PURCHASE'].toString()) ?? 0,
      curveXyz: json['CURVE_XYZ'] ?? '',
      descCurveXyz: json['DESC_CURVE_XYZC'] ?? '',
      descStPurchase: json['DESC_ST_PURCHASE'] ?? '',
      cdMu: json['CD_MU'] ?? '',
      qtPurchaseProduct: int.tryParse(json['QT_PURCHASE_PRODUCT'].toString()) ?? 0,
      qtSuggestionEnd: int.tryParse(json['QT_SUGGESTION_END'].toString()) ?? 0,
      qtPurchaseOrders: int.tryParse(json['QT_PURCHASE_ORDERS'].toString()) ?? 0,
    );
  }
}
