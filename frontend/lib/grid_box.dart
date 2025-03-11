import 'package:flutter/material.dart';

class GridBox extends StatelessWidget {
  final String title;
  final String icon;

  const GridBox({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container( 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(color: Colors.black, fontSize: 20)),
            const SizedBox(height: 10),
            Image.asset(
              icon,
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}