import 'package:camera/camera.dart';

import '../domain/capture_rotation.dart';
import '../domain/tilt_sample.dart';

class PetanqueCameraResult {
  const PetanqueCameraResult({
    required this.image,
    required this.orientation,
    required this.captureRotation,
    required this.zoomLevel,
  });

  final XFile image;
  final TiltSample orientation;
  final CaptureRotation captureRotation;
  final double zoomLevel;

  double get tiltDegrees => orientation.tiltDegrees;
}
