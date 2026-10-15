import 'package:flutter/material.dart';

import '../../../../domain/tournament.dart';
import '../../domain/bracket_view.dart';

class TournamentFinishedCard extends StatelessWidget {
  const TournamentFinishedCard({
    super.key,
    required this.bracket,
    required this.tournament,
  });

  final BracketView bracket;
  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final winner = bracket.winner;
    final finalMatch = bracket.finalMatch;

    if (winner == null || finalMatch == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tournoi terminé', style: textTheme.headlineSmall),
          const SizedBox(height: 4),
          const Text('Le tournoi est terminé.'),
        ],
      );
    }

    final winnerPlayers = bracket.playersLabel(winner.id);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.emoji_events, size: 56),
            const SizedBox(height: 12),
            Text(
              'TOURNOI TERMINÉ',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              winner.name,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'VAINQUEUR',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (winnerPlayers.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                winnerPlayers,
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Text('Finale', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '${bracket.teamLabel(finalMatch.teamAId)}  '
              '${finalMatch.teamAScore} - ${finalMatch.teamBScore}  '
              '${bracket.teamLabel(finalMatch.teamBId)}',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '${bracket.teams.length} équipes • '
              '${tournament.rules.targetScore} points',
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
