import 'package:sensors_plus/sensors_plus.dart';

import '../domain/tilt_calculator.dart';

/// Stream of the phone tilt relative to the ground, in degrees.
abstract interface class TiltSensor {
  Stream<double> tiltDegrees();
}

class AccelerometerTiltSensor implements TiltSensor {
  const AccelerometerTiltSensor({this.calculator = const TiltCalculator()});

  final TiltCalculator calculator;

  @override
  Stream<double> tiltDegrees() {
    return accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
        .map((event) => calculator.tiltDegrees(event.x, event.y, event.z))
        .where((tilt) => tilt != null)
        .cast<double>();
  }
}
