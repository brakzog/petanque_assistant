import 'package:flutter/material.dart';

import '../../domain/bracket_view.dart';

/// Shown when tied teams must play a repechage playoff.
class PlayoffRequiredCard extends StatelessWidget {
  const PlayoffRequiredCard({
    super.key,
    required this.bracket,
    required this.onResolve,
  });

  final BracketView bracket;

  /// Null disables the button.
  final VoidCallback? onResolve;

  @override
  Widget build(BuildContext context) {
    final progression = bracket.progression!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Barrage de repêchage nécessaire',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${progression.playoffTeamIds.length} '
              'équipes sont à égalité pour '
              '${progression.playoffQualificationSlots} '
              'place(s).',
            ),
            const SizedBox(height: 12),
            for (final teamId in progression.playoffTeamIds)
              Text('• ${bracket.teamLabel(teamId)}'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onResolve,
              icon: const Icon(Icons.sports_score),
              label: const Text('Résoudre le barrage'),
            ),
          ],
        ),
      ),
    );
  }
}
