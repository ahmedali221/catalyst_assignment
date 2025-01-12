import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/property.dart';
import '../../controllers/propertyController.dart';
import '../../utils/Custom Widgets/customInputWidget.dart'; // Import the custom widget

class EditPropertyPage extends ConsumerStatefulWidget {
  final Property property;

  const EditPropertyPage({super.key, required this.property});

  @override
  ConsumerState<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends ConsumerState<EditPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.property.name);
  late final _descriptionController =
      TextEditingController(text: widget.property.description);
  late final _priceController =
      TextEditingController(text: widget.property.price); // Price as String
  late final _locationController =
      TextEditingController(text: widget.property.location);

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedProperty = Property(
          id: widget.property.id,
          userId: widget.property.userId,
          name: _nameController.text,
          description: _descriptionController.text,
          price: _priceController.text, // Keep as String
          location: _locationController.text,
          images: widget.property.images, // Keep original images
          video: widget.property.video, // Keep original video
          createdAt: widget.property.createdAt,
          updatedAt: widget.property.createdAt,
          user: widget.property.user,
        );

        await ref
            .read(propertyControllerProvider.notifier)
            .updateProperty(updatedProperty);

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Property updated successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context,
                      updatedProperty); // Close the edit page and return updated property
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to update property: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
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
          'Edit Property',
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: screenHeight * 0.02,
              children: [
                // Name Field
                CustomTextInputField(
                  controller: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter property name',
                  prefixIcon: Icons.home,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),

                // Description Field
                CustomTextInputField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText: 'Enter property description',
                  prefixIcon: Icons.description,
                ),

                // Price Field
                CustomTextInputField(
                  controller: _priceController,
                  labelText: 'Price',
                  hintText: 'Enter property price',
                  prefixIcon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),

                // Location Field
                CustomTextInputField(
                  controller: _locationController,
                  labelText: 'Location',
                  hintText: 'Enter property location',
                  prefixIcon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(double.infinity,
                        screenHeight * 0.06), // Dynamic button size
                  ),
                  child: Text(
                    'Update',
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
        ),
      ),
    );
  }
}
