import 'package:catalystassignment/views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Recommended approach

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue, // Set app bar background color
            titleTextStyle: TextStyle(
              color: Colors.white, // Set app bar title text color to white
              fontSize: 20, // Set app bar title font size
              fontWeight: FontWeight.bold, // Set app bar title font weight
            ),
            toolbarTextStyle: TextStyle(
              color: Colors.white, // Set app bar toolbar text color to white
              fontSize: 16, // Set app bar toolbar font size
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.white, // Set app bar action icons color to white
            ),
            iconTheme: IconThemeData(color: Colors.white)),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
