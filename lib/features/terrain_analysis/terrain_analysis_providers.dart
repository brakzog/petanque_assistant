import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'data/image_orientation_normalizer.dart';
import 'domain/ball_ranker.dart';
import 'domain/detection_locator.dart';
import 'domain/framing_checker.dart';
import 'domain/tilt_policy.dart';
import 'services/back_camera_opener.dart';
import 'services/ball_detector.dart';
import 'services/petanque_detector.dart';
import 'services/tilt_sensor.dart';

final ballDetectorProvider = Provider<BallDetector>(
  (ref) => PetanqueDetector.instance,
);

final imageOrientationNormalizerProvider = Provider<ImageOrientationNormalizer>(
  (ref) => const ImageOrientationNormalizer(
    temporaryDirectory: getTemporaryDirectory,
  ),
);

final ballRankerProvider = Provider<BallRanker>((ref) => const BallRanker());

final detectionLocatorProvider = Provider<DetectionLocator>(
  (ref) => const DetectionLocator(),
);

final framingCheckerProvider = Provider<FramingChecker>(
  (ref) => const FramingChecker(),
);

final tiltSensorProvider = Provider<TiltSensor>(
  (ref) => const AccelerometerTiltSensor(),
);

final tiltPolicyProvider = Provider<TiltPolicy>((ref) => const TiltPolicy());

final backCameraOpenerProvider = Provider<BackCameraOpener>(
  (ref) => const BackCameraOpener(),
);
