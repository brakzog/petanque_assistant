import 'dart:math' as math;
import 'dart:ui';

import '../services/petanque_detector.dart';
import 'detection_geometry.dart';
import 'ranked_ball.dart';

/// Orders boules from the closest to the farthest from the jack.
class BallRanker {
  const BallRanker({this.closeResultThreshold = 0.08});

  /// Relative gap between the first two boules under which the result is
  /// considered too close to call from the photo.
  final double closeResultThreshold;

  List<RankedBall> rank({
    required List<PetanqueDetection> detections,
    required List<Offset> manualBalls,
    required Offset jack,
    required Set<int> excludedIndices,
    required bool guidedCapture,
    required double imageAspectRatio,
  }) {
    final ranked = <RankedBall>[];

    // A manually added boule has no detector bbox/diameter. As soon as the
    // user corrects the set of boules, every candidate must therefore use
    // the same distance space; otherwise detector distances (normalised by
    // apparent diameter) and manual distances are not comparable.
    final usePointGeometry = guidedCapture || manualBalls.isNotEmpty;

    for (final entry in detections.asMap().entries) {
      final detection = entry.value;
      if (!detection.isBoule) continue;
      if (excludedIndices.contains(entry.key)) continue;

      ranked.add(
        RankedBall.detected(
          detectionIndex: entry.key,
          distance: usePointGeometry
              ? _guidedDistance(detection.center, jack, imageAspectRatio)
              : _estimatedDistance(detection, jack),
        ),
      );
    }

    for (final entry in manualBalls.asMap().entries) {
      ranked.add(
        RankedBall.manual(
          manualBallIndex: entry.key,
          distance: _guidedDistance(entry.value, jack, imageAspectRatio),
        ),
      );
    }

    ranked.sort((a, b) => a.distance.compareTo(b.distance));
    return ranked;
  }

  bool isCloseResult(List<RankedBall> ranking) {
    if (ranking.length < 2) return false;
    final first = ranking[0].distance;
    final second = ranking[1].distance;
    if (first <= 1e-9) return true;
    return (second - first).abs() / first < closeResultThreshold;
  }

  double _guidedDistance(
    Offset point,
    Offset jack,
    double imageAspectRatio,
  ) {
    final dx = (point.dx.clamp(0.0, 1.0) - jack.dx) * imageAspectRatio;
    final dy = point.dy.clamp(0.0, 1.0) - jack.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Galerie : l'inclinaison au déclenchement est inconnue. On utilise le
  /// point de contact au sol (bas-centre) et on normalise par le diamètre
  /// apparent pour compenser grossièrement la perspective.
  double _estimatedDistance(PetanqueDetection detection, Offset jack) {
    final groundPoint = Offset(
      detection.center.dx.clamp(0.0, 1.0),
      detection.bottom.clamp(0.0, 1.0),
    );
    final imageDistance = (groundPoint - jack).distance;
    return imageDistance / math.max(detection.apparentDiameter, 1e-6);
  }
}
