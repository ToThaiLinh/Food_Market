class User {
  final String? id;
  final String? email;
  final String? password;
  final String? username;
  final String? name;
  final String? type;
  final String? language;
  final String? gender;
  final String? countryCode;
  final int? timezone;
  final String? birthDate;
  final String? photoUrl;
  final bool? isActivated;
  final bool? isVerified;
  final String? deviceId;
  final int? belongsToGroupAdminId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? accessToken;
  final String? refreshToken;

  User({
    this.id,
    this.email,
    this.password,
    this.username,
    this.name,
    this.type,
    this.language,
    this.gender,
    this.countryCode,
    this.timezone,
    this.birthDate,
    this.photoUrl,
    this.isActivated,
    this.isVerified,
    this.deviceId,
    this.belongsToGroupAdminId,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
    this.refreshToken
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['_id'] ,
        email: json['user']['email'],
        password: json['user']['password'],
        username: json['user']['username'],
        name: json['user']['name'] ,
        type: json['user']['type'],
        language: json['user']['language'],
        gender: json['user']['gender'] ,
        countryCode: json['user']['countryCode'] ,
        timezone: json['user']['timezone'] ,
        birthDate: json['user']['birthDate'] ,
        photoUrl: json['user']['photoUrl'] ,
        isActivated: json['user']['isActivated'] ,
        isVerified: json['user']['isVerify'] ,
        deviceId: json['user']['deviceId'],
        belongsToGroupAdminId:  json['user']['belongsToGroupAdminId'],
        createdAt: DateTime.parse(json['user']['createdAt']),
        updatedAt: DateTime.parse(json['user']['updatedAt']),
        accessToken: json['accessToken'] ?? "",
        refreshToken: json['refreshToken'] ?? ""
    );
  }

}