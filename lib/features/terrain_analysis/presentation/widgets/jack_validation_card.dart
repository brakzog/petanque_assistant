import 'package:flutter/material.dart';

class JackValidationCard extends StatelessWidget {
  const JackValidationCard({
    super.key,
    required this.jackPosition,
    required this.jackConfirmed,
    required this.jackWasDetected,
    required this.onConfirm,
    required this.onReposition,
  });

  final Offset? jackPosition;
  final bool jackConfirmed;
  final bool jackWasDetected;
  final VoidCallback onConfirm;
  final VoidCallback onReposition;

  @override
  Widget build(BuildContext context) {
    if (jackPosition == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.touch_app),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Cochonnet non détecté. Zoomez si nécessaire puis touchez son centre sur la photo.',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (jackConfirmed) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle_outline),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Cochonnet confirmé',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onReposition,
                icon: const Icon(Icons.my_location),
                label: const Text('Repositionner le cochonnet'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              jackWasDetected
                  ? 'Cochonnet détecté : est-ce bien lui ?'
                  : 'Position manuelle du cochonnet',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              jackWasDetected
                  ? 'Vérifiez le viseur C sur la photo. Sinon, touchez directement le vrai cochonnet.'
                  : 'Vérifiez le viseur C. Vous pouvez retoucher la photo pour ajuster sa position.',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.check),
              label: const Text('Confirmer le cochonnet'),
            ),
          ],
        ),
      ),
    );
  }
}
