import 'dart:convert';
import 'package:food/config/configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/food.dart';

class FoodService {
  final _baseUrl = AppConfig.baseUrl;

  Future<Food> createFood({
    required String name,
    required String category,
    required String unit,
    //File? imageFile,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/food');
    final request = http.MultipartRequest('POST', url);

    // Thêm các field vào request body
    request.fields['name'] = name;
    request.fields['foodCategoryName'] = category;
    request.fields['unitName'] = unit;

    // Thêm file ảnh vào request
    // if (imageFile != null) {
    //   request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    // }

    // Thêm header Authorization
    request.headers['Authorization'] = 'Bearer $token';

    // Gửi request
    final streamedResponse = await request.send();

    // Xử lý response
    if (streamedResponse.statusCode == 200) {
      final responseString = await streamedResponse.stream.bytesToString();
      final responseJson = jsonDecode(responseString);

      if (responseJson['resultCode'] == '00160') {
        // Parse đối tượng Food từ response
        return Food.fromJson(responseJson['newFood']);
      } else {
        throw Exception('Failed to create food: ${responseJson['resultMessage']['en']}');
      }
    } else {
      throw Exception('HTTP Error: ${streamedResponse.statusCode}');
    }
  }

  // Future<Food> updateFood({
  //   required String token,
  //   required int foodId,
  //   required String name,
  //   required String newCategory,
  //   required String newUnit,
  //   String? imagePath, // Đường dẫn ảnh, có thể null
  // }) async {
  //   final url = Uri.parse("$_baseUrl/food/${foodId}");
  //
  //   // Tạo multipart request để gửi hình ảnh (nếu có)
  //   final request = http.MultipartRequest('PUT', url)
  //     ..headers['Authorization'] = 'Bearer $token'
  //     ..fields['id'] = foodId.toString()
  //     ..fields['name'] = name
  //     ..fields['newCategory'] = newCategory
  //     ..fields['newUnit'] = newUnit;
  //
  //   if (imagePath != null) {
  //     request.files.add(await http.MultipartFile.fromPath('image', imagePath));
  //   }
  //
  //   // Gửi yêu cầu
  //   final streamedResponse = await request.send();
  //   final response = await http.Response.fromStream(streamedResponse);
  //
  //   // Kiểm tra trạng thái phản hồi
  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //
  //     // Trả về đối tượng Food từ phản hồi
  //     return Food.fromJson(responseData['food']);
  //   } else {
  //     throw Exception('Failed to update food: ${response.body}');
  //   }
  // }

  Future<void> deleteFood(String id, String token) async {
    final url = Uri.parse('$_baseUrl/food/${id}');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      // Kiểm tra phản hồi
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response: ${responseData['resultMessage']['en']}');
      } else {
        print('Error: ${response.statusCode}');
        final errorData = jsonDecode(response.body);
        print('Error message: ${errorData['resultMessage']['en']}');
      }
    } catch (e) {
      print('Request failed: $e');
    }



    Future<String> getToken() async {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      return token ?? '';
    }
  }

}