import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plan.dart';
import '../ui/pages/login/login_page.dart';

class MealPlanService {
  final String apiUrl = "http://10.0.2.2:8080/it4788/meal"; // API endpoint
  // final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImhhdmluaHBodW9jQGdtYWlsLmNvbSIsInN1YiI6IjY3MGZlZjhkNmVmNjlhMDM3MWQ5MjUzNiIsImlhdCI6MTczNDkyNzg3OCwiZXhwIjoxNzY2NDYzODc4fQ.ht0hi2NiknBjQYlO0IOAdhvioT0Xb84KGOmTdsAjaCc";

  // Function to create a meal plan
  Future<MealPlan?> createMealPlan({
    required String foodName,
    required String timestamp,
    required String name,
  }) async {
    // Chuẩn bị headers cho request
    Map<String, String> headers = {
      "Authorization": "Bearer $globalToken",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    // Chuẩn bị body cho request
    Map<String, dynamic> body = {
      "foodName": foodName,
      "timestamp": timestamp,
      "name": name,
    };

    try {
      // Gửi POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        // Lấy phần newPlan từ response và chuyển thành đối tượng MealPlan
        Map<String, dynamic> newPlanData = responseData['newPlan'];
        print(newPlanData);
        MealPlan mealPlan = MealPlan.fromJson(newPlanData);

        return mealPlan;
      }
      else if (response.statusCode == 500) {
        throw Exception("Food not found in database.");
      }
      else {
        // Xử lý lỗi nếu request không thành công
        throw Exception("Failed to create meal plan. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Xử lý ngoại lệ nếu có lỗi
      print("lõi đây này");
      throw Exception("Error occurred: $e");
    }
  }

  // Function to delete a meal plan by id using path parameter
  Future<String> deleteMealPlan({required String planId}) async {
    // Xây dựng URL với tham số đường dẫn (path parameter)
    final String url = "$apiUrl/$planId"; // Thêm `planId` vào URL

    // Chuẩn bị headers cho request
    Map<String, String> headers = {
      "Authorization": "Bearer $globalToken", // Dùng Bearer Token cho xác thực
      "Content-Type": "application/json", // Mặc dù là DELETE, nhưng đôi khi server cần kiểu dữ liệu này
    };

    try {
      // Gửi DELETE request
      final response = await http.delete(
        Uri.parse(url), // URL đã được thêm `planId`
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Parse response nếu request thành công
        Map<String, dynamic> responseData = json.decode(response.body);

        // Lấy thông điệp từ phản hồi và trả về
        String resultMessage = responseData['resultMessage']['en'];
        return resultMessage; // Trả về thông điệp thành công từ API
      } else {
        // Xử lý lỗi nếu request không thành công
        throw Exception("Failed to delete meal plan. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Xử lý ngoại lệ nếu có lỗi
      throw Exception("Error occurred: $e");
    }
  }

  // Function to update a meal plan using PUT request with planId in URL
  Future<MealPlan> updateMealPlan({
    required String planId, // planId là tham số trong URL
    required String newFoodName,
    required String newName,
  }) async {
    // Tạo URL với planId làm tham số trong URL
    final String url = "$apiUrl/$planId"; // Thêm planId vào URL

    // Chuẩn bị headers cho request
    Map<String, String> headers = {
      "Authorization": "Bearer $globalToken", // Dùng Bearer Token cho xác thực
      "Content-Type": "application/x-www-form-urlencoded", // Chỉ định loại content là x-www-form-urlencoded
    };

    // Chuẩn bị body cho request theo định dạng form-urlencoded
    Map<String, String> body = {
      "newFoodName": newFoodName,
      "newName": newName,
    };

    try {
      // Gửi PUT request với URL chứa planId
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Parse response nếu request thành công
        Map<String, dynamic> responseData = json.decode(response.body);
        return MealPlan.fromJson(responseData['Plan']);
      } else {
        // Xử lý lỗi nếu request không thành công
        throw Exception("Failed to update meal plan. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Xử lý ngoại lệ nếu có lỗi
      throw Exception("Error occurred: $e");
    }
  }

  // Function to update a meal plan using PUT request with planId in URL
  Future<List<MealPlan>> getMealPlanByDate({required String date}) async {
    final String url = "$apiUrl?date=$date"; // Thêm planId vào URL

    Map<String, String> headers = {
      "Authorization": "Bearer $globalToken",
      "Content-Type": "application/json",
      // Đảm bảo rằng loại content là application/json
    };

    try {
      // Gửi GET request mà không có body
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Parse response thành danh sách các MealPlan nếu request thành công
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> plansData = responseData['plans'];

        // Map dữ liệu từ response sang đối tượng MealPlan
        List<MealPlan> mealPlans = plansData.map((plan) {
          return MealPlan.fromJson(plan);
        }).toList();

        return mealPlans;
      } else {
        print("lỗi ở chỗ này này");
        throw Exception(
            "Failed to fetch meal plans. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("lỗi ở đây này");
      throw Exception("Error occurred: $e");
    }
  }
}
