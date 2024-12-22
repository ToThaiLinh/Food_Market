import 'food.dart';

class MealPlan {
  final String id;
  final String name;
  final String timestamp;
  final String status;
  final Food? food;
  final String userId;

  MealPlan({
    required this.id,
    required this.name,
    required this.timestamp,
    required this.status,
    this.food,
    required this.userId,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      timestamp: json['timestamp'] ?? "",
      status: json['status'] ?? "",
      food: Food.fromJson(json['foodId']) ?? null,
      userId: json['userId'] ?? "",
    );
  }

}