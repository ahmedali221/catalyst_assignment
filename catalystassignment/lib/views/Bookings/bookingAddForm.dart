import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/bookingController.dart';
import '../../controllers/propertyController.dart';
import '../../controllers/userController.dart';
import '../../models/booking.dart';
import '../../models/user.dart';
import '../../models/property.dart';
import '../../utils/Custom Widgets/customInputWidget.dart';

class BookingAddForm extends ConsumerStatefulWidget {
  const BookingAddForm({super.key});

  @override
  ConsumerState<BookingAddForm> createState() => _BookingAddFormState();
}

class _BookingAddFormState extends ConsumerState<BookingAddForm> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  User? _selectedUser;
  Property? _selectedProperty;

  @override
  void initState() {
    super.initState();
    // Fetch users and properties when the form is initialized
    ref.read(userControllerProvider.notifier).fetchUsers();
    ref.read(propertyControllerProvider.notifier).fetchProperties();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // Function to show date picker and update the text controller
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedUser == null || _selectedProperty == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a user and property')),
        );
        return;
      }

      final newBooking = Booking(
        id: 0, // The ID will be assigned by the server
        propertyId: _selectedProperty!.id,
        userId: _selectedUser!.id,
        startDate: DateTime.parse(_startDateController.text),
        endDate: DateTime.parse(_endDateController.text),
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        property: _selectedProperty!, // Add selected property
        user: _selectedUser!, // Add selected user
      );

      try {
        await ref
            .read(bookingControllerProvider.notifier)
            .addBooking(newBooking);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Booking added successfully!'),
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
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add booking: $e')),
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

    // Access the lists of users and properties from the controllers
    final users = ref.watch(userControllerProvider);
    final properties = ref.watch(propertyControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Booking'),
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

                // Property Dropdown
                DropdownButtonFormField<Property>(
                  value: _selectedProperty,
                  decoration: const InputDecoration(
                    labelText: 'Property',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                  items: properties.take(10).map((Property property) {
                    return DropdownMenuItem<Property>(
                      value: property,
                      child: Text(property.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProperty = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a property';
                    }
                    return null;
                  },
                ),

                // Start Date Field with Date Picker
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  readOnly: true, // Prevent manual editing
                  onTap: () => _selectDate(context, _startDateController),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a start date';
                    }
                    return null;
                  },
                ),

                // End Date Field with Date Picker
                TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  readOnly: true, // Prevent manual editing
                  onTap: () => _selectDate(context, _endDateController),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an end date';
                    }
                    return null;
                  },
                ),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                  ),
                  child: Text(
                    'Add Booking',
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
