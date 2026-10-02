import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/petanque_detector.dart';
import '../../../domain/team.dart';

class TerrainAnalysisScreen extends StatefulWidget {
  const TerrainAnalysisScreen({
    super.key,
    required this.teamA,
    required this.teamB,
  });

  final Team teamA;
  final Team teamB;

  @override
  State<TerrainAnalysisScreen> createState() =>
      _TerrainAnalysisScreenState();
}


enum _BallOwner {
  teamA,
  teamB,
  unknown,
}

enum _TerrainInteractionMode {
  assignBalls,
  calibrateGround,
}


class _TerrainAnalysisScreenState extends State<TerrainAnalysisScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;

  bool _pickingImage = false;
  bool _analyzing = false;

  String? _analysisError;
  List<PetanqueDetection> _detections = [];
  final Map<int, _BallOwner> _ballOwners = {};

  _TerrainInteractionMode _interactionMode =
    _TerrainInteractionMode.assignBalls;

  List<Offset> _groundCalibrationPoints = [];


  void _startGroundCalibration() {
  setState(() {
    _interactionMode =
        _TerrainInteractionMode.calibrateGround;

    _groundCalibrationPoints = [];
  });
}

void _cancelGroundCalibration() {
  setState(() {
    _interactionMode =
        _TerrainInteractionMode.assignBalls;

    _groundCalibrationPoints = [];
  });
}

void _addGroundCalibrationPoint(
  Offset normalizedPoint,
) {
  if (_interactionMode !=
      _TerrainInteractionMode.calibrateGround) {
    return;
  }

  if (_groundCalibrationPoints.length >= 4) {
    return;
  }

  setState(() {
    _groundCalibrationPoints.add(
      Offset(
        normalizedPoint.dx.clamp(0.0, 1.0),
        normalizedPoint.dy.clamp(0.0, 1.0),
      ),
    );
  });
}

void _undoGroundCalibrationPoint() {
  if (_groundCalibrationPoints.isEmpty) {
    return;
  }

  setState(() {
    _groundCalibrationPoints.removeLast();
  });
}

void _validateGroundCalibration() {
  if (_groundCalibrationPoints.length != 4) {
    return;
  }

  setState(() {
    _interactionMode =
        _TerrainInteractionMode.assignBalls;
  });
}


  Future<void> _takePhoto() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> _choosePhoto() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_pickingImage || _analyzing) {
      return;
    }

    setState(() {
      _pickingImage = true;
      _analysisError = null;
    });

    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 95,
      );

      if (!mounted) {
        return;
      }

      if (image == null) {
        return;
      }

      setState(() {
        _selectedImage = image;
        _detections = [];
      });

      await _analyzeImage(image);
    } finally {
      if (mounted) {
        setState(() {
          _pickingImage = false;
        });
      }
    }
  }

  Future<void> _analyzeImage(XFile image) async {
    setState(() {
  _analyzing = true;
  _analysisError = null;
  _detections = [];
  _ballOwners.clear();

  _interactionMode =
      _TerrainInteractionMode.assignBalls;

  _groundCalibrationPoints = [];
});

    try {
      final detections =
          await PetanqueDetector.instance.detect(image.path);

      if (!mounted) {
        return;
      }

      setState(() {
        _detections = detections;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _analysisError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _analyzing = false;
        });
      }
    }
  }

  void _removePhoto() {
    if (_analyzing) {
      return;
    }

    setState(() {
  _selectedImage = null;
  _detections = [];
  _ballOwners.clear();
  _analysisError = null;

  _interactionMode =
      _TerrainInteractionMode.assignBalls;

  _groundCalibrationPoints = [];
});
  }


  Future<void> _assignBall(int detectionIndex) async {
  final detection = _detections[detectionIndex];

  if (detection.type != PetanqueObjectType.boule) {
    return;
  }

  final result = await showModalBottomSheet<_BallOwner>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'À qui appartient cette boule ?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              FilledButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    _BallOwner.teamA,
                  );
                },
                child: Text(widget.teamA.name),
              ),

              const SizedBox(height: 8),

              FilledButton.tonal(
                onPressed: () {
                  Navigator.pop(
                    context,
                    _BallOwner.teamB,
                  );
                },
                child: Text(widget.teamB.name),
              ),

              const SizedBox(height: 8),

              OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    _BallOwner.unknown,
                  );
                },
                child: const Text('Indéterminée'),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (result == null || !mounted) {
    return;
  }

  setState(() {
    _ballOwners[detectionIndex] = result;
  });
}

  @override
  Widget build(BuildContext context) {
    final bouleCount = _detections
        .where(
          (detection) =>
              detection.type == PetanqueObjectType.boule,
        )
        .length;

    final cochonnetCount = _detections
        .where(
          (detection) =>
              detection.type == PetanqueObjectType.cochonnet,
        )
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse du terrain'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Photo de la mène',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Prenez une photo du terrain ou sélectionnez '
            'une photo existante.',
          ),
          const SizedBox(height: 24),

          if (_selectedImage == null) ...[
            FilledButton.icon(
              onPressed:
                  _pickingImage || _analyzing ? null : _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Prendre une photo'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed:
                  _pickingImage || _analyzing ? null : _choosePhoto,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choisir dans la galerie'),
            ),
          ] else ...[
            _DetectionImage(
  imageFile: File(_selectedImage!.path),
  detections: _detections,
  ballOwners: _ballOwners,
  teamAName: widget.teamA.name,
  teamBName: widget.teamB.name,
  onBallTap: _assignBall,

  calibrationMode:
      _interactionMode ==
      _TerrainInteractionMode.calibrateGround,

  calibrationPoints:
      _groundCalibrationPoints,

  onCalibrationPoint:
      _addGroundCalibrationPoint,
),

            const SizedBox(height: 8),

Text(
  _interactionMode ==
          _TerrainInteractionMode.calibrateGround
      ? 'Calibration du sol : placez les 4 points du rectangle de référence.'
      : 'Pincez pour zoomer • Touchez une boule pour l’attribuer',
  textAlign: TextAlign.center,
),

const SizedBox(height: 12),

if (_interactionMode ==
    _TerrainInteractionMode.assignBalls)
  OutlinedButton.icon(
    onPressed: _startGroundCalibration,
    icon: const Icon(Icons.crop_free),
    label: const Text(
      'Calibrer la perspective',
    ),
  )
else
  Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Text(
            'Point ${_groundCalibrationPoints.length}/4',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Touchez successivement les 4 coins '
            'du rectangle au sol : haut gauche, '
            'haut droit, bas droit, bas gauche.',
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      _groundCalibrationPoints.isEmpty
                          ? null
                          : _undoGroundCalibrationPoint,
                  icon: const Icon(Icons.undo),
                  label: const Text('Annuler point'),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: FilledButton.icon(
                  onPressed:
                      _groundCalibrationPoints.length == 4
                          ? _validateGroundCalibration
                          : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Valider'),
                ),
              ),
            ],
          ),

          TextButton(
            onPressed: _cancelGroundCalibration,
            child: const Text(
              'Annuler la calibration',
            ),
          ),
        ],
      ),
    ),
  ),

const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        _pickingImage || _analyzing
                            ? null
                            : _choosePhoto,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Changer'),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed:
                      _pickingImage || _analyzing
                          ? null
                          : _removePhoto,
                  tooltip: 'Supprimer la photo',
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            Text(
              'Résultat de l\'analyse',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            if (_analyzing)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Analyse de la photo en cours...',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_analysisError != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error_outline),
                          SizedBox(width: 8),
                          Text(
                            'Erreur pendant l\'analyse',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SelectableText(_analysisError!),
                    ],
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$bouleCount boule'
                        '${bouleCount > 1 ? 's' : ''} détectée'
                        '${bouleCount > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$cochonnetCount cochonnet'
                        '${cochonnetCount > 1 ? 's' : ''} détecté'
                        '${cochonnetCount > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_detections.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ..._detections.map(
                          (detection) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${detection.label} — '
                              '${(detection.confidence * 100).toStringAsFixed(1)} %',
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Aucun objet détecté avec le seuil actuel.',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],

          if (_pickingImage) ...[
            const SizedBox(height: 24),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetectionImage extends StatelessWidget {
  const _DetectionImage({
    required this.imageFile,
    required this.detections,
    required this.ballOwners,
    required this.teamAName,
    required this.teamBName,
    required this.onBallTap,
    required this.calibrationMode,
    required this.calibrationPoints,
    required this.onCalibrationPoint,
  });

  final File imageFile;
  final List<PetanqueDetection> detections;
  final Map<int, _BallOwner> ballOwners;

  final String teamAName;
  final String teamBName;

  final ValueChanged<int> onBallTap;

  final bool calibrationMode;
  final List<Offset> calibrationPoints;
  final ValueChanged<Offset> onCalibrationPoint;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder<Size>(
            future: _getImageSize(imageFile),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                );
              }

              final imageSize = snapshot.data!;

              final displayWidth =
                  constraints.maxWidth;

              final displayHeight =
                  displayWidth *
                  imageSize.height /
                  imageSize.width;

              final displaySize = Size(
                displayWidth,
                displayHeight,
              );

              return SizedBox(
                width: displayWidth,
                height: displayHeight,
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 8.0,

                  panEnabled: true,
                  scaleEnabled: true,

                  boundaryMargin:
                      EdgeInsets.symmetric(
                    horizontal: displayWidth,
                    vertical: displayHeight,
                  ),

                  constrained: true,
                  clipBehavior: Clip.hardEdge,

                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,

                    onTapUp: (details) {
                      if (calibrationMode) {
                        if (calibrationPoints.length >=
                            4) {
                          return;
                        }

                        final normalized =
                            Offset(
                          details.localPosition.dx /
                              displayWidth,
                          details.localPosition.dy /
                              displayHeight,
                        );

                        onCalibrationPoint(
                          normalized,
                        );

                        return;
                      }

                      _handleBallTap(
                        details.localPosition,
                        displaySize,
                      );
                    },

                    child: SizedBox(
                      width: displayWidth,
                      height: displayHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            imageFile,
                            fit: BoxFit.fill,
                          ),

                          IgnorePointer(
                            child: CustomPaint(
                              painter:
                                  _DetectionPainter(
                                detections:
                                    detections,
                                ballOwners:
                                    ballOwners,
                                teamAName:
                                    teamAName,
                                teamBName:
                                    teamBName,
                              ),
                            ),
                          ),

                          if (calibrationMode ||
                              calibrationPoints
                                  .isNotEmpty)
                            IgnorePointer(
                              child: CustomPaint(
                                painter:
                                    _GroundCalibrationPainter(
                                  points:
                                      calibrationPoints,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _handleBallTap(
    Offset position,
    Size size,
  ) {
    int? bestIndex;
    double? bestDistance;

    for (final entry
        in detections.asMap().entries) {
      final index = entry.key;
      final detection = entry.value;

      if (detection.type !=
          PetanqueObjectType.boule) {
        continue;
      }

      final center = Offset(
        ((detection.left +
                    detection.right) /
                2) *
            size.width,
        ((detection.top +
                    detection.bottom) /
                2) *
            size.height,
      );

      final boxWidth =
          (detection.right -
                  detection.left) *
              size.width;

      final boxHeight =
          (detection.bottom -
                  detection.top) *
              size.height;

      final touchRadius =
          (boxWidth > boxHeight
                  ? boxWidth
                  : boxHeight)
              .clamp(22.0, 60.0);

      final distance =
          (position - center).distance;

      if (distance <= touchRadius) {
        if (bestDistance == null ||
            distance < bestDistance) {
          bestDistance = distance;
          bestIndex = index;
        }
      }
    }

    if (bestIndex != null) {
      onBallTap(bestIndex);
    }
  }

  Future<Size> _getImageSize(
    File file,
  ) async {
    final decoded =
        await decodeImageFromList(
      await file.readAsBytes(),
    );

    return Size(
      decoded.width.toDouble(),
      decoded.height.toDouble(),
    );
  }
}


class _GroundCalibrationPainter
    extends CustomPainter {
  const _GroundCalibrationPainter({
    required this.points,
  });

  final List<Offset> points;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final displayPoints = points
        .map(
          (point) => Offset(
            point.dx * size.width,
            point.dy * size.height,
          ),
        )
        .toList();

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final pointPaint = Paint()
      ..style = PaintingStyle.fill;

    if (displayPoints.length >= 2) {
      final path = Path()
        ..moveTo(
          displayPoints.first.dx,
          displayPoints.first.dy,
        );

      for (var i = 1;
          i < displayPoints.length;
          i++) {
        path.lineTo(
          displayPoints[i].dx,
          displayPoints[i].dy,
        );
      }

      if (displayPoints.length == 4) {
        path.close();
      }

      canvas.drawPath(
        path,
        linePaint,
      );
    }

    for (var i = 0;
        i < displayPoints.length;
        i++) {
      final point = displayPoints[i];

      canvas.drawCircle(
        point,
        10,
        pointPaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          point.dx -
              textPainter.width / 2,
          point.dy -
              textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _GroundCalibrationPainter
        oldDelegate,
  ) {
    return oldDelegate.points != points;
  }
}

class _DetectionPainter extends CustomPainter {
  const _DetectionPainter({
    required this.detections,
    required this.ballOwners,
    required this.teamAName,
    required this.teamBName,
  });

  final List<PetanqueDetection> detections;
  final Map<int, _BallOwner> ballOwners;

  final String teamAName;
  final String teamBName;

  @override
  void paint(Canvas canvas, Size size) {
    for (final entry in detections.asMap().entries) {
      final index = entry.key;
      final detection = entry.value;

      final rect = Rect.fromLTRB(
        detection.left * size.width,
        detection.top * size.height,
        detection.right * size.width,
        detection.bottom * size.height,
      );

      final owner = ballOwners[index];

      final boxPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = owner == null ? 3 : 5;

      canvas.drawRect(rect, boxPaint);

      String label;

      if (detection.type ==
          PetanqueObjectType.cochonnet) {
        label =
            'cochonnet '
            '${(detection.confidence * 100).toStringAsFixed(0)}%';
      } else {
        final ownerLabel = switch (owner) {
          _BallOwner.teamA => teamAName,
          _BallOwner.teamB => teamBName,
          _BallOwner.unknown => '?',
          null => 'toucher',
        };

        label =
            '$ownerLabel '
            '${(detection.confidence * 100).toStringAsFixed(0)}%';
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final labelTop =
          (rect.top - textPainter.height - 4)
              .clamp(0.0, size.height);

      final backgroundRect = Rect.fromLTWH(
        rect.left,
        labelTop,
        textPainter.width + 8,
        textPainter.height + 4,
      );

      canvas.drawRect(
        backgroundRect,
        Paint(),
      );

      textPainter.paint(
        canvas,
        Offset(
          rect.left + 4,
          labelTop + 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _DetectionPainter oldDelegate,
  ) {
    return oldDelegate.detections != detections ||
        oldDelegate.ballOwners != ballOwners ||
        oldDelegate.teamAName != teamAName ||
        oldDelegate.teamBName != teamBName;
  }
}