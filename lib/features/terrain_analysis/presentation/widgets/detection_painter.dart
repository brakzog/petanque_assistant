import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/petanque_detector.dart';

class DetectionPainter extends CustomPainter {
  const DetectionPainter({
    required this.detections,
    required this.hiddenIndices,
    required this.jackPosition,
    required this.jackConfirmed,
    required this.ballRanks,
    required this.manualBalls,
    required this.manualBallRanks,
  });

  final List<PetanqueDetection> detections;

  /// Detections not drawn: ignored false positives and the jack itself.
  final Set<int> hiddenIndices;
  final Offset? jackPosition;
  final bool jackConfirmed;
  final Map<int, int> ballRanks;
  final List<Offset> manualBalls;
  final Map<int, int> manualBallRanks;

  @override
  void paint(Canvas canvas, Size size) {
    for (final entry in detections.asMap().entries) {
      if (hiddenIndices.contains(entry.key)) continue;

      final detection = entry.value;
      if (detection.type == PetanqueObjectType.cochonnet) continue;

      final rect = Rect.fromLTRB(
        detection.left * size.width,
        detection.top * size.height,
        detection.right * size.width,
        detection.bottom * size.height,
      );

      final rank = ballRanks[entry.key];
      final color = rank == null ? Colors.green.shade700 : _rankColor(rank);

      canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = rank == null ? 3 : 4
          ..color = color,
      );

      if (rank != null) {
        _drawRankBadge(canvas, size, rect, rank, color);
      }
    }

    for (final entry in manualBalls.asMap().entries) {
      final point = Offset(
        entry.value.dx * size.width,
        entry.value.dy * size.height,
      );
      final rank = manualBallRanks[entry.key];
      _drawManualBall(canvas, size, point, rank);
    }

    final jack = jackPosition;
    if (jack != null) {
      _drawJackMarker(
        canvas,
        Offset(jack.dx * size.width, jack.dy * size.height),
      );
    }
  }

  void _drawRankBadge(
    Canvas canvas,
    Size size,
    Rect rect,
    int rank,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$rank',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final diameter = math.max(textPainter.width, textPainter.height) + 12;
    final center = rect.center;
    final badgeCenter = Offset(
      center.dx.clamp(diameter / 2, size.width - diameter / 2),
      center.dy.clamp(diameter / 2, size.height - diameter / 2),
    );

    canvas.drawCircle(badgeCenter, diameter / 2, Paint()..color = color);
    canvas.drawCircle(
      badgeCenter,
      diameter / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white,
    );
    textPainter.paint(
      canvas,
      Offset(
        badgeCenter.dx - textPainter.width / 2,
        badgeCenter.dy - textPainter.height / 2,
      ),
    );
  }


  void _drawManualBall(Canvas canvas, Size size, Offset point, int? rank) {
    final color = rank == null ? Colors.cyan.shade700 : _rankColor(rank);
    const radius = 16.0;

    canvas.drawCircle(
      point,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = color,
    );
    canvas.drawCircle(
      point,
      3,
      Paint()..color = Colors.white,
    );

    if (rank == null) return;
    final rect = Rect.fromCircle(center: point, radius: radius);
    _drawRankBadge(canvas, size, rect, rank, color);
  }

  void _drawJackMarker(Canvas canvas, Offset point) {
    final color = jackConfirmed
        ? Colors.green.shade800
        : Colors.orange.shade800;
    const radius = 13.0;

    canvas.drawCircle(
      point,
      radius + 3,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white,
    );
    canvas.drawCircle(point, radius, Paint()..color = color);

    final linePaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.white;
    canvas.drawLine(
      Offset(point.dx - 20, point.dy),
      Offset(point.dx + 20, point.dy),
      linePaint,
    );
    canvas.drawLine(
      Offset(point.dx, point.dy - 20),
      Offset(point.dx, point.dy + 20),
      linePaint,
    );

    final tp = TextPainter(
      text: const TextSpan(
        text: 'C',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(point.dx - tp.width / 2, point.dy - tp.height / 2));
  }

  Color _rankColor(int rank) => switch (rank) {
    1 => Colors.red.shade700,
    2 => Colors.orange.shade700,
    3 => Colors.amber.shade800,
    _ => Colors.blueGrey.shade700,
  };

  @override
  bool shouldRepaint(covariant DetectionPainter oldDelegate) {
    return oldDelegate.detections != detections ||
        !setEquals(oldDelegate.hiddenIndices, hiddenIndices) ||
        oldDelegate.jackPosition != jackPosition ||
        oldDelegate.jackConfirmed != jackConfirmed ||
        !mapEquals(oldDelegate.ballRanks, ballRanks) ||
        !listEquals(oldDelegate.manualBalls, manualBalls) ||
        !mapEquals(oldDelegate.manualBallRanks, manualBallRanks);
  }
}
