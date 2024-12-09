import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterApiService {
  final String _baseUrl = 'http://10.0.2.2:8080/it4788/auth';

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'name': name,
        'email': email,
        'username': username,
        'password': password,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }
}