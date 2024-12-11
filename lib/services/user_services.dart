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

  Future<User> getUserInfo() async {
    try {
      final response = await http.get(
        Uri.parse('your_api_url/user/info'),
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
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
