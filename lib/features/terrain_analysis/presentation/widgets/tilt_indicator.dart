import 'package:flutter/material.dart';

import '../../domain/tilt_policy.dart';

class TiltIndicator extends StatelessWidget {
  const TiltIndicator({
    super.key,
    required this.tiltDegrees,
    required this.quality,
  });

  final double? tiltDegrees;
  final TiltQuality quality;

  @override
  Widget build(BuildContext context) {
    final angle = tiltDegrees?.toStringAsFixed(1);
    final text = switch (quality) {
      TiltQuality.unknown => 'Lecture de l’inclinaison…',
      TiltQuality.excellent => '✓ Angle excellent • $angle°',
      TiltQuality.acceptable => '✓ Angle exploitable • $angle°',
      TiltQuality.tooSteep => 'Mettez le téléphone plus à plat • $angle°',
    };
    final acceptable =
        quality == TiltQuality.excellent || quality == TiltQuality.acceptable;

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: acceptable ? Colors.greenAccent : Colors.orangeAccent,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
