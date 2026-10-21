import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

import '../domain/tilt_calculator.dart';
import '../domain/tilt_sample.dart';

/// Stream of phone orientation samples relative to gravity.
abstract interface class TiltSensor {
  Stream<TiltSample> samples();
}

class AccelerometerTiltSensor implements TiltSensor {
  const AccelerometerTiltSensor({this.calculator = const TiltCalculator()});

  final TiltCalculator calculator;

  @override
  Stream<TiltSample> samples() {
    return accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
        .map((event) {
          final magnitude = math.sqrt(
            event.x * event.x + event.y * event.y + event.z * event.z,
          );
          final tilt = calculator.tiltDegrees(event.x, event.y, event.z);
          if (tilt == null || magnitude <= 0.0001) return null;

          return TiltSample(
            tiltDegrees: tilt,
            gravityX: event.x / magnitude,
            gravityY: event.y / magnitude,
            gravityZ: event.z / magnitude,
          );
        })
        .where((sample) => sample != null)
        .cast<TiltSample>();
  }
}
