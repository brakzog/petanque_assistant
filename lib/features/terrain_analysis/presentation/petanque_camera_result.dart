import 'package:camera/camera.dart';

class PetanqueCameraResult {
  const PetanqueCameraResult({required this.image, required this.tiltDegrees});

  final XFile image;
  final double tiltDegrees;
}
