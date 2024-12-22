class Fridge {
  String id;
  String expiredDate;
  int quantity;
  String note;
  String startDate;
  String foodId;
  String userId;

  Fridge(
      {required this.id,
      required this.expiredDate,
      required this.quantity,
      required this.note,
      required this.startDate,
      required this.foodId,
      required this.userId});

  factory Fridge.fromJson(Map<String, dynamic> json) {
    return Fridge(
      id: json['id'],
      expiredDate: json['expiredDate'],
      quantity: json['quantity'],
      note: json['note'],
      startDate: json['startDate'],
      foodId: json['FooId'],
      userId: json['UserId']
    );
  }
}
