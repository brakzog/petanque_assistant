import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/features/terrain_analysis/domain/ball_ranker.dart';
import 'package:tournoi_de_petanque/features/terrain_analysis/domain/ranked_ball.dart';
import 'package:tournoi_de_petanque/features/terrain_analysis/services/petanque_detector.dart';

PetanqueDetection boule(double cx, double cy, {double size = 0.05}) {
  return PetanqueDetection(
    type: PetanqueObjectType.boule,
    confidence: 0.9,
    left: cx - size / 2,
    top: cy - size / 2,
    right: cx + size / 2,
    bottom: cy + size / 2,
  );
}

void main() {
  const ranker = BallRanker();
  const jack = Offset(0.5, 0.5);

  test('ranks boules from the closest to the farthest in guided mode', () {
    final ranking = ranker.rank(
      detections: [boule(0.8, 0.5), boule(0.55, 0.5), boule(0.5, 0.7)],
      jack: jack,
      excludedIndices: const {},
      guidedCapture: true,
      imageAspectRatio: 1.0,
    );

    expect(ranking.map((r) => r.detectionIndex), [1, 2, 0]);
  });

  test('skips excluded detections and cochonnets', () {
    final ranking = ranker.rank(
      detections: [
        boule(0.55, 0.5),
        const PetanqueDetection(
          type: PetanqueObjectType.cochonnet,
          confidence: 0.9,
          left: 0.49,
          top: 0.49,
          right: 0.51,
          bottom: 0.51,
        ),
        boule(0.7, 0.5),
      ],
      jack: jack,
      excludedIndices: const {0},
      guidedCapture: true,
      imageAspectRatio: 1.0,
    );

    expect(ranking.map((r) => r.detectionIndex), [2]);
  });

  test('applies the aspect ratio to horizontal distances', () {
    // In a 2:1 image, 0.1 horizontally is as far as 0.2 vertically.
    final ranking = ranker.rank(
      detections: [boule(0.65, 0.5), boule(0.5, 0.75)],
      jack: jack,
      excludedIndices: const {},
      guidedCapture: true,
      imageAspectRatio: 2.0,
    );

    expect(ranking.map((r) => r.detectionIndex), [1, 0]);
  });

  test('flags a close result when the first two are within 8%', () {
    const close = [
      RankedBall(detectionIndex: 0, distance: 1.0),
      RankedBall(detectionIndex: 1, distance: 1.05),
    ];
    const clear = [
      RankedBall(detectionIndex: 0, distance: 1.0),
      RankedBall(detectionIndex: 1, distance: 1.5),
    ];

    expect(ranker.isCloseResult(close), isTrue);
    expect(ranker.isCloseResult(clear), isFalse);
  });
}
