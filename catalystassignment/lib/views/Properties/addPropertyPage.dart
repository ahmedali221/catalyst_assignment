import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:img_picker/img_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../controllers/propertyController.dart';
import '../../controllers/userController.dart';
import '../../models/property.dart';
import '../../models/user.dart';
import '../../utils/Custom Widgets/customInputWidget.dart';

class AddPropertyPage extends ConsumerStatefulWidget {
  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends ConsumerState<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _numberOfImagesController = TextEditingController(); // New controller
  User? _selectedUser;
  List<File> _selectedImages = []; // List to store selected images
  bool _isUploading = false; // To track if the form is being submitted

  @override
  void initState() {
    super.initState();
    // Fetch users when the form is initialized
    ref.read(userControllerProvider.notifier).fetchUsers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _numberOfImagesController.dispose(); // Dispose the new controller
    super.dispose();
  }

  // Function to pick images based on the number specified by the user
  Future<void> _pickImages() async {
    final numberOfImages = int.tryParse(_numberOfImagesController.text);
    if (numberOfImages == null || numberOfImages <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number of images')),
      );
      return;
    }

    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      if (pickedFiles.length != numberOfImages) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please select exactly $numberOfImages images')),
        );
        return;
      }

      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a user')),
        );
        return;
      }

      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one image')),
        );
        return;
      }

      setState(() {
        _isUploading = true; // Start uploading
      });

      try {
        // Create the new property
        final newProperty = Property(
          id: 0,
          userId: _selectedUser!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          price: _priceController.text,
          location: _locationController.text,
          images: [], // Images will be handled by the service
          video: null, // Optional video field
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          user: _selectedUser,
        );

        // Call the controller to add the property
        await ref
            .read(propertyControllerProvider.notifier)
            .addProperty(newProperty, _selectedImages);

        // Show a success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Property added successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  // Navigator.popUntil(context,
                  //     (route) => route.isFirst); // Navigate to the parent page
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add property: $e')),
        );
      } finally {
        setState(() {
          _isUploading = false; // Stop uploading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Access the list of users from the controller
    final users = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Property',
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
              spacing: 10,
              children: [
                // User Dropdown
                DropdownButtonFormField<User>(
                  value: _selectedUser,
                  decoration: const InputDecoration(
                    labelText: 'User',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                  items: users.take(10).map((User user) {
                    return DropdownMenuItem<User>(
                      value: user,
                      child: Text(user.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUser = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a user';
                    }
                    return null;
                  },
                ),

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

                // Number of Images Field
                CustomTextInputField(
                  controller: _numberOfImagesController,
                  labelText: 'Number of Images',
                  hintText: 'Enter the number of images',
                  prefixIcon: Icons.image,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of images';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Please enter a valid number greater than 0';
                    }
                    return null;
                  },
                ),

                // Image Picker Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Property Images',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Image Picker Button
                    ElevatedButton(
                      onPressed: _pickImages,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.image, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Pick Images',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Display Selected Images
                    if (_selectedImages.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable scrolling
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of images per row
                          crossAxisSpacing: 10, // Spacing between columns
                          mainAxisSpacing: 10, // Spacing between rows
                          childAspectRatio: 1, // Square images
                        ),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              // Display Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedImages[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Remove Image Button
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages
                                          .removeAt(index); // Remove the image
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
                // Submit Button
                ElevatedButton(
                  onPressed: _isUploading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Add Property',
                          style: TextStyle(
                            fontSize: isPortrait
                                ? screenWidth * 0.04
                                : screenHeight * 0.03,
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
