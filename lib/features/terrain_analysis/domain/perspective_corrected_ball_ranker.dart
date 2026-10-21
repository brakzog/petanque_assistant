import 'dart:math' as math;
import 'dart:ui';

import '../services/petanque_detector.dart';
import 'capture_rotation.dart';
import 'ranked_ball.dart';
import 'tilt_sample.dart';

/// Ranks boules after projecting image points onto a normalized ground plane.
///
/// The projection uses the gravity vector captured at shutter time. Absolute
/// metric scale is intentionally not claimed: camera height is set to an
/// arbitrary constant because a common scale does not affect ordering.
///
/// The camera focal length is approximated from a conservative 65° horizontal
/// field of view at 1x and adjusted by optical/digital zoom. This is suitable
/// for the guided, near-vertical capture flow; callers must fall back to the
/// legacy ranker when the pose metadata is missing or outside that envelope.
class PerspectiveCorrectedBallRanker {
  const PerspectiveCorrectedBallRanker({
    this.baseHorizontalFovDegrees = 65.0,
    this.maxTiltDegrees = 12.0,
  });

  final double baseHorizontalFovDegrees;
  final double maxTiltDegrees;

  bool canRank({
    required TiltSample? orientation,
    required CaptureRotation? rotation,
    required double? zoomLevel,
    required double imageAspectRatio,
  }) {
    if (orientation == null || rotation == null || zoomLevel == null) {
      return false;
    }
    if (!orientation.tiltDegrees.isFinite ||
        orientation.tiltDegrees > maxTiltDegrees ||
        !zoomLevel.isFinite ||
        zoomLevel <= 0 ||
        !imageAspectRatio.isFinite ||
        imageAspectRatio <= 0) {
      return false;
    }

    final gravityLength = math.sqrt(
      orientation.gravityX * orientation.gravityX +
          orientation.gravityY * orientation.gravityY +
          orientation.gravityZ * orientation.gravityZ,
    );
    return gravityLength > 0.5;
  }

  List<RankedBall> rank({
    required List<PetanqueDetection> detections,
    required List<Offset> manualBalls,
    required Offset jack,
    required Set<int> excludedIndices,
    required double imageAspectRatio,
    required TiltSample orientation,
    required CaptureRotation rotation,
    required double zoomLevel,
  }) {
    final projector = _GroundPlaneProjector(
      orientation: orientation,
      rotation: rotation,
      zoomLevel: zoomLevel,
      imageAspectRatio: imageAspectRatio,
      baseHorizontalFovDegrees: baseHorizontalFovDegrees,
    );

    final projectedJack = projector.project(jack);
    if (projectedJack == null) return const [];

    final ranked = <RankedBall>[];

    for (final entry in detections.asMap().entries) {
      final detection = entry.value;
      if (!detection.isBoule || excludedIndices.contains(entry.key)) continue;

      // Use the same kind of point as manual corrections. A detector bbox is
      // not used as a scale ruler here; perspective comes from camera pose.
      final projected = projector.project(detection.center);
      if (projected == null) continue;

      ranked.add(
        RankedBall.detected(
          detectionIndex: entry.key,
          distance: (projected - projectedJack).distance,
        ),
      );
    }

    for (final entry in manualBalls.asMap().entries) {
      final projected = projector.project(entry.value);
      if (projected == null) continue;
      ranked.add(
        RankedBall.manual(
          manualBallIndex: entry.key,
          distance: (projected - projectedJack).distance,
        ),
      );
    }

    ranked.sort((a, b) => a.distance.compareTo(b.distance));
    return ranked;
  }
}

class _GroundPlaneProjector {
  _GroundPlaneProjector({
    required TiltSample orientation,
    required CaptureRotation rotation,
    required this.zoomLevel,
    required this.imageAspectRatio,
    required double baseHorizontalFovDegrees,
  }) : _normal = _gravityInImageCoordinates(orientation, rotation),
       _baseFocal =
           0.5 /
           math.tan(baseHorizontalFovDegrees * math.pi / 360.0) {
    // Build an orthonormal basis lying on the ground plane. Its yaw is
    // arbitrary, which is fine because Euclidean distances are yaw invariant.
    final cameraX = const _Vec3(1, 0, 0);
    var first = cameraX - _normal * cameraX.dot(_normal);
    if (first.length < 1e-6) {
      final cameraY = const _Vec3(0, 1, 0);
      first = cameraY - _normal * cameraY.dot(_normal);
    }
    _groundX = first.normalized;
    _groundY = _normal.cross(_groundX).normalized;
  }

  final double zoomLevel;
  final double imageAspectRatio;
  final double _baseFocal;
  final _Vec3 _normal;
  late final _Vec3 _groundX;
  late final _Vec3 _groundY;

  Offset? project(Offset point) {
    final focalX = _baseFocal * zoomLevel;
    final focalY = focalX * imageAspectRatio;
    if (focalX <= 1e-6 || focalY <= 1e-6) return null;

    final ray = _Vec3(
      (point.dx.clamp(0.0, 1.0) - 0.5) / focalX,
      (point.dy.clamp(0.0, 1.0) - 0.5) / focalY,
      1,
    );

    final denominator = _normal.dot(ray);
    if (denominator.abs() < 0.05) return null;

    // Intersect with n.X = 1. Camera height only multiplies every result by
    // the same factor, so choosing 1 preserves the distance ordering.
    final hit = ray * (1.0 / denominator);
    return Offset(hit.dot(_groundX), hit.dot(_groundY));
  }

  static _Vec3 _gravityInImageCoordinates(
    TiltSample sample,
    CaptureRotation rotation,
  ) {
    var x = sample.gravityX;
    var y = sample.gravityY;

    switch (rotation) {
      case CaptureRotation.portraitUp:
        break;
      case CaptureRotation.landscapeLeft:
        final oldX = x;
        x = -y;
        y = oldX;
        break;
      case CaptureRotation.portraitDown:
        x = -x;
        y = -y;
        break;
      case CaptureRotation.landscapeRight:
        final oldX = x;
        x = y;
        y = -oldX;
        break;
    }

    // Rear-camera optical axis is opposite the device screen normal. The sign
    // of the plane normal itself is irrelevant for ray/plane intersection, so
    // keep z positive to make the near-vertical case numerically stable.
    return _Vec3(x, y, sample.gravityZ.abs()).normalized;
  }
}

class _Vec3 {
  const _Vec3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  double get length => math.sqrt(x * x + y * y + z * z);

  _Vec3 get normalized {
    final value = length;
    if (value <= 1e-12) return const _Vec3(0, 0, 1);
    return _Vec3(x / value, y / value, z / value);
  }

  double dot(_Vec3 other) => x * other.x + y * other.y + z * other.z;

  _Vec3 cross(_Vec3 other) => _Vec3(
    y * other.z - z * other.y,
    z * other.x - x * other.z,
    x * other.y - y * other.x,
  );

  _Vec3 operator -(_Vec3 other) =>
      _Vec3(x - other.x, y - other.y, z - other.z);

  _Vec3 operator *(double factor) =>
      _Vec3(x * factor, y * factor, z * factor);
}
