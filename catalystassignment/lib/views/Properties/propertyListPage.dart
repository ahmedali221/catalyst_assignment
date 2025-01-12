import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalystassignment/utils/Constants.dart';
import 'package:catalystassignment/views/Properties/addPropertyPage.dart';
import 'package:catalystassignment/views/Properties/editPropertyPage.dart';
import 'package:catalystassignment/views/Properties/propertyDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/propertyController.dart';
import '../../../models/property.dart';
import '../../utils/Custom Widgets/Cards/propertyCard.dart';
import '../../utils/Custom Widgets/imagesCarousel.dart';

class PropertyListPage extends ConsumerStatefulWidget {
  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends ConsumerState<PropertyListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final propertiesState = ref.watch(propertyControllerProvider);

    // Filter properties based on the search query
    final searchQuery = _searchController.text.toLowerCase();
    final filteredProperties = searchQuery.isEmpty
        ? propertiesState
        : propertiesState.where((property) {
            return property.location.toLowerCase().contains(searchQuery) ==
                true;
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Properties',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPropertyPage(),
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
                hintText: 'Search by location',
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
      body: filteredProperties.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (searchQuery.isNotEmpty)
                    Text(
                      'No properties found matching your criteria.',
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
              itemCount: filteredProperties.length,
              itemBuilder: (context, index) {
                final property = filteredProperties[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.01,
                  ),
                  child: PropertyCard(property: property),
                );
              },
            ),
    );
  }
}
