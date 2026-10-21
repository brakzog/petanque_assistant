import 'package:flutter/material.dart';

/// Controls the explicit human fallback when the detector missed a boule.
class ManualBallControls extends StatelessWidget {
  const ManualBallControls({
    super.key,
    required this.adding,
    required this.manualBallCount,
    required this.onStartAdding,
    required this.onCancelAdding,
    required this.onUndoLast,
  });

  final bool adding;
  final int manualBallCount;
  final VoidCallback onStartAdding;
  final VoidCallback onCancelAdding;
  final VoidCallback onUndoLast;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (adding) ...[
              const Row(
                children: [
                  Icon(Icons.touch_app),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Touchez le centre de la boule manquante sur la photo.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onCancelAdding,
                icon: const Icon(Icons.close),
                label: const Text('Annuler l’ajout'),
              ),
            ] else ...[
              FilledButton.tonalIcon(
                onPressed: onStartAdding,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Ajouter une boule manquante'),
              ),
            ],
            if (manualBallCount > 0) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onUndoLast,
                icon: const Icon(Icons.undo),
                label: Text(
                  'Retirer la dernière boule ajoutée ($manualBallCount)',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
