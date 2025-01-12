import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String name;
  final String role;
  final String? profileImage;

  const UserProfile({
    Key? key,
    required this.name,
    required this.role,
    this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: profileImage != null
            ? Image.network(
                profileImage!,
                width: 75,
                height: 75,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  );
                },
              )
            : const Icon(
                Icons.person,
                size: 50,
                color: Colors.grey,
              ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        role,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }
}
