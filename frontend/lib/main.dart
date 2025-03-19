import 'package:flutter/material.dart';
import 'package:frontend/welcome_screen.dart';
import 'package:frontend/sign_in_page.dart'; // Import the sign-in page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/login', // Set the initial route
      routes: {
        '/login': (context) => const SignInPage(), // Define the login route
        '/welcome': (context) => WelcomeScreen(),
      },
    );
  }
}
