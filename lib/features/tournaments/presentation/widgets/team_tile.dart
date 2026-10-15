import 'package:flutter/material.dart';

import '../../../../domain/team.dart';

class TeamTile extends StatelessWidget {
  const TeamTile({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.groups)),
        title: Text(team.name),
        subtitle: Text(team.players.map((player) => player.name).join(' + ')),
      ),
    );
  }
}
