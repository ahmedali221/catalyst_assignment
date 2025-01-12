import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final String label;
  final String status;

  const StatusWidget({Key? key, required this.status, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the status
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange; // Light orange
        break;
      case 'confirmed':
        statusColor = Colors.green; // Light green
        break;
      case 'cancelled':
        statusColor = Colors.red; // Light red
        break;
      default:
        statusColor = Colors.grey; // Light grey
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color:
                Colors.black87, // Slightly lighter black for better readability
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2), // Light background color
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: statusColor, // Use the same color for text
            ),
          ),
        ),
      ],
    );
  }
}
