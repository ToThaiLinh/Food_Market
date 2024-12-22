import 'dart:convert';
import 'package:food/ui/pages/login/login_page.dart';
import 'package:http/http.dart' as http;

class ShoppingApiService {
  String accessToken = '';
  final String _baseUrl = 'http://10.0.2.2:8080/it4788';

  Future<String?> createFood({
    required String name,
    required String category,
    required String unit,
  }) async {
    final url = Uri.parse('$_baseUrl/food');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $globalToken',
        },
        body: {
          'name': name,
          'category': category,
          'unit': unit,
        },
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Truy cập _id từ đối tượng food
        return data['food']['_id']; // Sửa ở đây
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
    required String id,
    required int quantity,
  }) async {
    final url = Uri.parse('$_baseUrl/food');
    try {
      print('Sending update request with ID: $id');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $globalToken',
        },
        body: {
          'name': name,
          'category': category,
          'unit': unit,
          'id': id,
          'quantity': quantity.toString(),
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Kiểm tra cấu trúc data
        print('Decoded response data: $data');

        if (data['_id'] != null) {
          // Xử lý trường hợp ID là object MongoDB
          return data['_id']['\$oid'] ?? data['_id'].toString();
        }
        return data['id']?.toString(); // Fallback nếu ID ở dạng khác
      }
      return null;
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<String?> deleteFood({
    required String id,
  }) async {
    final url = Uri.parse('$_baseUrl/food');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $globalToken',
        },
        body: {
          'id': id,
        },
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['_id']['\$oid'];
      } else {
        throw Exception('Failed to delete food');
      }
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllFoods() async {
    final url = Uri.parse('$_baseUrl/food');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $globalToken',
          // Thêm header để tăng giới hạn kích thước response
          'Accept-Encoding': 'gzip, deflate, br',
        },
      );

      if (response.statusCode == 200) {
        // Chuyển đổi response body thành UTF8 để đảm bảo đọc đúng
        final String responseBody = utf8.decode(response.bodyBytes);
        print('Full Response Body Length: ${responseBody.length}');

        final Map<String, dynamic> data = jsonDecode(responseBody);

        if (data.containsKey('food') && data['food'] is List) {
          final List<dynamic> foodList = data['food'] as List;
          print('Number of foods in response: ${foodList.length}');

          final List<Map<String, dynamic>> foods = foodList
              .map((item) => item as Map<String, dynamic>)
              .toList();

          print('Number of processed foods: ${foods.length}');
          return foods;
        } else {
          print('Invalid data structure: ${data.keys}');
          return null;
        }
      } else {
        print('Error status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        return null;
      }
    } catch (err) {
      print('Error getting foods: $err');
      return null;
    }
  }
}