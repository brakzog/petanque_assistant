import 'package:flutter/material.dart';

import '../../../../domain/team.dart';

class ScoreButtons extends StatelessWidget {
  final Team team;
  final ValueChanged<int> onScore;
  final int maxPoints;

  const ScoreButtons({
    super.key,
    required this.team,
    required this.onScore,
    required this.maxPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(team.name, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var points = 1; points <= maxPoints; points++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilledButton(
                    onPressed: () => onScore(points),
                    child: Text('+$points'),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
