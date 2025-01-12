// lib/controllers/user_controller.dart
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/userServices.dart';

class UserController extends StateNotifier<List<User>> {
  final UserService _userService;

  UserController(this._userService) : super([]) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final users = await _userService.fetchUsersList();
      state = users;
    } catch (e) {
      // Handle error (e.g., show a snackbar or log the error)
      print('Error fetching users: $e');
    }
  }

  Future<void> addUser(User user,
      {File? profileImage, File? profileVideo}) async {
    try {
      await _userService.addUser(user, profileImage: profileImage);
      state = [...state, user]; // Add the new user to the state
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _userService.updateUser(user);
      state = state
          .map((u) => u.id == user.id ? user : u)
          .toList(); // Update the user in the state
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _userService.deleteUser(id);
      state = state
          .where((user) => user.id != id)
          .toList(); // Remove the user from the state
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<User?> fetchUser(int id) async {
    try {
      final user = await _userService.fetchUser(id);

      final userExists = state.any((u) => u.id == id);
      if (userExists) {
        state = state.map((u) => u.id == id ? user : u).toList();
      } else {
        state = [...state, user];
      }

      return user;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  List<User> filterUsersByRole(String role) {
    var RoleList = role == 'all'
        ? state
        : state.where((user) => user.role == role).toList();
    return RoleList;
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, List<User>>((ref) {
  final userService = UserService();
  return UserController(userService);
});
