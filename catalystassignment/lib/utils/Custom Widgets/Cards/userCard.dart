import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../views/Users/userDetailsPage.dart';
import '../labeledTextWidget.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

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
  String _capitalizeFirstLetter(String role) {
    if (role.isEmpty) return role;
    return role[0].toUpperCase() + role.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsPage(user: user),
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
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container for CircleAvatar
              Container(
                width: 100, // Fixed width for the container
                height: 100, // Fixed height for the container
                alignment: Alignment.center,
                child: ClipOval(
                  child: user.profileImage != null
                      ? Image.network(user.profileImage!)
                      : Icon(Icons.person),
                ),
              ),

              // User Details
              Expanded(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis, // Handle overflow
                            maxLines: 1, // Limit to one line
                          ),
                        ),
                        // User Role with dynamic color and capitalized text
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getRoleColor(user.role).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _capitalizeFirstLetter(
                                user.role), // Capitalize role
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getRoleColor(user.role),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // User Email
                    LabeledText(label: "Email", value: user.email),

                    // User Phone
                    LabeledText(label: "Phone", value: user.phone ?? 'N/A'),
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
