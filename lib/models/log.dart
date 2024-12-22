class Log {
  final int id;
  final String userId;
  final String resultCode;
  final String level;
  final String errorMessage;
  final String ip;
  final String createdAt;
  final String updatedAt;

  Log({
    required this.id,
    required this.userId,
    required this.resultCode,
    required this.level,
    required this.errorMessage,
    required this.ip,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      userId: json['userId'],
      resultCode: json['resultCode'],
      level: json['level'],
      errorMessage: json['errorMessage'],
      ip: json['ip'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
