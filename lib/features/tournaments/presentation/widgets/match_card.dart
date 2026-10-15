import 'package:flutter/material.dart';

import '../../../../domain/match.dart';
import '../../../../domain/team.dart';
import 'team_display.dart';

class MatchCard extends StatelessWidget {
  final Match match;

  final String teamALabel;
  final String teamBLabel;

  final String teamAPlayers;
  final String teamBPlayers;

  final Team? teamA;
  final Team? teamB;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.match,
    required this.teamALabel,
    required this.teamBLabel,
    required this.teamAPlayers,
    required this.teamBPlayers,
    required this.teamA,
    required this.teamB,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (match.isBye) {
      final teamName = match.teamAId != null ? teamALabel : teamBLabel;

      final players = match.teamAId != null ? teamAPlayers : teamBPlayers;

      return Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.fast_forward)),
          title: Text(teamName),
          subtitle: Text('$players\nExemptée — qualifiée automatiquement'),
          isThreeLine: true,
          trailing: const Icon(Icons.check_circle),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TeamDisplay(name: teamALabel, players: teamAPlayers),
                  ),
                  Text(
                    '${match.teamAScore}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),

              Row(
                children: [
                  Expanded(
                    child: TeamDisplay(name: teamBLabel, players: teamBPlayers),
                  ),
                  Text(
                    '${match.teamBScore}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  match.status == MatchStatus.finished
                      ? 'Match terminé'
                      : 'En ${match.targetScore} points',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
