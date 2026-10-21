import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/petanque_detector.dart';
import 'detection_painter.dart';

/// Zoomable photo with detections overlaid. Taps are reported in normalized
/// image coordinates (0..1).
class DetectionImage extends StatelessWidget {
  const DetectionImage({
    super.key,
    required this.imageFile,
    required this.imageAspectRatio,
    required this.detections,
    required this.hiddenIndices,
    required this.jackPosition,
    required this.jackConfirmed,
    required this.ballRanks,
    required this.manualBalls,
    required this.manualBallRanks,
    required this.onTap,
  });

  final File imageFile;
  final double imageAspectRatio;
  final List<PetanqueDetection> detections;
  final Set<int> hiddenIndices;
  final Offset? jackPosition;
  final bool jackConfirmed;
  final Map<int, int> ballRanks;
  final List<Offset> manualBalls;
  final Map<int, int> manualBallRanks;
  final ValueChanged<Offset> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final displaySize = _displaySize(
            maxWidth: constraints.maxWidth,
            maxHeight: MediaQuery.sizeOf(context).height * 0.68,
          );

          return Center(
            child: SizedBox.fromSize(
              size: displaySize,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 8.0,
                boundaryMargin: EdgeInsets.symmetric(
                  horizontal: displaySize.width,
                  vertical: displaySize.height,
                ),
                clipBehavior: Clip.hardEdge,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    final position = details.localPosition;
                    onTap(
                      Offset(
                        (position.dx / displaySize.width).clamp(0.0, 1.0),
                        (position.dy / displaySize.height).clamp(0.0, 1.0),
                      ),
                    );
                  },
                  child: SizedBox.fromSize(
                    size: displaySize,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(imageFile, fit: BoxFit.fill),
                        IgnorePointer(
                          child: CustomPaint(
                            painter: DetectionPainter(
                              detections: detections,
                              hiddenIndices: hiddenIndices,
                              jackPosition: jackPosition,
                              jackConfirmed: jackConfirmed,
                              ballRanks: ballRanks,
                              manualBalls: manualBalls,
                              manualBallRanks: manualBallRanks,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Size _displaySize({required double maxWidth, required double maxHeight}) {
    var width = maxWidth;
    var height = width / imageAspectRatio;
    if (height > maxHeight) {
      height = maxHeight;
      width = height * imageAspectRatio;
    }
    return Size(width, height);
  }
}
