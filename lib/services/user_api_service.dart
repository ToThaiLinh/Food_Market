import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApiService {
  String accessToken = '';
  final String _baseUrl = 'http://10.0.2.2:8080/it4788/user';

  Future<Map<String, dynamic>?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/change-password');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
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
      throw Exception(responseData['message'] ?? 'Failed to change password');
    }
  }
}
