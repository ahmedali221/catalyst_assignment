import 'package:catalystassignment/utils/Constants.dart';
import 'package:catalystassignment/utils/Custom%20Widgets/labeledTextWidget.dart';
import 'package:catalystassignment/views/Users/addUserForm.dart';
import 'package:catalystassignment/views/Users/userDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/userController.dart'; // Import the UserController
import '../../../models/user.dart';
import '../../providers/providers.dart';
import '../../utils/Custom Widgets/Cards/userCard.dart'; // Import the User model

class UserProfilePage extends ConsumerStatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
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

    final usersState = ref.watch(userControllerProvider);
    final userController = ref.read(userControllerProvider.notifier);

    final selectedRole = ref.watch(roleProvider);

    var filteredUsers = selectedRole == null || selectedRole == 'All'
        ? usersState // Show all users if no role is selected
        : userController.filterUsersByRole(selectedRole.toLowerCase());

    // Filter users based on the search query
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        return user.name.toLowerCase().contains(searchQuery) ||
            user.email.toLowerCase().contains(searchQuery) ||
            user.phone?.toLowerCase().contains(searchQuery) == true;
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profiles',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Dropdown menu for role filtering
          DropdownButton<String>(
            value: selectedRole,
            hint: const Text(
              'All',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.filter_list, color: Colors.white),
            dropdownColor: Colors.blueAccent,
            onChanged: (String? newValue) {
              // Update the selected role
              ref.read(roleProvider.notifier).state = newValue;
            },
            items: <String>[
              'All',
              'Admin',
              'Owner',
              'Client'
            ] // Add your roles here
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUserForm(),
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
                hintText: 'Search by name, email, or phone...',
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
      body: filteredUsers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (searchQuery.isNotEmpty || selectedRole != null)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: const Text(
                        'No users found matching your criteria.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    const CircularProgressIndicator(), // Show loading indicator
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.01,
              ),
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: UserCard(user: user),
                  );
                },
              ),
            ),
    );
  }
}
