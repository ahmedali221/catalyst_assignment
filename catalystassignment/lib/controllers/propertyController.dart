import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/property.dart';
import '../services/propertyServices.dart';

class PropertyController extends StateNotifier<List<Property>> {
  final PropertyService _propertyService;

  PropertyController(this._propertyService) : super([]) {
    fetchProperties();
  }

  // Fetch all properties
  Future<void> fetchProperties() async {
    try {
      final properties = await _propertyService.fetchProperties();
      state = properties;
    } catch (e) {
      print('Error fetching properties: $e');
    }
  }

  // Add a new property with images
  Future<void> addProperty(Property property, List<File> images) async {
    try {
      await _propertyService.addProperty(
          property, images); // Call the service method
      state = [...state, property]; // Add the new property to the state
    } catch (e) {
      print('Error adding property: $e');
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  Future<void> updateProperty(Property property) async {
    try {
      await _propertyService.updateProp(property);
      // Update the property in the state
      state = state.map((p) => p.id == property.id ? property : p).toList();
    } catch (e) {
      print('Error updating property: $e');
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  // Delete a property
  Future<void> deleteProperty(int id) async {
    try {
      await _propertyService.deleteProperty(id);
      state = state
          .where((property) => property.id != id)
          .toList(); // Remove the property from the state
    } catch (e) {
      print('Error deleting property: $e');
    }
  }

  // Fetch a single property by ID
  Future<Property?> fetchProperty(int id) async {
    try {
      final property = await _propertyService.fetchProperty(id);

      final propertyExists = state.any((p) => p.id == id);
      if (propertyExists) {
        state = state.map((p) => p.id == id ? property : p).toList();
      } else {
        state = [...state, property];
      }

      return property;
    } catch (e) {
      print('Error fetching property: $e');
      return null;
    }
  }

  // // Filter properties by location
  // List<Property> filterPropertiesByLocation(String location) {
  //   return state
  //       .where((property) =>
  //           property.location.toLowerCase().contains(location.toLowerCase()))
  //       .toList();
  // }

  // // Filter properties by price range
  // List<Property> filterPropertiesByPriceRange(
  //     double minPrice, double maxPrice) {
  //   return state
  //       .where((property) =>
  //           property.price >= minPrice && property.price <= maxPrice)
  //       .toList();
  // }
}

final propertyControllerProvider =
    StateNotifierProvider<PropertyController, List<Property>>((ref) {
  final propertyService = PropertyService();
  return PropertyController(propertyService);
});
