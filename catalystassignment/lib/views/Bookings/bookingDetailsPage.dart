import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/bookingController.dart';
import '../../../models/booking.dart';
import '../../utils/Constants.dart';
import '../../utils/Custom Widgets/StatusWidget.dart';
import '../../utils/Custom Widgets/imagesCarousel.dart';
import '../../utils/Custom Widgets/labeledTextWidget.dart';
import '../../utils/Custom Widgets/userProfile.dart';
import 'bookingEditPage.dart';

class BookingDetailsPage extends ConsumerStatefulWidget {
  final Booking booking;

  const BookingDetailsPage({super.key, required this.booking});

  @override
  ConsumerState<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends ConsumerState<BookingDetailsPage> {
  late Booking _booking;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking; // Initialize with the passed booking
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
          _booking.property.name,
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: screenHeight * 0.02,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Carousel
            if (_booking.property.images != null &&
                _booking.property.images!.isNotEmpty)
              ImageCarousel(images: _booking.property.images!),

            // Booking Details Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                spacing: screenHeight * 0.02,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Details
                  Text(
                    'Booked by',
                    style: TextStyle(
                      fontSize: isPortrait
                          ? screenWidth * 0.05
                          : screenHeight * 0.04, // Dynamic font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  UserProfile(
                    name: _booking.user.name,
                    role: _booking.user.role,
                    profileImage: _booking.user.profileImage.toString(),
                  ),

                  // Divider
                  const Divider(thickness: 1),

                  // Booking Dates Section
                  Text(
                    'Booking Dates',
                    style: TextStyle(
                      fontSize: isPortrait
                          ? screenWidth * 0.05
                          : screenHeight * 0.04, // Dynamic font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  LabeledText(
                    label: 'Start Date',
                    value: formatDateToDayMonth(_booking.startDate),
                  ),
                  LabeledText(
                    label: 'End Date',
                    value: formatDateToDayMonth(_booking.endDate),
                  ),

                  // Divider
                  const Divider(thickness: 1),

                  // Property Details Section
                  Text(
                    'Property Details',
                    style: TextStyle(
                      fontSize: isPortrait
                          ? screenWidth * 0.05
                          : screenHeight * 0.04, // Dynamic font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  LabeledText(
                    label: 'Name',
                    value: _booking.property.name,
                  ),
                  LabeledText(
                    label: 'Location',
                    value: _booking.property.location,
                  ),
                  LabeledText(
                    label: 'Price',
                    value: '\$${_booking.property.price}',
                  ),

                  // Property Images Carousel
                  if (_booking.property.images != null &&
                      _booking.property.images!.isNotEmpty)
                    ImageCarousel(images: _booking.property.images!),

                  // Divider
                  const Divider(thickness: 1),

                  // Status Widget
                  StatusWidget(label: "Status", status: _booking.status),

                  // Edit and Delete Buttons
                  Center(
                    child: OverflowBar(
                      spacing: screenWidth * 0.04, // Dynamic spacing
                      children: [
                        // Edit Button
                        ElevatedButton(
                          onPressed: () async {
                            // Navigate to the edit booking page and wait for the result
                            final updatedBooking = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditBookingPage(booking: _booking),
                              ),
                            );

                            // If the result is not null, update the booking
                            if (updatedBooking != null) {
                              setState(() {
                                _booking = updatedBooking;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: isPortrait
                                  ? screenWidth * 0.04
                                  : screenHeight * 0.03, // Dynamic font size
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Delete Button
                        ElevatedButton(
                          onPressed: () async {
                            // Show a confirmation dialog before deleting
                            final confirmed = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Booking'),
                                content: const Text(
                                    'Are you sure you want to delete this booking?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            // If confirmed, delete the booking
                            if (confirmed == true) {
                              await ref
                                  .read(bookingControllerProvider.notifier)
                                  .deleteBooking(_booking.id);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Successful'),
                                  content: const Text(
                                      'Booking Deleted Successfully'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: isPortrait
                                  ? screenWidth * 0.04
                                  : screenHeight * 0.03, // Dynamic font size
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
