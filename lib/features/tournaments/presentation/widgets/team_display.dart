import 'package:flutter/material.dart';

class TeamDisplay extends StatelessWidget {
  final String name;
  final String players;

  const TeamDisplay({super.key, required this.name, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (players.isNotEmpty)
          Text(players, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
