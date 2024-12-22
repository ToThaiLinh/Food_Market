import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';

class FoodService {
  final String baseUrl = "http://10.0.2.2:8080/it4788";
  final String token;

  FoodService({required this.token});

  Future<Food?> getFoodById(String id) async {
    final url = Uri.parse('$baseUrl/food/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Food.fromJson(data['food']);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
