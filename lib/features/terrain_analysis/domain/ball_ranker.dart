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
    required Offset jack,
    required Set<int> excludedIndices,
    required bool guidedCapture,
    required double imageAspectRatio,
  }) {
    final ranked = <RankedBall>[];

    for (final entry in detections.asMap().entries) {
      final detection = entry.value;
      if (!detection.isBoule) continue;
      if (excludedIndices.contains(entry.key)) continue;

      ranked.add(
        RankedBall(
          detectionIndex: entry.key,
          distance: guidedCapture
              ? _guidedDistance(detection, jack, imageAspectRatio)
              : _estimatedDistance(detection, jack),
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

  /// La caméra guidée n'autorise la prise que téléphone quasi parallèle au
  /// terrain : le plan image est alors quasi parallèle au sol, et une distance
  /// 2D corrigée du ratio de l'image conserve l'ordre des distances réelles.
  double _guidedDistance(
    PetanqueDetection detection,
    Offset jack,
    double imageAspectRatio,
  ) {
    final center = detection.center;
    final dx = (center.dx.clamp(0.0, 1.0) - jack.dx) * imageAspectRatio;
    final dy = center.dy.clamp(0.0, 1.0) - jack.dy;
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
