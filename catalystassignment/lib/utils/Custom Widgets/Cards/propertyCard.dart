import 'package:flutter/material.dart';

import '../../../models/property.dart';
import '../../../views/Properties/propertyDetailsPage.dart';
import '../imagesCarousel.dart';

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsPage(property: property),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // In PropertyDetailsPage
            if (property.images != null && property.images!.isNotEmpty)
              ImageCarousel(images: property.images!),

            const SizedBox(height: 16),

            // Property Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Name and Price
                  Row(
                    children: [
                      // Property Name
                      Expanded(
                        child: Text(
                          property.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                          maxLines: 1, // Limit to one line
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Add spacing between name and price
                      // Property Price
                      Text(
                        '\$${property.price} / night',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),

                  // Property Location
                  Text(
                    property.location,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  // Divider
                  const Divider(thickness: 1),

                  // Host Details
                  const Text(
                    'Hosted by',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (property.user != null)
                    ListTile(
                      leading: ClipOval(
                        child: Image.network(
                          property.user!.profileImage!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: Text(
                        property.user!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        property.user!.role,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
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
