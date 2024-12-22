class Food {
  String id;
  String name;
  int quantity;
  //String imageUrl;
  String unit;
  String category;

  Food({
    required this.id,
    required this.name,
    required this.quantity,
    //required this.imageUrl,
    required this.unit,
    required this.category,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
        id: json['_id'] ?? "",
        name: json['name'] ?? "",
        quantity: json['quantity'] ?? 0,
        // imageUrl: json['imageUrl'],
        unit: json['unit'] ?? "",
        category: json['category'] ?? "",
    );
  }

}