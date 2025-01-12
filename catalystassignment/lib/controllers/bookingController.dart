// lib/controllers/booking_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking.dart';
import '../services/bookingServices.dart';

class BookingController extends StateNotifier<List<Booking>> {
  final BookingService _bookingService;

  BookingController(this._bookingService) : super([]) {
    fetchBookings();
  }

  // Fetch all bookings
  Future<void> fetchBookings() async {
    try {
      final bookings = await _bookingService.fetchBookingsList();
      state = bookings;
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  // Fetch a single booking by ID
  Future<Booking?> fetchBooking(int id) async {
    try {
      final booking = await _bookingService.fetchBooking(id);

      // Update the state if the booking already exists
      final bookingExists = state.any((b) => b.id == id);
      if (bookingExists) {
        state = state.map((b) => b.id == id ? booking : b).toList();
      } else {
        state = [...state, booking];
      }

      return booking;
    } catch (e) {
      print('Error fetching booking: $e');
      return null;
    }
  }

  // Add a new booking
  Future<void> addBooking(Booking booking) async {
    try {
      await _bookingService.addBooking(booking);
      state = [...state, booking]; // Add the new booking to the state
    } catch (e) {
      print('Error adding booking: $e');
    }
  }

  Future<void> updateBooking(Booking booking) async {
    try {
      // Call the service to update the booking
      await _bookingService.updateBooking(booking);

      // Update the booking in the state
      state = state
          .map((b) => b.id == booking.id
              ? booking
              : b) // Replace the old booking with the updated one
          .toList();
    } catch (e) {
      print('Error updating booking: $e');
    }
  }

  // Delete a booking
  Future<void> deleteBooking(int id) async {
    try {
      await _bookingService.deleteBooking(id);
      state = state
          .where((booking) => booking.id != id)
          .toList(); // Remove the booking from the state
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }

  // Filter bookings by status
  List<Booking> filterBookingsByStatus(String status) {
    return state.where((booking) => booking.status == status).toList();
  }
}

final bookingControllerProvider =
    StateNotifierProvider<BookingController, List<Booking>>((ref) {
  final bookingService = BookingService();
  return BookingController(bookingService);
});
