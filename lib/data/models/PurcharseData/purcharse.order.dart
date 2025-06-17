class PurchaseOrder {
  final int stPurchase;
  final String stPurchaseDesc;
  final int qtFlagPurchase;
  final String idColour1;
  

  PurchaseOrder({
    required this.stPurchase,
    required this.stPurchaseDesc,
    required this.qtFlagPurchase,
    required this.idColour1,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      stPurchase: int.tryParse(json['ST_PURCHASE'].toString()) ?? 0,
      stPurchaseDesc: json['DS_WAREHOUSE'] ?? '',
      qtFlagPurchase: int.tryParse(json['QT_FLAG_PURCHASE'].toString()) ?? 0,
      idColour1: json['ID_COLOUR_1'] ?? '',
    );
  }
}