import 'package:catalystassignment/controllers/propertyController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/property.dart';
import '../../utils/Custom Widgets/imagesCarousel.dart';
import '../../utils/Custom Widgets/userProfile.dart';
import 'editPropertyPage.dart';

class PropertyDetailsPage extends ConsumerStatefulWidget {
  final Property property;

  const PropertyDetailsPage({Key? key, required this.property})
      : super(key: key);

  @override
  ConsumerState<PropertyDetailsPage> createState() =>
      _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends ConsumerState<PropertyDetailsPage> {
  late Property _property;

  @override
  void initState() {
    super.initState();
    _property = widget.property;
  }

  void _onEditComplete(Property updatedProperty) {
    setState(() {
      _property = updatedProperty;
    });
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
          _property.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isPortrait ? screenWidth * 0.05 : screenHeight * 0.04,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_property.images != null && _property.images!.isNotEmpty)
              ImageCarousel(images: _property.images!),

            // Property Details Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _property.name,
                          style: TextStyle(
                            fontSize: isPortrait
                                ? screenWidth * 0.06
                                : screenHeight * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${_property.price} ',
                        style: TextStyle(
                          fontSize: isPortrait
                              ? screenWidth * 0.05
                              : screenHeight * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),

                  // Property Location
                  Text(
                    _property.location,
                    style: TextStyle(
                      fontSize:
                          isPortrait ? screenWidth * 0.04 : screenHeight * 0.03,
                      color: Colors.grey,
                    ),
                  ),

                  // Divider
                  const Divider(thickness: 1),

                  // Host Details Section
                  Text(
                    'Hosted by',
                    style: TextStyle(
                      fontSize:
                          isPortrait ? screenWidth * 0.05 : screenHeight * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_property.user != null)
                    UserProfile(
                      name: _property.user!.name,
                      role: _property.user!.role,
                      profileImage: _property.user!.profileImage.toString(),
                    ),

                  // Divider
                  const Divider(thickness: 1),

                  // Property Description
                  Text(
                    'About this property',
                    style: TextStyle(
                      fontSize:
                          isPortrait ? screenWidth * 0.05 : screenHeight * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _property.description ?? 'No description available',
                    style: TextStyle(
                      fontSize:
                          isPortrait ? screenWidth * 0.04 : screenHeight * 0.03,
                      color: Colors.black87,
                    ),
                  ),

                  // Divider
                  const Divider(thickness: 1),

                  // Amenities Section
                  Text(
                    'What this place offers',
                    style: TextStyle(
                      fontSize:
                          isPortrait ? screenWidth * 0.05 : screenHeight * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildAmenity('Wi-Fi', Icons.wifi),
                      _buildAmenity('Kitchen', Icons.kitchen),
                      _buildAmenity('Parking', Icons.local_parking),
                      _buildAmenity('Pool', Icons.pool),
                      _buildAmenity('Air Conditioning', Icons.ac_unit),
                      _buildAmenity('TV', Icons.tv),
                    ],
                  ),

                  // Divider
                  const Divider(thickness: 1),

                  // Edit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Navigate to EditPropertyPage and wait for the result
                        final updatedProperty = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditPropertyPage(property: _property),
                          ),
                        );

                        // If the result is not null, update the property
                        if (updatedProperty != null) {
                          _onEditComplete(updatedProperty);
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
                              : screenHeight * 0.03,
                          color: Colors.white,
                        ),
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

  // Helper method to build an amenity widget
  Widget _buildAmenity(String title, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.blueAccent),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
