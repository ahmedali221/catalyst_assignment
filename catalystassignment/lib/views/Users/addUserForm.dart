import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:img_picker/img_picker.dart';
import '../../controllers/userController.dart';
import '../../models/user.dart';
import '../../utils/Custom Widgets/customInputWidget.dart';

class AddUserForm extends ConsumerStatefulWidget {
  const AddUserForm({super.key});

  @override
  ConsumerState<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends ConsumerState<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _profileImageController = TextEditingController();
  final _introVideoController = TextEditingController();
  String _selectedRole = 'owner'; // Default role

  // List of roles
  final List<String> roles = ['admin', 'owner', 'client'];
  File? _selectedImage, _selectedVideo; // To store the selected image file

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

// Function to pick a video from the gallery
  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _profileImageController.dispose();
    _introVideoController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        id: 0, // The ID will be assigned by the server
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        role: _selectedRole,
        profileImage: _selectedImage != null
            ? _selectedImage!.path
            : '', // Pass the image path as a string
        introVideo: _selectedVideo != null ? _selectedVideo!.path : '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Use the controller to add the user
      await ref.read(userControllerProvider.notifier).addUser(
            newUser,
            profileImage: _selectedImage, // Pass the selected image file
            profileVideo: _selectedVideo, // Pass the selected image file
          );

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('User added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.popUntil(context,
                    (route) => route.isFirst); // Navigate to the parent page
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                GestureDetector(
                  onTap: _pickImage, // Trigger image picker
                  child: Stack(
                    alignment: Alignment
                        .bottomRight, // Align the add icon to the bottom right
                    children: [
                      CircleAvatar(
                        radius: 50, // Adjust the size of the CircleAvatar
                        backgroundColor: Colors.grey[300], // Background color
                        child: _selectedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _selectedImage!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person, // Default person icon
                                size: 50,
                                color: Colors.grey,
                              ),
                      ),
                      // Add icon overlay
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.blue, // Background color for the add icon
                          shape: BoxShape.circle, // Make the container circular
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2, // Border width
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6), // Padding around the icon
                          child: Icon(
                            Icons.add_a_photo,
                            size: 20, // Size of the add icon
                            color: Colors.white, // Icon color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                CustomTextInputField(
                  controller: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),

                // Email Field
                CustomTextInputField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                // Phone Field
                CustomTextInputField(
                  controller: _phoneController,
                  labelText: 'Phone',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                // Role Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(Icons.work),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                  items: roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                ),

                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                    ),
                    child: ElevatedButton(
                      onPressed: _pickVideo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blueAccent, // Button background color
                        foregroundColor: Colors.white, // Text color

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                      ),
                      child: const Text(
                        'Pick Video',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // "Video Added" Text with Decoration
                if (_selectedVideo != null)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50, // Light green background
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                        border: Border.all(
                          color: Colors.green.shade300, // Border color
                          width: 2, // Border width
                        ),
                      ),
                      child: const Text(
                        'Video Added',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // Dark green text color
                        ),
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () async {
                    print('Submit button pressed'); // Debugging
                    await _submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
