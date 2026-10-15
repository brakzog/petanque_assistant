enum TiltQuality { unknown, excellent, acceptable, tooSteep }

/// Decides whether the phone is flat enough for a guided capture.
class TiltPolicy {
  const TiltPolicy({this.excellentTilt = 6.0, this.maximumTilt = 10.0});

  final double excellentTilt;
  final double maximumTilt;

  TiltQuality qualityOf(double? tiltDegrees) {
    if (tiltDegrees == null) return TiltQuality.unknown;
    if (tiltDegrees <= excellentTilt) return TiltQuality.excellent;
    if (tiltDegrees <= maximumTilt) return TiltQuality.acceptable;
    return TiltQuality.tooSteep;
  }

  bool allowsCapture(double? tiltDegrees) {
    final quality = qualityOf(tiltDegrees);
    return quality == TiltQuality.excellent ||
        quality == TiltQuality.acceptable;
  }
}
