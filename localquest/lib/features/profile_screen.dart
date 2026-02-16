import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 4,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade600,
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text(
                'You',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Chip(
                label: const Text('Level 5'),
                backgroundColor: Colors.blue.shade100,
                avatar: Icon(Icons.star, color: Colors.amber.shade600),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildStatRow('Tasks Completed', '12', Colors.green.shade600),
                      const Divider(height: 24),
                      _buildStatRow('Achievements', '8', Colors.purple.shade600),
                      const Divider(height: 24),
                      _buildStatRow('Points', '450', Colors.orange.shade600),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18)),
        ),
      ],
    );
  }
}

