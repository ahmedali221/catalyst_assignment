// BookingCard widget
import 'package:flutter/material.dart';

import '../../../models/booking.dart';
import '../../../views/Bookings/bookingDetailsPage.dart';
import '../../Constants.dart';
import '../StatusWidget.dart';
import '../imagesCarousel.dart';
import '../labeledTextWidget.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsPage(booking: booking),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // Property Images Carousel
              if (booking.property.images != null &&
                  booking.property.images!.isNotEmpty)
                ImageCarousel(images: booking.property.images!),
              // Booking ID and Status
              StatusWidget(
                  label: booking.property.name, status: booking.status),
              // Description
              LabeledText(
                  label: "Description", value: booking.property.description!),
              // Start Date
              LabeledText(label: "Location", value: booking.property.location),
              // Start Date
              LabeledText(
                label: "From",
                value: formatDateToDayMonth(booking.startDate),
              ),
              // End Date
              LabeledText(
                  label: "To", value: formatDateToDayMonth(booking.endDate))
            ],
          ),
        ),
      ),
    );
  }
}
