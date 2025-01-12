import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalystassignment/utils/Constants.dart';
import 'package:catalystassignment/utils/Custom%20Widgets/labeledTextWidget.dart';
import 'package:catalystassignment/views/Bookings/bookingDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/bookingController.dart'; // Import the BookingController
import '../../../models/booking.dart';
import '../../providers/providers.dart';
import '../../utils/Custom Widgets/Cards/bookingCard.dart';
import '../../utils/Custom Widgets/StatusWidget.dart';
import '../../utils/Custom Widgets/imagesCarousel.dart';
import 'bookingAddForm.dart';
import 'bookingEditPage.dart'; // Import the Booking model

class BookingListPage extends ConsumerStatefulWidget {
  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends ConsumerState<BookingListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch bookings when the page is loaded
    ref.read(bookingControllerProvider.notifier).fetchBookings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to delete a booking
  void _deleteBooking(int id) async {
    try {
      final bookingController = ref.read(bookingControllerProvider.notifier);
      await bookingController.deleteBooking(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking $id deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final bookingsState = ref.watch(bookingControllerProvider);
    final bookingController = ref.read(bookingControllerProvider.notifier);

    final selectedStatus = ref.watch(statusProvider);

    var filteredBookings = selectedStatus == null || selectedStatus == 'All'
        ? bookingsState // Show all bookings if no status is selected
        : bookingController
            .filterBookingsByStatus(selectedStatus.toLowerCase());

    // Filter bookings based on the search query
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filteredBookings = filteredBookings.where((booking) {
        return booking.id.toString().contains(searchQuery) ||
            booking.status.toLowerCase().contains(searchQuery);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookings',
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
        actions: [
          // Dropdown menu for status filtering
          DropdownButton<String>(
            value: selectedStatus,
            hint: const Text(
              'All',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onChanged: (String? newValue) {
              ref.read(statusProvider.notifier).state = newValue;
            },
            dropdownColor: Colors.blueAccent,
            items: <String>[
              'All',
              'Pending',
              'Confirmed',
              'Canceled'
            ] // Add your statuses here
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: const TextStyle(
                        color: Colors
                            .white) // Set dropdown item text color to white
                    ),
              );
            }).toList(),
          ),

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to the add booking page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingAddForm(),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.08), // Dynamic height
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.01,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by ID or status...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                // Rebuild the UI when the search query changes
                setState(() {});
              },
            ),
          ),
        ),
      ),
      body: filteredBookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (searchQuery.isNotEmpty || selectedStatus != null)
                    Text(
                      'No bookings found matching your criteria.',
                      style: TextStyle(
                        fontSize: isPortrait
                            ? screenWidth * 0.04
                            : screenHeight * 0.03, // Dynamic font size
                      ),
                    )
                  else
                    const CircularProgressIndicator(), // Show loading indicator
                ],
              ),
            )
          : ListView.builder(
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = filteredBookings[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.01,
                  ),
                  child: BookingCard(booking: booking),
                );
              },
            ),
    );
  }
}
