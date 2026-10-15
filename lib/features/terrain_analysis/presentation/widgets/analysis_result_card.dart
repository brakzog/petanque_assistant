import 'package:flutter/material.dart';

import '../../domain/detection_geometry.dart';
import '../../services/petanque_detector.dart';

/// Detection counts and per-detection details, or progress / error.
class AnalysisResultCard extends StatelessWidget {
  const AnalysisResultCard({
    super.key,
    required this.analyzing,
    required this.error,
    required this.detections,
    required this.jackBallIndex,
    required this.ignoredIndices,
    required this.ballRanks,
  });

  final bool analyzing;
  final String? error;
  final List<PetanqueDetection> detections;
  final int? jackBallIndex;
  final Set<int> ignoredIndices;
  final Map<int, int> ballRanks;

  @override
  Widget build(BuildContext context) {
    if (analyzing) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Expanded(child: Text('Analyse de la photo en cours...')),
            ],
          ),
        ),
      );
    }

    final message = error;
    if (message != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SelectableText(message),
        ),
      );
    }

    final visible = detections
        .asMap()
        .entries
        .where((entry) => entry.key != jackBallIndex)
        .toList();
    final bouleCount = visible.where((entry) => entry.value.isBoule).length;
    final cochonnetCount = detections.where((d) => d.isCochonnet).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$bouleCount boule${bouleCount > 1 ? 's' : ''} '
              'détectée${bouleCount > 1 ? 's' : ''}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '$cochonnetCount cochonnet${cochonnetCount > 1 ? 's' : ''} '
              'détecté${cochonnetCount > 1 ? 's' : ''}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (detections.isEmpty) ...[
              const SizedBox(height: 12),
              const Text('Aucun objet détecté avec le seuil actuel.'),
            ] else ...[
              const SizedBox(height: 16),
              for (final entry in visible)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(_describe(entry.key, entry.value)),
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _describe(int index, PetanqueDetection detection) {
    final rank = ballRanks[index];
    final ignored = ignoredIndices.contains(index);
    return '${detection.label} — '
        '${(detection.confidence * 100).toStringAsFixed(1)} %'
        '${rank == null ? '' : ' • rang $rank'}'
        '${ignored ? ' • ignorée' : ''}';
  }
}
