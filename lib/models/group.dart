import 'package:food/models/user.dart';

class Group {
  String? id;
  String? name;
  User? admin;
  List<User>? members;

  Group({this.id, this.name, this.admin, this.members});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'],
      name: json['name'],
      admin: User.fromJson(json['groupAdmin']) ?? User(),
      members: (json['members'] as List)
          .map((item) => User.fromJson(item))
          .toList() ?? []
    );
  }

}
