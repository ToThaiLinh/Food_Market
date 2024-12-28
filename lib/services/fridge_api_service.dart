import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ui/pages/login/login_page.dart';

class FridgeApiService {
  final String _baseUrl = 'http://10.0.2.2:8080/it4788';

  Future<Map<String, dynamic>?> createFridgeItem({
    // required String itemName,
    required int useWithin,
    required int quantity,
    required String foodId,
    required String note,
  }) async {
    final url = Uri.parse('$_baseUrl/fridge');
    try {
      print('Creating fridge item with:');
      print('foodId: $foodId');
      print('quantity: $quantity');
      print('useWithin: $useWithin');
      print('note: $note');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $globalToken',
        },
        body: {
          // 'itemName': itemName,
          'useWithin': useWithin.toString(),
          'quantity': quantity.toString(),
          'foodId': foodId,
          'note': note,
        },
      );

      print('Response status code: ${response.statusCode}'); // Log status code
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'id': data['newFridgeItem']['id'].toString(),
          'quantity': data['newFridgeItem']['quantity'],
          'note': data['newFridgeItem']['note'],
        };
      } else {
        print('Error response: ${response.body}');
        return null;
      }
    } catch (err) {
      print('API Error: $err');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateFridgeItem({
    // required String itemName,
    required int useWithin,
    required int quantity,
    required String id,
    required String note,
  }) async {
    final url = Uri.parse('$_baseUrl/fridge');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $globalToken',
        },
        body: {
          // 'itemName': itemName,
          'useWithin': useWithin.toString(),
          'quantity': quantity.toString(),
          'id': id,
          'note': note,
        },
      );

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'id': data['newFridgeItem']['id'].toString(),
          // 'expiredDate': data['newFridgeItem']['expiredDate'],
          'quantity': data['newFridgeItem']['quantity'],
          'note': data['newFridgeItem']['note'],
          // 'startDate': data['newFridgeItem']['startDate'],
          // 'createdAt': data['newFridgeItem']['createdAt'],
          // 'updatedAt': data['newFridgeItem']['updatedAt'],
          // 'foodId': data['newFridgeItem']['FoodId'].toString(),
          // 'userId': data['newFridgeItem']['UserId'].toString(),
        };
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<bool> deleteFridgeItem({
    required String id,
  }) async {
    final url = Uri.parse('$_baseUrl/fridge/$id');
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