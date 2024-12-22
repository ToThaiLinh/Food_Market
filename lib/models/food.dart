class Food {
  int id;
  String name;
  String imageUrl;
  String type;
  int foodCategoryId;
  String foodCategory;
  int userId;
  int unitOfMeasurementId;

  Food({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.foodCategoryId,
    required this.foodCategory,
    required this.userId,
    required this.unitOfMeasurementId,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        type: json['type'],
        foodCategoryId: json['FoodCategoryId'],
        foodCategory: json['FoodCategory']['name'],
        userId: json['UserId'],
        unitOfMeasurementId: json['UnitOfMeasurementId'],
    );
  }

}