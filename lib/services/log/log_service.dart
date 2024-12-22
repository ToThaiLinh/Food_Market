import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/configuration.dart';
import '../../models/log.dart';

class LogService {
  final String baseUrl = AppConfig.baseUrl;

  /// Lấy logs từ API
  Future<List<Log>?> getLogs() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/admin/logs"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Kiểm tra kết quả trả về từ API
        if (responseData['resultCode'] == '00100') {
          List logs = responseData['logs'];
          return logs.map((log) => Log.fromJson(log)).toList();
        } else {
          print("Failed to fetch logs. Response code: ${responseData['resultCode']}");
          return null;
        }
      } else {
        print("Failed to fetch logs. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error while fetching logs: $e");
      return null;
    }
  }
}
