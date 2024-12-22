class Food {
  int id;
  String name;
  //String imageUrl;
  String unit;
  String category;
  String userIdCreate;

  Food({
    required this.id,
    required this.name,
    //required this.imageUrl,
    required this.unit,
    required this.category,
    required this.userIdCreate,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
        id: json['id'],
        name: json['name'],
        // imageUrl: json['imageUrl'],
        unit: json['unit'],
        category: json['category'],
        userIdCreate: json['userIdCreate']
    );
  }

}