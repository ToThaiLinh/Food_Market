class Unit {
  int id;
  String unitName;

  Unit({required this.id, required this.unitName});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
        id: json['id'],
        unitName: json['unitName']
    );
  }

}