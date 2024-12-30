import 'dart:convert';

import 'package:food/ui/pages/login/login_page.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  final _baseUrl = 'http://10.0.2.2:8080/it4788';

  Future<User?> login(String email, String password) async {
    final uri = Uri.parse("${_baseUrl}/auth/login");
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
        },
        body: {'email': email, 'password': password},
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> bodyContent = json.decode(response.body);
        if (bodyContent['resultCode'] == '00047') {
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

  Future<User> getUserInfo(String id) async {
    final uri = Uri.parse("${_baseUrl}/user/${id}");
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $globalToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future<void> updateUserInfo(User user) async {
   print(user.toJson());
    try {
      final response = await http.patch(
        Uri.parse('${_baseUrl}/user'),
        headers: {
          'Authorization': 'Bearer $globalToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(user.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user info');
      }
    } catch (e) {
      throw Exception('Error updating user info: $e');
    }
  }

}