import 'property.dart';
import 'user.dart';

class Booking {
  final int id;
  final int userId;
  final int propertyId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user; // User is required
  final Property property; // Property is required

  Booking({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.property,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      propertyId: json['property_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']), // User is required
      property: Property.fromJson(json['property']), // Property is required
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'property_id': propertyId,
      'start_date':
          startDate.toIso8601String(), // Convert DateTime to ISO 8601 string
      'end_date':
          endDate.toIso8601String(), // Convert DateTime to ISO 8601 string
      'status': status,
      'created_at':
          createdAt.toIso8601String(), // Convert DateTime to ISO 8601 string
      'updated_at':
          updatedAt.toIso8601String(), // Convert DateTime to ISO 8601 string
      'user': user.toJson(),
      'property': property.toJson(),
    };
  }
}
