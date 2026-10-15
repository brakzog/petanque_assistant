import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

/// A photo whose pixels are stored in display orientation.
class NormalizedImage {
  const NormalizedImage({required this.file, required this.aspectRatio});

  final XFile file;

  /// Width / height of the oriented image.
  final double aspectRatio;
}

/// Bakes the EXIF orientation into the pixels so that detections and display
/// share the same coordinate system.
class ImageOrientationNormalizer {
  const ImageOrientationNormalizer({
    required this.temporaryDirectory,
    this.now = DateTime.now,
  });

  final Future<Directory> Function() temporaryDirectory;
  final DateTime Function() now;

  Future<NormalizedImage> normalize(XFile source) async {
    final decoded = img.decodeImage(await source.readAsBytes());
    if (decoded == null) {
      return NormalizedImage(file: source, aspectRatio: 1.0);
    }

    final oriented = img.bakeOrientation(decoded);
    final directory = await temporaryDirectory();
    final file = File(
      p.join(
        directory.path,
        'petanque_analysis_${now().microsecondsSinceEpoch}.jpg',
      ),
    );

    await file.writeAsBytes(img.encodeJpg(oriented, quality: 95), flush: true);

    return NormalizedImage(
      file: XFile(file.path),
      aspectRatio: oriented.width / oriented.height,
    );
  }
}
