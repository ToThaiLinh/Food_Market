import 'dart:convert';
import 'package:http/http.dart' as http;

class ShoppingApiService {
  final String _baseUrl = 'http://10.0.2.2:8080/it4788';

  Future<String?> createFood({
    required String name,
    required String category,
    required String unit,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/food');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': name,
          'category': category,
          'unit': unit,
        },
      );

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['_id']['\$oid'];
      } else {
        throw Exception('Failed to create food');
      }
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<String?> updateFood({
    required String name,
    required String category,
    required String unit,
    required String token,
    required String id,
    required String quantity,
  }) async {
    final url = Uri.parse('$_baseUrl/food');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': name,
          'category': category,
          'unit': unit,
          'id': id,
          'quantity': quantity,
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['_id']['\$oid'];
      } else {
        throw Exception('Failed to update food');
      }
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }
}