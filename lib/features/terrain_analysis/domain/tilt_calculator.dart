import 'dart:math' as math;

/// Angle between the phone and a horizontal plane, from gravity.
class TiltCalculator {
  const TiltCalculator();

  /// 0° when the phone lies perfectly flat (screen up or down), or null when
  /// the acceleration vector is degenerate.
  double? tiltDegrees(double x, double y, double z) {
    final magnitude = math.sqrt(x * x + y * y + z * z);
    if (magnitude < 1e-6) return null;

    // Téléphone écran vers le ciel / caméra arrière vers le terrain : z porte
    // presque toute la gravité lorsque le téléphone est parallèle au sol.
    final cosAngle = (z.abs() / magnitude).clamp(0.0, 1.0);
    return math.acos(cosAngle) * 180.0 / math.pi;
  }
}
