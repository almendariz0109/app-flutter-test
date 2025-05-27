class PendingOrder {
  final String codWareHouse;
  final String codProd;
  final String desProd;
  final String cdMu;
  final int qtPurchaseProduct;
  final int qtPurchaseOrders;
  final int idFlag;
  final String cdCoverage;
  final String curveXyz;
  final String descCurveXyzc;

  PendingOrder({
    required this.codWareHouse,
    required this.codProd,
    required this.desProd,
    required this.cdMu,
    required this.qtPurchaseProduct,
    required this.qtPurchaseOrders,
    required this.idFlag,
    required this.cdCoverage,
    required this.curveXyz,
    required this.descCurveXyzc,
  });

  factory PendingOrder.fromJson(Map<String, dynamic> json) {
    return PendingOrder(
      codWareHouse: json['CD_WAREHOUSE_GROUP_LABEL'] ?? '',
      codProd: json['COD_ITEM_PK'] ?? '',
      desProd: json['DS_PRODUCT'] ?? '',
      cdMu: json['CD_MU'] ?? '',
      qtPurchaseProduct: json['QT_PURCHASE_PRODUCT'],
      qtPurchaseOrders: json['QT_PURCHASE_ORDERS'],
      idFlag: json['ID_FLAG'],
      cdCoverage: json['CD_COVERAGE'],
      curveXyz: json['CURVE_XYZ'] ?? '',
      descCurveXyzc: json['DESC_CURVE_XYZC'] ?? '',
    );
  }
}
