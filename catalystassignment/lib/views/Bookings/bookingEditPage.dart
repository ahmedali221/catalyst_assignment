import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/bookingController.dart';
import '../../../models/booking.dart';

class EditBookingPage extends ConsumerStatefulWidget {
  final Booking booking;

  const EditBookingPage({super.key, required this.booking});

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends ConsumerState<EditBookingPage> {
  late String _status;

  @override
  void initState() {
    super.initState();
    // Initialize the status with the current booking status
    _status = widget.booking.status;
  }

  void _updateBooking() async {
    try {
      // Create the updated booking object with the new status
      final updatedBooking = Booking(
        id: widget.booking.id,
        userId: widget.booking.userId,
        propertyId: widget.booking.propertyId,
        startDate: widget.booking.startDate,
        endDate: widget.booking.endDate,
        status: _status.toLowerCase(),
        createdAt: widget.booking.createdAt,
        updatedAt: DateTime.now(),
        user: widget.booking.user,
        property: widget.booking.property,
      );

      // Call the controller to update the booking
      await ref
          .read(bookingControllerProvider.notifier)
          .updateBooking(updatedBooking);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking status updated successfully')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
      Navigator.pop(context, updatedBooking);
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update booking status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Booking Status',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isPortrait
                ? screenWidth * 0.05
                : screenHeight * 0.04, // Dynamic font size
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio buttons for status
            Text(
              'Select Status:',
              style: TextStyle(
                fontSize: isPortrait
                    ? screenWidth * 0.05
                    : screenHeight * 0.04, // Dynamic font size
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: Text(
                    'Pending',
                    style: TextStyle(
                      fontSize: isPortrait
                          ? screenWidth * 0.04
                          : screenHeight * 0.03, // Dynamic font size
                    ),
                  ),
                  value: 'Pending',
                  groupValue: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text(
                    'Cancelled',
                    style: TextStyle(
                      fontSize: isPortrait
                          ? screenWidth * 0.04
                          : screenHeight * 0.03, // Dynamic font size
                    ),
                  ),
                  value: 'Canceled',
                  groupValue: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text(
                    'Confirmed',
                    style: TextStyle(
                      fontSize: isPortrait
                          ? screenWidth * 0.04
                          : screenHeight * 0.03, // Dynamic font size
                    ),
                  ),
                  value: 'confirmed',
                  groupValue: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
              ],
            ),

            // Update Button
            Center(
              child: ElevatedButton(
                onPressed: _updateBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,

                  minimumSize: Size(double.infinity,
                      screenHeight * 0.06), // Dynamic button size
                ),
                child: Text(
                  'Update Status',
                  style: TextStyle(
                    fontSize: isPortrait
                        ? screenWidth * 0.04
                        : screenHeight * 0.03, // Dynamic font size
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
