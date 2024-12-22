import 'dart:convert';
import 'dart:io';
import 'package:food/config/configuration.dart';
import 'package:http/http.dart' as http;

import '../../models/food.dart';

class FoodService {
  final _baseUrl = AppConfig.baseUrl;

  Future<Food> createFood({
    required String name,
    required String foodCategoryName,
    required String unitName,
    File? imageFile,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/food');
    final request = http.MultipartRequest('POST', url);

    // Thêm các field vào request body
    request.fields['name'] = name;
    request.fields['foodCategoryName'] = foodCategoryName;
    request.fields['unitName'] = unitName;

    // Thêm file ảnh vào request
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

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

}