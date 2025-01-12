import 'package:catalystassignment/views/Bookings/bookingListPage.dart';
import 'package:catalystassignment/views/Properties/propertyListPage.dart';
import 'package:catalystassignment/views/Users/userListPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/navigationController.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Watch the current page state
    final currentPage = ref.watch(navigationControllerProvider);

    // Determine the body based on the current page
    Widget body;
    switch (currentPage) {
      case AppPage.users:
        body = UserProfilePage();
        break;
      case AppPage.properties:
        body = PropertyListPage();
        break;
      case AppPage.bookings:
        body = BookingListPage();
        break;
    }

    return Scaffold(
      body: body, // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage.index,
        onTap: (index) {
          ref.read(navigationControllerProvider.notifier).setPage(
                AppPage.values[index],
              );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
        ],
      ),
    );
  }
}
