import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/features/terrain_analysis/domain/tilt_calculator.dart';
import 'package:tournoi_de_petanque/features/terrain_analysis/domain/tilt_policy.dart';

void main() {
  group('TiltCalculator', () {
    const calculator = TiltCalculator();

    test('is 0 when the phone lies flat', () {
      expect(calculator.tiltDegrees(0, 0, 9.81), closeTo(0, 1e-9));
      expect(calculator.tiltDegrees(0, 0, -9.81), closeTo(0, 1e-9));
    });

    test('is 90 when the phone stands upright', () {
      expect(calculator.tiltDegrees(0, 9.81, 0), closeTo(90, 1e-9));
    });

    test('is null without gravity', () {
      expect(calculator.tiltDegrees(0, 0, 0), isNull);
    });
  });

  group('TiltPolicy', () {
    const policy = TiltPolicy();

    test('classifies tilt angles', () {
      expect(policy.qualityOf(null), TiltQuality.unknown);
      expect(policy.qualityOf(3), TiltQuality.excellent);
      expect(policy.qualityOf(8), TiltQuality.acceptable);
      expect(policy.qualityOf(15), TiltQuality.tooSteep);
    });

    test('allows capture up to the maximum tilt only', () {
      expect(policy.allowsCapture(null), isFalse);
      expect(policy.allowsCapture(10), isTrue);
      expect(policy.allowsCapture(10.1), isFalse);
    });
  });
}
