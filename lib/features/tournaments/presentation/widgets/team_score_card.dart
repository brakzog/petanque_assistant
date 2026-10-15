import 'package:flutter/material.dart';

import '../../../../domain/team.dart';

class TeamScoreCard extends StatelessWidget {
  final Team team;
  final String players;
  final int score;

  const TeamScoreCard({
    super.key,
    required this.team,
    required this.players,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(players),
                ],
              ),
            ),
            Text('$score', style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
      ),
    );
  }
}
