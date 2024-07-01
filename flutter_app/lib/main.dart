import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/register_screen.dart';
import 'firebase_options.dart'; // Import your Firebase initialization file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase(); // Call your Firebase initialization function
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterScreen(), // Example of navigating to the RegisterScreen
    );
  }
}
