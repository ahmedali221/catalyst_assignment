import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/userController.dart';
import '../../models/user.dart';
import '../../utils/Custom Widgets/customInputWidget.dart';

class EditUserPage extends ConsumerStatefulWidget {
  final User user;

  const EditUserPage({super.key, required this.user});

  @override
  ConsumerState<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends ConsumerState<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.user.name);
  late final _emailController = TextEditingController(text: widget.user.email);
  late final _phoneController = TextEditingController(text: widget.user.phone);
  late final _profileImageController =
      TextEditingController(text: widget.user.profileImage);
  late final _introVideoController =
      TextEditingController(text: widget.user.introVideo);
  late String _selectedRole = widget.user.role;

  // List of roles
  final List<String> roles = ['admin', 'owner', 'client'];

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
      // Create an updated User object
      final updatedUser = User(
        id: widget.user.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        role: _selectedRole,
        profileImage: _profileImageController.text,
        introVideo: _introVideoController.text,
        createdAt: widget.user.createdAt,
        updatedAt: DateTime.now(),
      );

      // Update the user using the UserController
      try {
        await ref.read(userControllerProvider.notifier).updateUser(updatedUser);
        if (mounted) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('User updated successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context, widget.user); // Close the edit page
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          // Show error dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to update user: $e'),
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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
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
                  value: widget.user.role,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(Icons.work),
                    border: OutlineInputBorder(),
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

                // Profile Image Field
                CustomTextInputField(
                  controller: _profileImageController,
                  labelText: 'Profile Image URL',
                  hintText: 'Enter the URL of your profile image',
                  prefixIcon: Icons.image,
                ),

                // Intro Video Field
                CustomTextInputField(
                  controller: _introVideoController,
                  labelText: 'Intro Video URL',
                  hintText: 'Enter the URL of your intro video',
                  prefixIcon: Icons.video_library,
                ),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize:
                          isPortrait ? screenWidth * 0.04 : screenHeight * 0.03,
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
