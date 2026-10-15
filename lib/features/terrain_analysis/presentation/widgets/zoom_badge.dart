import 'package:flutter/material.dart';

class ZoomBadge extends StatelessWidget {
  const ZoomBadge({super.key, required this.zoomLevel});

  final double zoomLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '${zoomLevel.toStringAsFixed(1)}×  •  pincez pour zoomer',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
