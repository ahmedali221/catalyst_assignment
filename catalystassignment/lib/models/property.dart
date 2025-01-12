import 'dart:convert';
import 'package:catalystassignment/models/user.dart';

class Property {
  final int id;
  final int userId;
  final String name;
  final String? description;
  final String price;
  final String location;
  final List<String>? images;
  final String? video;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user; // Make user optional

  Property({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.price,
    required this.location,
    this.images,
    this.video,
    required this.createdAt,
    required this.updatedAt,
    this.user, // Make user optional
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    // Base URL for images
    const String baseUrl =
        "https://test.catalystegy.com/"; // Replace with your actual base URL

    // Helper function to parse JSON-encoded images and prepend base URL
    List<String>? parseImages(dynamic images) {
      if (images == null) {
        return null;
      } else if (images is List) {
        return List<String>.from(
            images.map((item) => baseUrl + item.toString()));
      } else if (images is String) {
        try {
          final decoded = jsonDecode(images) as List;
          return List<String>.from(
              decoded.map((item) => baseUrl + item.toString()));
        } catch (e) {
          print('Error decoding images: $e');
          return null;
        }
      } else {
        throw FormatException('Invalid format for images field');
      }
    }

    return Property(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'],
      location: json['location'] as String,
      images: parseImages(json['images']),
      video: json['video'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : null, // Handle null user
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "name": name,
      "description": description,
      "price": price.toString(),
      "location": location,
      "images": jsonEncode(images),
      "video": video,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "user": {
        "id": user?.id,
        "name": user?.name,
        "email": user?.email,
        "phone": user?.phone,
        "role": user?.role,
        "profile_image": user?.profileImage, // Use profile_image
        "intro_video": user?.introVideo, // Use intro_video
        "created_at": user?.createdAt.toIso8601String(),
        "updated_at": user?.updatedAt.toIso8601String(),
      },
    };
  }
}
