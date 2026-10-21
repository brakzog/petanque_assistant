/// Stable reference to a boule candidate during a terrain analysis.
///
/// A candidate can come either from V3 or from a boule added manually.
sealed class RankedBallReference {
  const RankedBallReference();
}

final class DetectedBallReference extends RankedBallReference {
  const DetectedBallReference(this.detectionIndex);

  final int detectionIndex;
}

final class ManualBallReference extends RankedBallReference {
  const ManualBallReference(this.manualBallIndex);

  final int manualBallIndex;
}
