import '../services/petanque_detector.dart';
import 'detection_geometry.dart';

/// Warns when the photo is framed too wide for a reliable ranking.
class FramingChecker {
  const FramingChecker({this.minMedianDiameter = 0.022});

  final double minMedianDiameter;

  bool isPossiblyTooWide(List<PetanqueDetection> detections) {
    final diameters =
        detections
            .where((d) => d.isBoule)
            .map((d) => d.apparentDiameter)
            .toList()
          ..sort();
    if (diameters.isEmpty) return false;
    return diameters[diameters.length ~/ 2] < minMedianDiameter;
  }
}
