class FridgeItem {
  String id;
  String itemName;
  String expiredDate;
  int quantity;
  String note;
  String startDate;
  String foodId;
  String userId;

  FridgeItem(
      {required this.id,
        required this.itemName,
        required this.expiredDate,
        required this.quantity,
        required this.note,
        required this.startDate,
        required this.foodId,
        required this.userId});

  factory FridgeItem.fromJson(Map<String, dynamic> json) {
    return FridgeItem(
        id: json['_id'] ?? "",
        itemName: json['itemName'] ?? "",
        expiredDate: json['expiredDate'] ?? "",
        quantity: json['quantity'] ?? "",
        note: json['note'] ?? "",
        startDate: json['startDate'] ?? "",
        foodId: json['fooId'] ?? "",
        userId: json['userId'] ?? ""
    );
  }
}