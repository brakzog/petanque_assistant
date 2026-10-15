import 'package:flutter/material.dart';

/// Asks whether a tapped boule is a false positive. Returns true to ignore it.
Future<bool> confirmIgnoreDetection(BuildContext context) async {
  final ignore = await showModalBottomSheet<bool>(
    context: context,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Fausse détection ?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Si cet objet n’est pas une boule utile pour le point, vous pouvez l’ignorer. '
              'Le classement sera recalculé immédiatement.',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.visibility_off),
              label: const Text('Ignorer cette détection'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    ),
  );
  return ignore ?? false;
}
