import 'package:flutter/material.dart';

/// Controls the human fallback used when the geometric ranking is wrong.
class RankingCorrectionControls extends StatelessWidget {
  const RankingCorrectionControls({
    super.key,
    required this.active,
    required this.selectedCount,
    required this.onStart,
    required this.onUndo,
    required this.onCancel,
    required this.onConfirm,
  });

  final bool active;
  final int selectedCount;
  final VoidCallback onStart;
  final VoidCallback onUndo;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    if (!active) {
      return OutlinedButton.icon(
        onPressed: onStart,
        icon: const Icon(Icons.swap_vert_circle_outlined),
        label: const Text('Corriger le classement'),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.touch_app),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Touchez les boules dans leur ordre réel : 1, puis 2, puis 3…',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (selectedCount > 0) ...[
              const SizedBox(height: 8),
              Text('$selectedCount boule(s) reclassée(s)'),
            ],
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: selectedCount == 0 ? null : onConfirm,
              icon: const Icon(Icons.check),
              label: const Text('Valider le classement'),
            ),
            if (selectedCount > 0)
              TextButton.icon(
                onPressed: onUndo,
                icon: const Icon(Icons.undo),
                label: const Text('Annuler le dernier choix'),
              ),
            TextButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.close),
              label: const Text('Annuler la correction'),
            ),
          ],
        ),
      ),
    );
  }
}
