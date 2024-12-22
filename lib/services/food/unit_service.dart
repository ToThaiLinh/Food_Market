import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/configuration.dart';
import '../../models/unit.dart';

class UnitService {
  final String baseUrl = AppConfig.baseUrl;

  /// Tạo một đơn vị mới
  Future<Unit?> createUnit(String unitName) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/admin/unit"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "unitName": unitName,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Kiểm tra nếu dữ liệu phản hồi chứa 'unit'
        final unitData = responseData['unit'];
        if (unitData != null) {
          // Parse JSON response thành đối tượng Unit
          final unit = Unit.fromJson(unitData);
          print("Unit created successfully: ${unit.unitName}");
          return unit;
        } else {
          print("No unit data found in response.");
          return null;
        }
      } else {
        print("Failed to create unit. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error while creating unit: $e");
      return null;
    }
  }

  /// Lấy tất cả các đơn vị
  Future<List<Unit>?> getAllUnits() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/admin/unit"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Kiểm tra nếu có dữ liệu đơn vị
        final unitsData = responseData['units'];
        if (unitsData != null) {
          // Chuyển đổi danh sách JSON thành các đối tượng Unit
          List<Unit> units = (unitsData as List)
              .map((unitJson) => Unit.fromJson(unitJson))
              .toList();
          return units;
        } else {
          print("No units found in response.");
          return null;
        }
      } else {
        print("Failed to retrieve units. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error while fetching units: $e");
      return null;
    }
  }

  /// Cập nhật tên đơn vị
  Future<bool> updateUnit(String oldName, String newName) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/api/admin/unit"),
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

        // Kiểm tra kết quả trả về từ API
        if (responseData['resultCode'] == '00122') {
          print("Unit updated successfully: ${responseData['resultMessage']['en']}");
          return true;
        } else {
          print("Failed to update unit. Response code: ${responseData['resultCode']}");
          return false;
        }
      } else {
        print("Failed to update unit. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error while updating unit: $e");
      return false;
    }
  }

  // Xóa một đơn vị theo tên
  Future<bool> deleteUnit(String unitName) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/api/admin/unit"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "unitName": unitName,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Kiểm tra kết quả trả về từ API
        if (responseData['resultCode'] == '00128') {
          print("Unit deleted successfully: ${responseData['resultMessage']['en']}");
          return true;
        } else {
          print("Failed to delete unit. Response code: ${responseData['resultCode']}");
          return false;
        }
      } else {
        print("Failed to delete unit. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error while deleting unit: $e");
      return false;
    }
  }
}
