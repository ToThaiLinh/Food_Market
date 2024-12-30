import 'dart:convert';
import 'package:food/ui/pages/login/login_page.dart';
import 'package:http/http.dart' as http;

class GroupService {
  final String _baseUrl = 'http://10.0.2.2:8080/it4788';

  Future<Map<String, dynamic>> createGroup(String groupName) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/group'),
        headers: {
          'Authorization': 'Bearer $globalToken',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: json.encode({
          'name': groupName,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the JSON response
        final responseBody = json.decode(response.body);
        return responseBody;
      } else {
        // Handle errors
        throw Exception(
          'Failed to create group: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error creating group: $e');
    }
  }

  Future<Map<String, dynamic>> addMemberToGroup(String groupId, String username) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl//user/group/add/{$groupId}'),
        headers: {
          'Authorization': 'Bearer $globalToken',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception(
          'Failed to add member: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error adding member to group: $e');
    }
  }

  Future<Map<String, dynamic>> deleteMemberFromGroup(String groupId, String username) async {
    try {
      final response = await http.delete(
        Uri.parse('${_baseUrl}/user/group/${groupId}'),
        headers: {
          'Authorization': 'Bearer $globalToken',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception(
          'Failed to delete member: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting member from group: $e');
    }
  }
  Future<Map<String, dynamic>> getGroupMembers(String groupId) async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}/user/group/${groupId}'),
        headers: {
          'Authorization': 'Bearer $globalToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception(
          'Failed to retrieve group members: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error retrieving group members: $e');
    }
  }

  Future<Map<String, dynamic>> getAllGroupByUserId() async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}/user/group/users/${userId}'),
        headers: {
          'Authorization': 'Bearer $globalToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        final responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception(
          'Failed to retrieve group members: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error retrieving group members: $e');
    }
  }



}
