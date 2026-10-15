import 'package:flutter/material.dart';

import '../../../../domain/team.dart';

class PlayoffTeamTile extends StatelessWidget {
  const PlayoffTeamTile({
    super.key,
    required this.team,
    required this.selected,
    required this.onToggle,
  });

  final Team team;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: selected,
        onChanged: (_) => onToggle(),
        title: Text(team.name),
        subtitle: Text(team.players.map((player) => player.name).join(' + ')),
        secondary: CircleAvatar(
          child: Text(team.name.replaceAll('Équipe ', '')),
        ),
      ),
    );
  }
}
