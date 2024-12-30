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

    // Print request details
    print('Sending request to: $url');
    print('Request body: {name: $name, email: $email, username: $username, password: $password}');

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

    // print('Response status: ${response.statusCode}');
    // print('Response body raw: ${response.body}');

    // Parse response
    final responseData = jsonDecode(response.body);
    // print('Parsed response: $responseData');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } else {
      throw Exception(responseData['message'] ?? 'Failed to register user');
    }
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String id,
    required String code,
  }) async {
    final url = Uri.parse('$_baseUrl/verify-email');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'id': id,
        'code': code,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'data': responseData,
        'statusCode': response.statusCode,
      };
    } else {
      throw Exception('Failed to verify user');
    }
  }
}