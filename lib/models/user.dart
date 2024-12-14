class User {
  final String id;
  final String email;
  final String password;
  final String username;
  final String name;
  final String? type;
  final String language;
  final String? gender;
  final String countryCode;
  final int timezone;
  final String? birthDate;
  final String photoUrl;
  final bool isActivated;
  final bool? isVerified;
  final String? deviceId;
  final int belongsToGroupAdminId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.username,
    required this.name,
    this.type,
    required this.language,
    this.gender,
    required this.countryCode,
    required this.timezone,
    this.birthDate,
    required this.photoUrl,
    required this.isActivated,
    this.isVerified,
    this.deviceId,
    required this.belongsToGroupAdminId,
    required this.createdAt,
    required this.updatedAt
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'],
        email: json['email'],
        password: json['password'],
        username: json['username'],
        name: json['name'],
        type: json['type'],
        language: json['language'],
        gender: json['gender'],
        countryCode: json['countryCode'],
        timezone: json['timezone'],
        birthDate: json['birthDate'],
        photoUrl: json['photoUrl'],
        isActivated: json['isActivated'],
        isVerified: json['isVerify'],
        deviceId: json['deviceId'],
        belongsToGroupAdminId:  json['belongsToGroupAdminId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt'])
    );
  }

}