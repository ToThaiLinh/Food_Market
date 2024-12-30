class User {
  String? id;
  String? email;
  String? password;
  String? username;
  String? name;
  String? type;
  String? language;
  String? gender;
  String? countryCode;
  int? timezone;
  String? birthDate;
  String? photoUrl;
  bool? isActivated;
  bool? isVerified;
  String? deviceId;
  int? belongsToGroupAdminId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? accessToken;
  String? refreshToken;

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
        photoUrl: json['user']['avatar'] ,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'username': username,
      'name': name,
      'type': type,
      'language': language,
      'gender': gender,
      'countryCode': countryCode,
      'timezone': timezone,
      'birthDate': birthDate,
      'photoUrl': photoUrl,
      'isActivated': isActivated,
      'isVerified': isVerified,
      'deviceId': deviceId,
      'belongsToGroupAdminId': belongsToGroupAdminId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

}