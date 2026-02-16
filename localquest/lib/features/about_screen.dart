import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'LocalQuest (Proof of Concept)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(height: 12),
            Text(
              'This app is a proof-of-concept map application '
              'with tasks, friends, route planning, marker clustering, '
              'and polished UI interactions using Flutter and flutter_map.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Features:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('• Free map tile support (OpenStreetMap, Topo, Light)'),
            Text('• Marker clustering for tasks & friends'),
            Text('• Animated menus and popups'),
            Text('• Route planning to tasks'),
          ],
        ),
      ),
    );
  }
}
