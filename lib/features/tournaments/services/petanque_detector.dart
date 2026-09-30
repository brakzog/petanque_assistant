import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

enum PetanqueObjectType {
  boule,
  cochonnet,
}

class PetanqueDetection {
  const PetanqueDetection({
    required this.type,
    required this.confidence,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final PetanqueObjectType type;
  final double confidence;

  /// Coordonnées normalisées entre 0 et 1 dans l'image originale.
  final double left;
  final double top;
  final double right;
  final double bottom;

  String get label {
    switch (type) {
      case PetanqueObjectType.boule:
        return 'Boule';
      case PetanqueObjectType.cochonnet:
        return 'Cochonnet';
    }
  }
}

class PetanqueDetector {
  PetanqueDetector._();

  static final PetanqueDetector instance = PetanqueDetector._();

  static const int _inputSize = 640;

  /// Seuil volontairement encore assez bas pour cette V1.
  ///
  /// Le modèle est maintenant fonctionnel, mais le cochonnet reste
  /// la classe la moins représentée dans le dataset.
  static const double _confidenceThreshold = 0.15;

  static const double _iouThreshold = 0.45;

  Interpreter? _interpreter;

  bool get isLoaded => _interpreter != null;

  Future<void> load() async {
    if (_interpreter != null) {
      return;
    }

    _interpreter = await Interpreter.fromAsset(
      'assets/models/petanque_detector.tflite',
    );
  }

  Future<List<PetanqueDetection>> detect(String imagePath) async {
    await load();

    final interpreter = _interpreter;

    if (interpreter == null) {
      throw StateError(
        'Le modèle TFLite n\'est pas chargé.',
      );
    }

    final bytes = await File(imagePath).readAsBytes();

    var original = img.decodeImage(bytes);

    if (original == null) {
      throw StateError(
        'Impossible de décoder la photo.',
      );
    }

    // Respecte l'orientation EXIF éventuelle de la photo.
    original = img.bakeOrientation(original);

    final originalWidth = original.width;
    final originalHeight = original.height;

    //
    // Letterbox 640 x 640
    //
    final scale = math.min(
      _inputSize / originalWidth,
      _inputSize / originalHeight,
    );

    final resizedWidth = (originalWidth * scale)
        .round()
        .clamp(1, _inputSize);

    final resizedHeight = (originalHeight * scale)
        .round()
        .clamp(1, _inputSize);

    final resized = img.copyResize(
      original,
      width: resizedWidth,
      height: resizedHeight,
      interpolation: img.Interpolation.linear,
    );

    final padX =
        ((_inputSize - resizedWidth) / 2).floor();

    final padY =
        ((_inputSize - resizedHeight) / 2).floor();

    //
    // Le modèle attend :
    //
    // [1, 3, 640, 640]
    //
    // NCHW.
    //
    final input = List.generate(
      1,
      (_) => List.generate(
        3,
        (_) => List.generate(
          _inputSize,
          (_) => List<double>.filled(
            _inputSize,
            114.0 / 255.0,
          ),
        ),
      ),
    );

    for (var y = 0; y < resizedHeight; y++) {
      for (var x = 0; x < resizedWidth; x++) {
        final pixel = resized.getPixel(x, y);

        final targetX = x + padX;
        final targetY = y + padY;

        input[0][0][targetY][targetX] =
            pixel.r.toDouble() / 255.0;

        input[0][1][targetY][targetX] =
            pixel.g.toDouble() / 255.0;

        input[0][2][targetY][targetX] =
            pixel.b.toDouble() / 255.0;
      }
    }

    //
    // Sortie YOLO11 :
    //
    // [1, 6, 8400]
    //
    // 0 = centerX
    // 1 = centerY
    // 2 = width
    // 3 = height
    // 4 = score boule
    // 5 = score cochonnet
    //
    final output = List.generate(
      1,
      (_) => List.generate(
        6,
        (_) => List<double>.filled(
          8400,
          0.0,
        ),
      ),
    );

    interpreter.run(
  input,
  output,
);

var aboveThreshold = 0;
var validAfterCoordinates = 0;

double? bestConfidence;
int? bestIndex;
PetanqueObjectType? bestType;

for (var i = 0; i < 8400; i++) {
  final bouleScore = output[0][4][i];
  final cochonnetScore = output[0][5][i];

  final confidence = math.max(
    bouleScore,
    cochonnetScore,
  );

  if (confidence >= _confidenceThreshold) {
    aboveThreshold++;

    if (bestConfidence == null ||
        confidence > bestConfidence) {
      bestConfidence = confidence;
      bestIndex = i;
      bestType = bouleScore >= cochonnetScore
          ? PetanqueObjectType.boule
          : PetanqueObjectType.cochonnet;
    }

    final centerX = output[0][0][i];
    final centerY = output[0][1][i];
    final width = output[0][2][i];
    final height = output[0][3][i];

    var left = centerX - (width / 2);
    var top = centerY - (height / 2);
    var right = centerX + (width / 2);
    var bottom = centerY + (height / 2);

    left = (left - padX) / scale;
    right = (right - padX) / scale;
    top = (top - padY) / scale;
    bottom = (bottom - padY) / scale;

    left = left.clamp(
      0.0,
      originalWidth.toDouble(),
    );
    right = right.clamp(
      0.0,
      originalWidth.toDouble(),
    );
    top = top.clamp(
      0.0,
      originalHeight.toDouble(),
    );
    bottom = bottom.clamp(
      0.0,
      originalHeight.toDouble(),
    );

    if (right > left && bottom > top) {
      validAfterCoordinates++;
    }
  }
}

/*if (bestIndex == null) {
  throw StateError(
    'DEBUG BOX V1\n'
    'Candidats >= seuil : $aboveThreshold',
  );
}

final i = bestIndex;

throw StateError(
  'DEBUG BOX V1\n'
  'Candidats >= 0.15 : $aboveThreshold\n'
  'Boxes valides : $validAfterCoordinates\n'
  'Meilleur : ${bestType?.name} '
  '${bestConfidence?.toStringAsFixed(4)}\n'
  'cx=${output[0][0][i].toStringAsFixed(4)} '
  'cy=${output[0][1][i].toStringAsFixed(4)}\n'
  'w=${output[0][2][i].toStringAsFixed(4)} '
  'h=${output[0][3][i].toStringAsFixed(4)}',
);*/

final candidates = <PetanqueDetection>[];

    for (var i = 0; i < 8400; i++) {
      final centerX = output[0][0][i] * _inputSize;
final centerY = output[0][1][i] * _inputSize;
final width = output[0][2][i] * _inputSize;
final height = output[0][3][i] * _inputSize;

      final bouleScore = output[0][4][i];
      final cochonnetScore = output[0][5][i];

      final PetanqueObjectType type;
      final double confidence;

      if (bouleScore >= cochonnetScore) {
        type = PetanqueObjectType.boule;
        confidence = bouleScore;
      } else {
        type = PetanqueObjectType.cochonnet;
        confidence = cochonnetScore;
      }

      if (confidence < _confidenceThreshold) {
        continue;
      }

      //
      // YOLO fournit cx, cy, width et height
      // dans l'espace letterbox 640 x 640.
      //
      var left = centerX - (width / 2);
      var top = centerY - (height / 2);
      var right = centerX + (width / 2);
      var bottom = centerY + (height / 2);

      //
      // Retour dans les coordonnées de l'image originale.
      //
      left = (left - padX) / scale;
      right = (right - padX) / scale;
      top = (top - padY) / scale;
      bottom = (bottom - padY) / scale;

      left = left.clamp(
        0.0,
        originalWidth.toDouble(),
      );

      right = right.clamp(
        0.0,
        originalWidth.toDouble(),
      );

      top = top.clamp(
        0.0,
        originalHeight.toDouble(),
      );

      bottom = bottom.clamp(
        0.0,
        originalHeight.toDouble(),
      );

      if (right <= left || bottom <= top) {
        continue;
      }

      candidates.add(
        PetanqueDetection(
          type: type,
          confidence: confidence,
          left: left / originalWidth,
          top: top / originalHeight,
          right: right / originalWidth,
          bottom: bottom / originalHeight,
        ),
      );
    }

    candidates.sort(
      (a, b) => b.confidence.compareTo(
        a.confidence,
      ),
    );

    return _nonMaximumSuppression(
      candidates,
    );
  }

  List<PetanqueDetection> _nonMaximumSuppression(
    List<PetanqueDetection> detections,
  ) {
    final selected = <PetanqueDetection>[];

    for (final candidate in detections) {
      var keep = true;

      for (final existing in selected) {
        // NMS séparé par classe.
        if (candidate.type != existing.type) {
          continue;
        }

        if (_iou(candidate, existing) >
            _iouThreshold) {
          keep = false;
          break;
        }
      }

      if (keep) {
        selected.add(candidate);
      }
    }

    return selected;
  }

  double _iou(
    PetanqueDetection a,
    PetanqueDetection b,
  ) {
    final intersectionLeft = math.max(
      a.left,
      b.left,
    );

    final intersectionTop = math.max(
      a.top,
      b.top,
    );

    final intersectionRight = math.min(
      a.right,
      b.right,
    );

    final intersectionBottom = math.min(
      a.bottom,
      b.bottom,
    );

    final intersectionWidth = math.max(
      0.0,
      intersectionRight - intersectionLeft,
    );

    final intersectionHeight = math.max(
      0.0,
      intersectionBottom - intersectionTop,
    );

    final intersectionArea =
        intersectionWidth * intersectionHeight;

    final areaA =
        (a.right - a.left) *
        (a.bottom - a.top);

    final areaB =
        (b.right - b.left) *
        (b.bottom - b.top);

    final unionArea =
        areaA + areaB - intersectionArea;

    if (unionArea <= 0) {
      return 0;
    }

    return intersectionArea / unionArea;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}