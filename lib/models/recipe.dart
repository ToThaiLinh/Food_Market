class Recipe {
  String id;
  String name;
  String description;
  String htmlContent;
  String foodId;

  Recipe(
      {required this.id,
      required this.name,
      required this.description,
      required this.htmlContent,
      required this.foodId});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        htmlContent: json['htmlContent'],
        foodId: json['foodId']);
  }
}
