/// A boule with its corrected distance to the jack.
class RankedBall {
  const RankedBall({required this.detectionIndex, required this.distance});

  final int detectionIndex;
  final double distance;
}
