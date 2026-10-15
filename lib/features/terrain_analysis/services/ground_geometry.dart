import 'dart:math' as math;
import 'dart:ui';

import 'petanque_detector.dart';

/// First local ground-geometry estimator.
///
/// This is deliberately NOT a full monocular 3D reconstruction. It compensates
/// the most visible perspective effect in a tight petanque scene: apparent
/// scale changes across the image. A boule's known physical diameter is used as
/// a local ruler and the scale at the jack is interpolated from nearby boules.
///
/// Distances are therefore useful for ranking/testing, but must remain guarded
/// by an uncertainty margin until camera pose / ground-plane rectification is
/// available.
class GroundGeometry {
  const GroundGeometry._();

  static const double nominalBouleDiameterMm = 74.0;

  static GroundGeometryModel build({
    required List<PetanqueDetection> detections,
    required Size imageSize,
  }) {
    final boules = detections
        .where((d) => d.type == PetanqueObjectType.boule)
        .toList();

    final samples = <_ScaleSample>[];
    for (final boule in boules) {
      final diameter = _apparentDiameterPx(boule, imageSize);
      if (diameter <= 1) continue;
      samples.add(
        _ScaleSample(
          point: _groundContactPx(boule, imageSize),
          pixelsPerMm: diameter / nominalBouleDiameterMm,
        ),
      );
    }

    final scales = samples.map((s) => s.pixelsPerMm).toList()..sort();
    final medianScale = scales.isEmpty ? 0.0 : scales[scales.length ~/ 2];
    final minScale = scales.isEmpty ? 0.0 : scales.first;
    final maxScale = scales.isEmpty ? 0.0 : scales.last;
    final scaleSpread = medianScale <= 0
        ? 1.0
        : (maxScale - minScale) / medianScale;

    return GroundGeometryModel._(
      imageSize: imageSize,
      samples: samples,
      scaleSpread: scaleSpread,
    );
  }

  static Offset _groundContactPx(
    PetanqueDetection detection,
    Size imageSize,
  ) {
    return Offset(
      ((detection.left + detection.right) / 2) * imageSize.width,
      detection.bottom * imageSize.height,
    );
  }

  static double _apparentDiameterPx(
    PetanqueDetection detection,
    Size imageSize,
  ) {
    final width = (detection.right - detection.left).abs() * imageSize.width;
    final height = (detection.bottom - detection.top).abs() * imageSize.height;

    // Geometric mean is less sensitive than max(width, height) to an imperfect
    // detector box while preserving the apparent scale of the sphere.
    return math.sqrt(math.max(1.0, width * height));
  }
}

class GroundGeometryModel {
  const GroundGeometryModel._({
    required this.imageSize,
    required List<_ScaleSample> samples,
    required this.scaleSpread,
  }) : _samples = samples;

  final Size imageSize;
  final List<_ScaleSample> _samples;

  /// Relative variation of apparent boule scale over the photographed area.
  /// A high value means perspective is strong and this first estimator should
  /// be treated more cautiously.
  final double scaleSpread;

  int get sampleCount => _samples.length;

  bool get hasEnoughSamples => sampleCount >= 3;

  bool get strongPerspective => scaleSpread > 0.35;

  double distanceMm(
    PetanqueDetection first,
    PetanqueDetection second,
  ) {
    final a = _groundContactPx(first);
    final b = _groundContactPx(second);
    final pixelDistance = (a - b).distance;

    final scaleA = _scaleAt(a);
    final scaleB = _scaleAt(b);
    if (scaleA <= 0 || scaleB <= 0) return double.infinity;

    // Integrating a smoothly changing local scale along a short segment is
    // approximated by the geometric mean of the scales at both endpoints.
    final segmentScale = math.sqrt(scaleA * scaleB);
    return pixelDistance / segmentScale;
  }

  Offset _groundContactPx(PetanqueDetection detection) {
    return Offset(
      ((detection.left + detection.right) / 2) * imageSize.width,
      detection.bottom * imageSize.height,
    );
  }

  double _scaleAt(Offset point) {
    if (_samples.isEmpty) return 0;

    var weightedScale = 0.0;
    var weightSum = 0.0;

    for (final sample in _samples) {
      final distance = (sample.point - point).distance;
      // Soft radius avoids one sample completely dominating while still making
      // nearby boules the best local rulers.
      final weight = 1.0 / math.pow(distance + 40.0, 2);
      weightedScale += sample.pixelsPerMm * weight;
      weightSum += weight;
    }

    return weightSum <= 0 ? 0 : weightedScale / weightSum;
  }
}

class _ScaleSample {
  const _ScaleSample({
    required this.point,
    required this.pixelsPerMm,
  });

  final Offset point;
  final double pixelsPerMm;
}
