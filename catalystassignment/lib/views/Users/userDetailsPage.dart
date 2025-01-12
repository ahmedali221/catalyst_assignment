import 'package:catalystassignment/utils/Custom%20Widgets/labeledTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user.dart';
import '../../controllers/userController.dart';
import 'userUpdateForm.dart';

class UserDetailsPage extends ConsumerStatefulWidget {
  final User user;

  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends ConsumerState<UserDetailsPage> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user; // Initialize with the passed user
  }

  // Helper method to get role color
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.redAccent; // Admin role color
      case 'owner':
        return Colors.teal; // Custom green color for Owner
      case 'client':
        return Colors.blueAccent; // Client role color
      default:
        return Colors.grey; // Default color for unknown roles
    }
  }

  // Helper method to capitalize the first letter of the role
  String _capitalizeRole(String role) {
    if (role.isEmpty) return role;
    return role[0].toUpperCase() + role.substring(1);
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
          _user.name,
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image and User Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  if (_user.profileImage != null)
                    ClipOval(
                      child: Image.network(
                        _user.profileImage!.toString(),
                        width: isPortrait
                            ? screenWidth * 0.3
                            : screenWidth * 0.2, // Dynamic width
                        height: isPortrait
                            ? screenWidth * 0.3
                            : screenWidth * 0.2, // Dynamic height
                        fit: BoxFit.contain,
                      ),
                    ),
                  SizedBox(
                      width: screenWidth *
                          0.04), // Spacing between image and details

                  // User Details
                  Expanded(
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Name and Role
                        Text(
                          _user.name,
                          style: TextStyle(
                            fontSize: isPortrait
                                ? screenWidth * 0.06
                                : screenHeight * 0.05, // Dynamic font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getRoleColor(_user.role).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _capitalizeRole(_user.role), // Capitalize role
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getRoleColor(_user.role),
                            ),
                          ),
                        ),

                        // User Email
                        LabeledText(label: "Email", value: _user.email),

                        // User Phone
                        LabeledText(
                            label: "Phone", value: _user.phone ?? 'N/A'),
                      ],
                    ),
                  ),
                ],
              ),

              // Divider
              const Divider(thickness: 1),

              // Edit and Delete Buttons
              Center(
                child: OverflowBar(
                  spacing: screenWidth * 0.04, // Dynamic spacing
                  children: [
                    // Edit Button
                    ElevatedButton(
                      onPressed: () async {
                        // Navigate to the edit user page and wait for the result
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserPage(user: _user),
                          ),
                        );

                        // If the result is not null, update the user
                        if (updatedUser != null) {
                          setState(() {
                            _user = updatedUser;
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
                            title: const Text('Delete User'),
                            content: const Text(
                                'Are you sure you want to delete this user?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        // If confirmed, delete the user
                        if (confirmed == true) {
                          await ref
                              .read(userControllerProvider.notifier)
                              .deleteUser(_user.id);

                          // Show success dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Success'),
                              content: const Text('User deleted successfully!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                  child: const Text('OK'),
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
      ),
    );
  }
}
