import 'package:flutter/material.dart';

import '../../../../domain/tournament.dart';
import '../petanque_format_label.dart';

class TournamentTile extends StatelessWidget {
  const TournamentTile({
    super.key,
    required this.tournament,
    required this.onOpen,
    required this.onDelete,
  });

  final Tournament tournament;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final location = tournament.location.isEmpty
        ? ''
        : ' • ${tournament.location}';

    return Card(
      child: ListTile(
        title: Text(tournament.name),
        subtitle: Text(
          '${tournament.format.label}'
          ' • ${tournament.rules.targetScore} points'
          '$location',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline),
                  SizedBox(width: 8),
                  Text('Supprimer'),
                ],
              ),
            ),
          ],
        ),
        onTap: onOpen,
      ),
    );
  }
}
