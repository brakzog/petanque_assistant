import 'package:flutter/material.dart';

/// Crosshair drawn at the center of the camera preview.
class CameraGuidePainter extends CustomPainter {
  const CameraGuidePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 28, paint);
    canvas.drawLine(
      Offset(center.dx - 42, center.dy),
      Offset(center.dx + 42, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 42),
      Offset(center.dx, center.dy + 42),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CameraGuidePainter oldDelegate) => false;
}
