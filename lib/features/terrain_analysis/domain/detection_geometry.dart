import 'dart:math' as math;
import 'dart:ui';

import '../services/petanque_detector.dart';

/// Geometric helpers on a detection, in normalized image coordinates.
extension DetectionGeometry on PetanqueDetection {
  bool get isBoule => type == PetanqueObjectType.boule;

  bool get isCochonnet => type == PetanqueObjectType.cochonnet;

  double get width => (right - left).abs();

  double get height => (bottom - top).abs();

  Offset get center => Offset((left + right) / 2, (top + bottom) / 2);

  double get maxSide => math.max(width, height);

  /// Geometric mean of the box sides, robust to slightly elongated boxes.
  double get apparentDiameter => math.sqrt(math.max(width * height, 1e-8));

  bool containsWithMargin(Offset point, double margin) {
    return point.dx >= left - margin &&
        point.dx <= right + margin &&
        point.dy >= top - margin &&
        point.dy <= bottom + margin;
  }
}
