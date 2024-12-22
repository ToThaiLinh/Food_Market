import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class LoginApiService {
  String accessToken = '';
  final String _baseUrl = 'http://10.0.2.2:8080/it4788/auth';

  Future<User?> login(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
        },
        body: {'email': email, 'password': password},
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> bodyContent = json.decode(response.body);
        if (bodyContent['resultCode'] == '00047') {
          ///TODO: Lay accessToken tu response api va gan vao globalToken
          final user = User.fromJson(bodyContent);
          accessToken = user.accessToken;
          print("Access token: $accessToken");
          return User.fromJson(bodyContent);
        } else {
          print("Đăng nhập thất bại: ${bodyContent['resultMessage']['en']}");
        }
      } else {
        print("Yêu cầu không thành công với mã lỗi: ${response.statusCode}");
      }
    } catch (e) {
      print("Đã xảy ra lỗi khi gọi API: $e");
    }
    return null;
  }
}
