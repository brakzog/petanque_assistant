import 'package:flutter/material.dart';

import '../../../../domain/player.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
    required this.player,
    required this.ballDescription,
    required this.onOpenBalls,
    required this.onDelete,
  });

  final Player player;
  final String ballDescription;
  final VoidCallback onOpenBalls;

  /// Null disables deletion.
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onOpenBalls,
        leading: CircleAvatar(
          child: Text(player.name.substring(0, 1).toUpperCase()),
        ),
        title: Text(player.name),
        subtitle: Text(ballDescription),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Configurer les boules',
              icon: const Icon(Icons.sports),
              onPressed: onOpenBalls,
            ),
            IconButton(
              tooltip: 'Supprimer',
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
