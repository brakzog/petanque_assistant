import 'package:flutter/material.dart';

import 'warning_card.dart';

/// Tells whether the ranking uses the guided-capture geometry or the
/// gallery fallback.
class CaptureModeCard extends StatelessWidget {
  const CaptureModeCard({
    super.key,
    required this.guidedCapture,
    required this.tiltDegrees,
  });

  final bool guidedCapture;
  final double? tiltDegrees;

  @override
  Widget build(BuildContext context) {
    final tilt = tiltDegrees;
    if (!guidedCapture || tilt == null) {
      return const WarningCard(
        icon: Icons.photo_library_outlined,
        title: 'Photo de galerie',
        message:
            'L’inclinaison au déclenchement est inconnue : classement en mode estimé.',
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.screen_rotation_alt),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Prise guidée • inclinaison ${tilt.toStringAsFixed(1)}° • géométrie terrain activée',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
