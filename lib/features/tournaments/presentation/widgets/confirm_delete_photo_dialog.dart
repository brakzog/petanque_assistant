import 'package:flutter/material.dart';

/// Returns true when the user confirms the deletion.
Future<bool> confirmDeletePhoto(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Supprimer la photo ?'),
      content: const Text(
        'Cette photo de référence sera définitivement supprimée.',
      ),
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
