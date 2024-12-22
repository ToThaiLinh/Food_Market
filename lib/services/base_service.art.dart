import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseService {
  final String _baseUrl;
  final String? _token;

  BaseService(this._baseUrl, [this._token]);

  // Phương thức gửi POST request
  Future<Map<String, dynamic>> create(String endpoint, Map<String, String> body) async {
    return await _sendRequest('POST', endpoint, body);
  }

  // Phương thức gửi PUT request
  Future<Map<String, dynamic>> update(String endpoint, Map<String, String> body) async {
    return await _sendRequest('PUT', endpoint, body);
  }

  // Phương thức gửi DELETE request
  Future<Map<String, dynamic>> delete(String endpoint, Map<String, String> body) async {
    return await _sendRequest('DELETE', endpoint, body);
  }

  // Phương thức gửi GET request
  Future<Map<String, dynamic>> get(String endpoint, [Map<String, String>? queryParams]) async {
    return await _sendRequest('GET', endpoint, null, queryParams);
  }

  // Hàm dùng chung để gửi tất cả các loại request (GET, POST, PUT, DELETE)
  Future<Map<String, dynamic>> _sendRequest(
      String method, String endpoint, Map<String, String>? body, [Map<String, String>? queryParams]) async {
    final url = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParams);

    try {
      late final http.Response response;

      // Xử lý các loại phương thức khác nhau
      if (method == 'POST' || method == 'PUT' || method == 'DELETE') {
        response = (await http.Request(method, url)
          ..headers['Content-Type'] = 'application/x-www-form-urlencoded'
          ..headers['Authorization'] = 'Bearer $_token'
          ..bodyFields = body ?? {}) as http.Response;
      } else {
        response = await http.get(url);
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }
}
