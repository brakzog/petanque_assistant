import 'package:camera/camera.dart';

import '../domain/tilt_sample.dart';

class PetanqueCameraResult {
  const PetanqueCameraResult({
    required this.image,
    required this.orientation,
  });

  final XFile image;
  final TiltSample orientation;

  double get tiltDegrees => orientation.tiltDegrees;
}
