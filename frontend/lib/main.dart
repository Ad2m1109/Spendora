import 'package:flutter/material.dart';
import 'package:frontend/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,  // ✅ Removes debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: WelcomeScreen(),
      routes: {
        '/welcome': (context) => WelcomeScreen(), // Example of named route
      },
    );
  }
}
