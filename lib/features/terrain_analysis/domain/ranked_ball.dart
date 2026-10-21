/// A boule with its corrected distance to the jack.
///
/// A ranked boule comes either from the detector or from a manual correction.
class RankedBall {
  const RankedBall.detected({
    required int detectionIndex,
    required this.distance,
  }) : detectionIndex = detectionIndex,
       manualBallIndex = null;

  const RankedBall.manual({
    required int manualBallIndex,
    required this.distance,
  }) : detectionIndex = null,
       manualBallIndex = manualBallIndex;

  final int? detectionIndex;
  final int? manualBallIndex;
  final double distance;

  bool get isManual => manualBallIndex != null;
}
