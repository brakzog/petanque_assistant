import 'package:flutter/material.dart';

import '../../../../domain/player.dart';
import '../../domain/team_assignment.dart';

/// A player with a dropdown to choose their team.
class PlayerAssignmentTile extends StatelessWidget {
  const PlayerAssignmentTile({
    super.key,
    required this.player,
    required this.team,
    required this.teamCount,
    required this.onChanged,
  });

  final Player player;
  final int? team;
  final int teamCount;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final current = team;

    return Card(
      child: ListTile(
        title: Text(player.name),
        subtitle: Text(
          current == null ? 'Non affecté' : TeamAssignment.teamName(current),
        ),
        trailing: DropdownButton<int?>(
          value: current,
          hint: const Text('Équipe'),
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('Aucune')),
            for (var index = 0; index < teamCount; index++)
              DropdownMenuItem<int?>(
                value: index,
                child: Text(TeamAssignment.teamName(index)),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
