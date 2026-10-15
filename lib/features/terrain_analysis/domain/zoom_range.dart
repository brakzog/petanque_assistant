/// Zoom levels supported by the camera.
class ZoomRange {
  const ZoomRange({required this.min, required this.max});

  final double min;
  final double max;

  /// Zoom for a pinch gesture of [scale] started at [startLevel].
  double forPinch(double startLevel, double scale) {
    return (startLevel * scale).clamp(min, max).toDouble();
  }
}
