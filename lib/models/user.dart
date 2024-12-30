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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'] ,
        email: json['email'],
        password: json['password'],
        username: json['username'],
        name: json['name'] ,
        type: json['type'],
        language: json['language'],
        gender: json['gender'] ,
        countryCode: json['countryCode'] ,
        timezone: json['timezone'] ,
        birthDate: json['birthDate'] ,
        photoUrl: json['avatar'] ,
        isActivated: json['isActivated'] ,
        isVerified: json['isVerify'] ,
        deviceId: json['deviceId'],
        belongsToGroupAdminId:  json['belongsToGroupAdminId']
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
    };
  }

}