import 'petanque_detector.dart';

/// Detects boules and cochonnets on a photo.
abstract interface class BallDetector {
  Future<List<PetanqueDetection>> detect(String imagePath);
}
