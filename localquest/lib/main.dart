import 'package:flutter/material.dart';
import 'features/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocalQuest (Proof of Concept)',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
