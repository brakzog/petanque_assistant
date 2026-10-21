/// Orientation sample captured from the accelerometer while the phone is held
/// still for a guided terrain photo.
///
/// The gravity components are normalized, so their magnitude is ~1. Keeping
/// the three components preserves the *direction* of the phone tilt; the
/// scalar [tiltDegrees] alone cannot do that.
class TiltSample {
  const TiltSample({
    required this.tiltDegrees,
    required this.gravityX,
    required this.gravityY,
    required this.gravityZ,
  });

  final double tiltDegrees;
  final double gravityX;
  final double gravityY;
  final double gravityZ;
}
