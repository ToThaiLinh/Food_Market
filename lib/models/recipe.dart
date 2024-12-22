import 'food.dart';

class Recipe {
  int id;
  String name;
  String description;
  String htmlContent;
  Food food;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.htmlContent,
    required this.food
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        htmlContent: json['htmlContent'],
        food: Food.fromJson(json['food'])
    );
  }
}