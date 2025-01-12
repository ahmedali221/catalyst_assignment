import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/Constants.dart'; // Assuming you have a constant for the property URL
import '../models/property.dart';

class PropertyService {
  // Fetch all properties
  Future<List<Property>> fetchProperties() async {
    try {
      final response = await http.get(Uri.parse(propertiesUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((propertyJson) => Property.fromJson(propertyJson))
            .toList();
      } else {
        throw Exception('Failed to load properties: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load properties: $e');
    }
  }

  Future<void> addProperty(Property property, List<File> images) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(propertiesUrl));

      request.fields['user_id'] = property.userId.toString();
      request.fields['name'] = property.name;
      request.fields['description'] = property.description!;
      request.fields['price'] = property.price;
      request.fields['location'] = property.location;

      List<String> imageUrls = [];
      for (var i = 0; i < images.length; i++) {
        var filename = '${DateTime.now().millisecondsSinceEpoch}_$i.png';
        var imageUrl = 'property_images/$filename';
        print('Generated Image URL: $imageUrl');
        imageUrls.add(imageUrl);

        // Add the image file to the request
        request.files.add(
          await http.MultipartFile.fromPath(
            'images', // Field name for images
            images[i].path,
            filename: filename,
          ),
        );
      }

      final encodedImageUrls = imageUrls
          .map((url) => '"${url.replaceAll('/', '\\/')}"')
          .toList()
          .toString();
      print('Encoded Image URLs: $encodedImageUrls');

      request.fields['images'] = encodedImageUrls;

      final response = await request.send();

      if (response.statusCode == 201) {
        print('Property added successfully');
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to add property: $responseBody');
      }
    } catch (e) {
      throw Exception('Failed to add property: $e');
    }
  }

  Future<void> updateProp(Property prop) async {
    try {
      final payload = json.encode({
        'name': prop.name,
        'description': prop.description,
        'price': prop.price,
        'location': prop.location,
      });

      final response = await http.post(
        Uri.parse('$propertiesUrl/${prop.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: payload,
      );

      // Handle redirects
      if (response.statusCode == 302) {
        final redirectUrl = response.headers['Location'];
        if (redirectUrl != null) {
          print('Redirecting to: $redirectUrl');
          final redirectResponse = await http.post(
            Uri.parse(redirectUrl),
            headers: {
              'Content-Type': 'application/json',
              // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Add this if required
            },
            body: payload,
          );
          print(
              'Redirect Response Status Code: ${redirectResponse.statusCode}');
          print('Redirect Response Body: ${redirectResponse.body}');

          if (redirectResponse.statusCode != 200) {
            throw Exception(
                'Failed to update property after redirect: ${redirectResponse.statusCode}');
          }
          return;
        }
      }

      // Handle other status codes
      if (response.statusCode != 200) {
        if (response.statusCode == 422) {
          final errors = json.decode(response.body)['errors'];
          throw Exception('Validation errors: $errors');
        } else {
          throw Exception('Failed to update property: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Failed to update property: $e');
    }
  }

  // Delete a property
  Future<void> deleteProperty(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$propertiesUrl/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete property: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete property: $e');
    }
  }

  // Fetch a single property by ID
  Future<Property> fetchProperty(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$propertiesUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> propertyJson = json.decode(response.body);
        return Property.fromJson(propertyJson);
      } else {
        throw Exception('Failed to fetch property: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch property: $e');
    }
  }
}
