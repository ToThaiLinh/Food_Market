import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserService {
  final baseUrl = "http://10.0.2.2:8080/it4788";

  Future<User?> login(String email, String password) async {
    final uri = Uri.parse("${baseUrl}/auth/login");
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'password': password
        },
      );
      if(response.statusCode == 201) {
        final Map<String, dynamic> bodyContent = json.decode(response.body);
        if (bodyContent['resultCode'] == '00047') {
          return User.fromJson(bodyContent);
        } else {
          print("Đăng nhập thất bại: ${bodyContent['resultMessage']['en']}");
        }
      } else {
        print("Yêu cầu không thành công với mã lỗi: ${response.statusCode}");
      }
    } catch(e) {
      print("Đã xảy ra lỗi khi gọi API: $e");
    }
    return null;
  }

  Future<User?> getProfile() async {
    final uri = Uri.parse("${baseUrl}/user");

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print("Token không tồn tại trong SharedPreferences.");
        return null;
      }

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bodyContent = json.decode(response.body);
        if (bodyContent['resultCode'] == '00047') {
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