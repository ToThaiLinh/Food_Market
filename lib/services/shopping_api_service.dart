import 'dart:convert';
import 'package:food/ui/pages/login/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
      print('Status Code: ${response.statusCode}');

      // Parse response body
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if food object exists in response
        if (data['food'] != null && data['food']['_id'] != null) {
          return data['food']['_id'];
        } else {
          print('Invalid response format: ${response.body}');
          return null;
        }
      } else {
        print('Error response: ${response.body}');
        return null;
      }

    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateFood({
    required String name,
    required String category,
    required String unit,
    required String id,
    required String userIdCreate,
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
          'userIdCreate': userIdCreate,
          'quantity': quantity.toString(),
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Decoded response data: $data');

        if (data['food'] != null) {
          try {
            // Lưu quantity vào SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('food_quantity_${data['food']['_id']}', quantity);
            print('Saved quantity ${quantity} for food ${data['food']['_id']}');

            // Trả về toàn bộ object food với quantity
            return {
              ...data['food'],
              'quantity': quantity
            };
          } catch (e) {
            print('Error saving to SharedPreferences: $e');
            // Vẫn trả về dữ liệu ngay cả khi không lưu được vào SharedPreferences
            return {
              ...data['food'],
              'quantity': quantity
            };
          }
        }
      }
      return null;
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<bool> deleteFood({
    required String id,
  }) async {
    final url = Uri.parse('$_baseUrl/food/$id');
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

      print('Delete Response Body: ${response.body}');
      print('Delete Status Code: ${response.statusCode}');

      // Parse response body để kiểm tra message
      final responseData = jsonDecode(response.body);
      print('Delete Response Data: $responseData');

      // Kiểm tra cả status code và message từ API
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Delete operation successful');
        return true;
      } else {
        print('Delete operation failed with status: ${response.statusCode}');
        return false;
      }
    } catch (err) {
      print('Delete Error: $err');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllFoods() async {
    final url = Uri.parse('$_baseUrl/food?current=1&pageSize=100');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $globalToken',
          'Accept-Encoding': 'gzip, deflate, br',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String responseBody = utf8.decode(response.bodyBytes);
        print('Full Response Body Length: ${responseBody.length}');

        final Map<String, dynamic> data = jsonDecode(responseBody);

        if (data.containsKey('food') && data['food'] is List) {
          final List<dynamic> foodList = data['food'] as List;
          print('Number of foods in response: ${foodList.length}');

          try {
            // Đọc dữ liệu quantity từ local storage
            final prefs = await SharedPreferences.getInstance();

            final List<Map<String, dynamic>> foods = foodList.map((item) {
              final foodId = item['_id'].toString();
              // Lấy quantity từ SharedPreferences, mặc định là 0 nếu chưa có
              final quantity = prefs.getInt('food_quantity_$foodId') ?? 0;

              return {
                ...item as Map<String, dynamic>,
                'quantity': quantity, // Thêm quantity vào mỗi item
              };
            }).toList();

            print('Number of processed foods: ${foods.length}');
            return foods;
          } catch (e) {
            print('Error accessing SharedPreferences: $e');
            // Nếu không thể truy cập SharedPreferences, vẫn trả về danh sách với quantity = 0
            return foodList.map((item) => {
              ...item as Map<String, dynamic>,
              'quantity': 0,
            }).toList();
          }
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