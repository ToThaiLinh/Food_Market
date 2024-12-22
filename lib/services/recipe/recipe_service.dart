import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/configuration.dart';
import '../../models/recipe.dart';

class RecipeService {
  final String _baseUrl = AppConfig.baseUrl;

  // Function to create a recipe
  Future<Recipe?> createRecipe(String foodName, String name, String htmlContent,
      String description, String token) async {
    final url = Uri.parse("$_baseUrl/recipe");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token', // Include token for authentication
        },
        body: {
          'foodName': foodName,
          'name': name,
          'htmlContent': htmlContent,
          'description': description,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('newRecipe')) {
          return Recipe.fromJson(data['newRecipe']);
        } else {
          // Handle if the expected key does not exist
          return null;
        }
      } else {
        print('Failed to create recipe, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('error: An error occurred: $e');
      return null;
    }
  }

  Future<Recipe?> updateRecipe(
    String recipeId, {
    String? newHtmlContent,
    String? newDescription,
    String? newFoodName,
    String? newName,
    String? token,
  }) async {
    final url = Uri.parse("$_baseUrl/recipe");

    try {
      // Nếu không có token được truyền vào, lấy token từ SharedPreferences
      token ??= await _getTokenFromPreferences();

      // Construct the request body with only the provided fields
      final Map<String, String> body = {
        'recipeId': recipeId,
      };

      // Add only non-null fields to the body
      if (newHtmlContent != null) {
        body['newHtmlContent'] = newHtmlContent;
      }
      if (newDescription != null) {
        body['newDescription'] = newDescription;
      }
      if (newFoodName != null) {
        body['newFoodName'] = newFoodName;
      }
      if (newName != null) {
        body['newName'] = newName;
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token', // Include token for authentication
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('recipe')) {
          return Recipe.fromJson(data['recipe']);
        } else {
          // Handle if the expected key does not exist
          return null;
        }
      } else {
        print('Failed to update recipe, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> deleteRecipe(String recipeId, {String? token}) async {
    final url = Uri.parse("$_baseUrl/recipe");

    try {
      // Nếu không có token được truyền vào, lấy token từ SharedPreferences
      token ??= await _getTokenFromPreferences();

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token', // Include token for authentication
        },
        body: {
          'recipeId': recipeId,  // ID của công thức cần xóa
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;  // Trả về kết quả phản hồi từ API
      } else {
        return {
          'error': 'Failed to delete recipe, status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'error': 'An error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getRecipesByFoodId(String foodId, {String? token}) async {
    final url = Uri.parse("$_baseUrl/recipe?foodId=$foodId");

    try {
      // Nếu không có token được truyền vào, lấy token từ SharedPreferences
      token ??= await _getTokenFromPreferences();

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include token for authentication
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if 'recipes' exists in the response
        if (data.containsKey('recipes')) {
          List<Recipe> recipes = (data['recipes'] as List)
              .map((recipeJson) => Recipe.fromJson(recipeJson))
              .toList();
          return {'recipes': recipes};
        } else {
          return {'error': 'No recipes found'};
        }
      } else {
        return {
          'error': 'Failed to get recipes, status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'error': 'An error occurred: $e',
      };
    }
  }

  Future<String?> _getTokenFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Return the stored token
  }


}
