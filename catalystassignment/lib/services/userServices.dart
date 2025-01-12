// lib/services/user_service.dart
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/Constants.dart';
import '../models/user.dart';

class UserService {
  Future<List<User>> fetchUsersList() async {
    try {
      // Make the HTTP GET request
      final response = await http.get(Uri.parse(userUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((userJson) => User.fromJson(userJson)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  //   // Add a new user
  Future<void> addUser(User user,
      {File? profileImage, File? profileVideo}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(userUrl));

      // Add text fields to the request
      request.fields['name'] = user.name;
      request.fields['email'] = user.email;
      request.fields['phone'] = user.phone!; // Add as String

      if (profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            profileImage.path,
          ),
        );
      }
      if (profileVideo != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'intro_video',
            profileVideo.path,
          ),
        );
      }

      // Send the request
      final response = await request.send();

      if (response.statusCode == 201) {
        print('User added successfully');
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to add user: $responseBody');
      }
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  // Delete a user
  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$userUrl/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<User> fetchUser(int id) async {
    final response = await http.get(
      Uri.parse('$userUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the JSON response into a User object
      final Map<String, dynamic> userJson = json.decode(response.body);
      return User.fromJson(userJson);
    } else {
      throw Exception('Failed to fetch user: ${response.statusCode}');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final payload = json.encode(user.toJson());
      print([payload]);
      final response = await http.post(
        Uri.parse('$userUrl/${user.id}'),
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );
      print(response.statusCode);
      if (response.statusCode != 200) {
        if (response.statusCode == 422) {
          final errors = json.decode(response.body)['errors'];
          throw Exception('Validation errors: $errors');
        } else {
          throw Exception('Failed to update user: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
