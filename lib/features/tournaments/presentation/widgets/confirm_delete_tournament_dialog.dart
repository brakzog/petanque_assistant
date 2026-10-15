import 'package:flutter/material.dart';

import '../../../../domain/tournament.dart';

/// Returns true when the user confirms the deletion.
Future<bool> confirmDeleteTournament(
  BuildContext context,
  Tournament tournament,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Supprimer le tournoi'),
      content: Text('Supprimer définitivement "${tournament.name}" ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Supprimer'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
