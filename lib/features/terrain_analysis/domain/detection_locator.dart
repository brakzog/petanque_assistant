import 'dart:ui';

import '../services/petanque_detector.dart';
import 'detection_geometry.dart';

/// Finds detections from positions on the photo.
class DetectionLocator {
  const DetectionLocator();

  /// Center of the most confident cochonnet, if any.
  Offset? proposeJack(List<PetanqueDetection> detections) {
    final jacks = detections.where((d) => d.isCochonnet).toList()
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
    if (jacks.isEmpty) return null;

    final center = jacks.first.center;
    return Offset(center.dx.clamp(0.0, 1.0), center.dy.clamp(0.0, 1.0));
  }

  /// The boule detection the jack marker sits on, if the model mistook the
  /// cochonnet for a boule. Only one detection is returned, and only when the
  /// marker really falls on its box (with a small margin).
  int? findBallAtJack(List<PetanqueDetection> detections, Offset jack) {
    int? bestIndex;
    var bestDistance = double.infinity;

    for (final entry in detections.asMap().entries) {
      final detection = entry.value;
      if (!detection.isBoule) continue;
      if (!detection.containsWithMargin(jack, detection.maxSide * 0.15)) {
        continue;
      }

      final distance = (detection.center - jack).distance;
      if (distance < bestDistance) {
        bestDistance = distance;
        bestIndex = entry.key;
      }
    }
    return bestIndex;
  }

  /// The boule detection closest to a tap, ignoring [excludedIndices].
  int? findBallAt(
    List<PetanqueDetection> detections,
    Offset position, {
    Set<int> excludedIndices = const {},
  }) {
    int? bestIndex;
    var bestDistance = double.infinity;

    for (final entry in detections.asMap().entries) {
      if (excludedIndices.contains(entry.key)) continue;
      final detection = entry.value;
      if (!detection.isBoule) continue;

      final distance = (position - detection.center).distance;
      final inside = detection.containsWithMargin(position, 0);
      if (!inside && distance > detection.maxSide / 2 * 1.35) continue;

      if (distance < bestDistance) {
        bestDistance = distance;
        bestIndex = entry.key;
      }
    }
    return bestIndex;
  }
}
