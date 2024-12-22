class MealPlan {
  final String id;
  final String name;
  final String timestamp;
  final String status;
  final String foodId;
  final String userId;

  MealPlan({
    required this.id,
    required this.name,
    required this.timestamp,
    required this.status,
    required this.foodId,
    required this.userId,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      timestamp: json['timestamp'],
      status: json['status'],
      foodId: json['FoodId'],
      userId: json['UserId'],
    );
  }

}
