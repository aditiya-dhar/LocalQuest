import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardData = [
      {'rank': 1, 'name': 'You', 'points': 450, 'icon': Icons.star},
      {'rank': 2, 'name': 'Alex', 'points': 380, 'icon': Icons.person},
      {'rank': 3, 'name': 'Sam', 'points': 320, 'icon': Icons.person},
      {'rank': 4, 'name': 'Jordan', 'points': 280, 'icon': Icons.person},
      {'rank': 5, 'name': 'Morgan', 'points': 220, 'icon': Icons.person},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 4,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final user = leaderboardData[index];
          final rank = user['rank'] as int;
          final isFirst = rank == 1;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              elevation: isFirst ? 4 : 2,
              color: isFirst ? Colors.amber.shade50 : Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getRankColor(rank),
                  child: Text(
                    rank.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  user['name'] as String,
                  style: TextStyle(
                    fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                    fontSize: isFirst ? 16 : 14,
                  ),
                ),
                subtitle: Text('${user["points"]} pts',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing: isFirst
                    ? Icon(Icons.emoji_events, color: Colors.amber.shade600, size: 28)
                    : const Icon(Icons.trending_up, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber.shade600;
      case 2:
        return Colors.grey.shade500;
      case 3:
        return Colors.orange.shade700;
      default:
        return Colors.blue.shade600;
    }
  }
}

