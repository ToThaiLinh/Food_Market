import 'dart:convert';

import '../../config/configuration.dart';
import '../../models/category.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = AppConfig.baseUrl;

  /// Gửi yêu cầu POST để thêm danh mục mới
  Future<Category?> createCategory(String name) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/admin/category"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "name": name,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Category.fromJson(responseData['unit']);
      } else {
          print("Failed to create category. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
        print("Error while creating category: $e");
      return null;
    }
  }

  /// Lấy danh sách tất cả các danh mục
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/admin/category"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> categoriesJson = responseData['categories'];

        return categoriesJson
            .map((categoryJson) => Category.fromJson(categoryJson))
            .toList();
      } else {
          print("Failed to retrieve categories. Status code: ${response.statusCode}");
          print("Response body: ${response.body}");
        return [];
      }
    } catch (e) {
        print("Error while retrieving categories: $e");
      return [];
    }
  }

  /// Cập nhật tên danh mục
  Future<bool> updateCategory(String oldName, String newName) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/api/admin/category"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "oldName": oldName,
          "newName": newName,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

          print("Update successful: ${responseData['resultMessage']['en']}");

        return true;
      } else {
          print("Failed to update category. Status code: ${response.statusCode}");
          print("Response body: ${response.body}");

        return false;
      }
    } catch (e) {
        print("Error while updating category: $e");
      return false;
    }
  }

  Future<bool> deleteCategory(String name) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/api/admin/category"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "name": name,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

          print("Delete successful: ${responseData['resultMessage']['en']}");

        return true;
      } else {
          print("Failed to delete category. Status code: ${response.statusCode}");
          print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
        print("Error while deleting category: $e");
      return false;
    }
  }
}