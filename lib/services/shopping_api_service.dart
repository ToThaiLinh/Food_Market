import 'dart:convert';
import 'dart:io';
import 'package:food/ui/pages/login/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingApiService {
  String accessToken = '';
  final String _baseUrl = 'http://10.0.2.2:8080/it4788';

  Future<Map<String, dynamic>?> createFood({
    required String name,
    required String category,
    required String unit,
    required File file,
  }) async {
    final url = Uri.parse('$_baseUrl/food');
    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $globalToken'
        ..fields['name'] = name
        ..fields['category'] = category
        ..fields['unit'] = unit
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print('Response Body: ${responseBody.body}');
      print('Status Code: ${responseBody.statusCode}');

      if (responseBody.statusCode == 200 || responseBody.statusCode == 201) {
        final data = jsonDecode(responseBody.body);

        // Check if the response contains food data
        if (data['food'] != null && data['food'] is Map<String, dynamic>) {
          return data['food'];  // Return the entire food object
        }
      }
      return null;
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
    File? file, // Make file optional
  }) async {
    // Validate input data
    if (name.isEmpty || category.isEmpty || unit.isEmpty || id.isEmpty || userIdCreate.isEmpty) {
      print('Validation Error: All fields must be filled.');
      return null; // Or throw an exception
    }

    final url = Uri.parse('$_baseUrl/food/$id'); // Include the ID in the URL
    try {
      print('Sending update request with ID: $id');
      var request = http.MultipartRequest('PUT', url)
        ..headers['Authorization'] = 'Bearer $globalToken'
        ..fields['name'] = name
        ..fields['category'] = category
        ..fields['unit'] = unit
        ..fields['userIdCreate'] = userIdCreate; // Ensure userIdCreate is included

      // Only add file to request if it exists
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (responseBody.statusCode == 200 || responseBody.statusCode == 201) {
        final data = jsonDecode(responseBody.body);
        if (data['food'] != null) {
          return data['food'];
        }
      }
      print('API Response: ${responseBody.body}'); // Add this for debugging
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