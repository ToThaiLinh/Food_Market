import 'dart:convert';
import 'dart:ffi';
import 'package:food/services/login_api_service.dart';
import 'package:http/http.dart' as http;

import '../ui/pages/login/login_page.dart';

class FridgeApiService {
  final String _baseUrl = 'http://10.0.2.2:8080/it4788';

  Future<String?> createFood({
    required String foodName,
    required int useWithin,
    required int quantity,
    required String foodId,

  }) async {
    final url = Uri.parse('$_baseUrl/fridge');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${LoginApiService().accessToken}',
        },
        body: {
          'foodName': foodName,
          'useWithin': useWithin.toString(),
          'quantity': quantity.toString(),
        },
      );

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['_id']['\$oid'];
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<String?> updateFood({
    required String newFoodName,
    required int newUseWithin,
    required int newQuantity,
    String newNote = '',
    required String itemId,
  }) async {
    final url = Uri.parse('$_baseUrl/fridge');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${LoginApiService().accessToken}',
        },
        body: {
          'foodName': newFoodName,
          'useWithin': newUseWithin.toString(),
          'quantity': newQuantity.toString(),
          'note': newNote,
          'itemId': itemId,
        },
      );

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['_id']['\$oid'];
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllFridgeFoods({required String token}) async {
    final url = Uri.parse('$_baseUrl/fridge');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $globalToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Kiểm tra và chuyển đổi danh sách
        if (data['food'] is List) {
          final List<dynamic> rawList = data['food'] as List;
          final List<Map<String, dynamic>> foods = rawList
              .where((item) => item is Map<String, dynamic>)
              .map((item) => item as Map<String, dynamic>)
              .toList();

          return foods;
        } else {
          print('Error: "food" key is not a list.');
          return null;
        }
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }
}