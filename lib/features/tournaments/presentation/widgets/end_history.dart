import 'package:flutter/material.dart';

import '../../../../domain/end.dart';

/// Ends from the latest to the first.
class EndHistory extends StatelessWidget {
  const EndHistory({super.key, required this.ends, required this.teamName});

  final List<End> ends;
  final String Function(String teamId) teamName;

  @override
  Widget build(BuildContext context) {
    if (ends.isEmpty) {
      return const Text('Aucune mène enregistrée.');
    }

    return Column(
      children: [
        for (final end in ends.reversed)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Text('${end.number}')),
            title: Text(teamName(end.scoringTeamId)),
            trailing: Text(
              '+${end.points}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }
}
