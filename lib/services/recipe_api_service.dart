import 'dart:convert';
import 'package:food/ui/pages/login/login_page.dart';
import 'package:http/http.dart' as http;

class RecipeApiService {
  String accessToken = '';
  final String _baseUrl = 'http://10.0.2.2:8080/it4788';

  Future<String?> createRecipe({
    required String foodName,
    required String name,
    required String htmlContent,
    required String description,
  }) async {
    final url = Uri.parse('$_baseUrl/recipe');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded', // Đảm bảo gửi dữ liệu dưới dạng JSON
          'Authorization': 'Bearer $globalToken',
        },
        body: {
          'foodName': foodName,
          'name': name,
          'htmlContent': htmlContent,
          'description': description,
        });

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['newRecipe']['_id']; // Trả về ID của công thức mới
      } else {
        throw Exception('Failed to create recipe: ${response.body}');
      }
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<String?> updateRecipe({
    required String newFoodName,
    required String newName,
    required String newHtmlContent,
    required String newDescription,
    required String recipeId,
  }) async {
    final url = Uri.parse('$_baseUrl/recipe');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $globalToken',
        },
        body: {
          'foodName': newFoodName,
          'name': newName,
          'htmlContent': newHtmlContent,
          'description': newDescription,
          'id': recipeId,
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

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

  Future<String?> deleteRecipe({
    required String recipeId,
  }) async {
    final url = Uri.parse('$_baseUrl/recipe');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $globalToken',
        },
        body: {
          'id': recipeId,
        },
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['_id']['\$oid'];
      } else {
        throw Exception('Failed to delete recipe');
      }
    } catch (err) {
      print('Detailed Error: $err');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllRecipes() async {
    final url = Uri.parse('$_baseUrl/recipe');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $globalToken',
          'Accept-Encoding': 'gzip, deflate, br',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Chuyển đổi response body thành UTF8 để đảm bảo đọc đúng
        final String responseBody = utf8.decode(response.bodyBytes);
        print('Full Response Body Length: ${responseBody.length}');

        final Map<String, dynamic> data = jsonDecode(responseBody);

        if (data.containsKey('recipes') && data['recipes'] is List) {
          final List<dynamic> recipeList = data['recipes'] as List;

          final List<Map<String, dynamic>> recipes = recipeList
              .map((item) => item as Map<String, dynamic>)
              .toList();

          return recipes;
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