// lib/services/booking_service.dart
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/Constants.dart'; // Ensure you have a constant for the booking URL
import '../models/booking.dart';

class BookingService {
  // Fetch all bookings
  Future<List<Booking>> fetchBookingsList() async {
    try {
      final response = await http.get(Uri.parse(bookingsUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((bookingJson) => Booking.fromJson(bookingJson))
            .toList();
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load bookings: $e');
    }
  }

  // Fetch a single booking by ID
  Future<Booking> fetchBooking(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$bookingsUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bookingJson = json.decode(response.body);
        return Booking.fromJson(bookingJson);
      } else {
        throw Exception('Failed to fetch booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  // Add a new booking
  Future<void> addBooking(Booking booking) async {
    try {
      final payload = json.encode(booking.toJson());

      final response = await http.post(
        Uri.parse(bookingsUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: payload,
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add booking: $e');
    }
  }

  Future<void> updateBooking(Booking booking) async {
    try {
      // Encode the booking object to JSON
      final payload = json.encode(booking.toJson());
      print('Request Payload: $payload');

      // Make the API call to update the booking
      final response = await http.post(
        Uri.parse('$bookingsUrl/${booking.id}/status'),
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      // Handle the response
      if (response.statusCode != 200) {
        if (response.statusCode == 422) {
          // Handle validation errors
          final Map<String, dynamic> responseBody = json.decode(response.body);
          final errors = responseBody['errors']; // Extract validation errors
          if (errors != null) {
            throw Exception('Validation errors: $errors');
          } else {
            throw Exception('Validation errors: No error details found');
          }
        } else {
          // Handle other errors
          throw Exception('Failed to update booking: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  // Delete a booking
  Future<void> deleteBooking(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$bookingsUrl/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }
}
