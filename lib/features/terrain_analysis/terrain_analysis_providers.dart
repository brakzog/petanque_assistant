import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'data/image_orientation_normalizer.dart';
import 'data/photo_picker.dart';
import 'domain/ball_ranker.dart';
import 'domain/detection_locator.dart';
import 'domain/framing_checker.dart';
import 'services/ball_detector.dart';
import 'services/petanque_detector.dart';

final ballDetectorProvider = Provider<BallDetector>(
  (ref) => PetanqueDetector.instance,
);

final photoPickerProvider = Provider<PhotoPicker>(
  (ref) => ImagePickerPhotoPicker(ImagePicker()),
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
