import 'package:flutter/material.dart';

class WinnerCard extends StatelessWidget {
  const WinnerCard({super.key, required this.winnerName});

  final String winnerName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.emoji_events, size: 40),
            const SizedBox(height: 8),
            Text('Victoire', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(winnerName),
          ],
        ),
      ),
    );
  }
}
