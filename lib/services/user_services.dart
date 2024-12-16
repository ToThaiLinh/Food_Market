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
        body: {'email': email, 'password': password},
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> bodyContent = json.decode(response.body);
        if (bodyContent['resultCode'] == '00047') {
          final accessToken = bodyContent['accessToken'];
          final refreshToken = bodyContent['refreshToken'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', accessToken);
          await prefs.setString('refresh_token', refreshToken);

          return User.fromJson(bodyContent['user']);
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

  Future<User> getUserInfo() async {
    final uri = Uri.parse("${baseUrl}/auth/profile");
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bodyContent = json.decode(response.body);
        final user = bodyContent;
        return User.fromJson(user);
      } else {
        throw Exception('Failed to load user info');
      }
    } catch (e) {
      throw Exception('Error getting user info: $e');
    }
  }

  Future<void> updateUserInfo(Map<String, dynamic> updateData) async {
    try {
      final response = await http.put(
        Uri.parse('your_api_url/user/update'),
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
          'Content-Type': 'application/json',
        },
        body: json.encode(updateData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user info');
      }
    } catch (e) {
      throw Exception('Error updating user info: $e');
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    return token ?? '';
  }
}
