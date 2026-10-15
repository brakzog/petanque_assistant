import 'package:flutter/material.dart';

import '../../../../domain/player.dart';

/// A team being composed, with its players and a remove button for each.
class TeamSlotCard extends StatelessWidget {
  const TeamSlotCard({
    super.key,
    required this.name,
    required this.players,
    required this.capacity,
    required this.onRemove,
  });

  final String name;
  final List<Player> players;
  final int capacity;
  final ValueChanged<Player> onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('${players.length}/$capacity joueur(s)'),
            const SizedBox(height: 8),
            if (players.isEmpty)
              const Text('Aucun joueur')
            else
              for (final player in players)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    child: Text(player.name.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(player.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => onRemove(player),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
