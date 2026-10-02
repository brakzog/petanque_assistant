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

class _TerrainAnalysisScreenState extends State<TerrainAnalysisScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;

  bool _pickingImage = false;
  bool _analyzing = false;

  String? _analysisError;
  List<PetanqueDetection> _detections = [];
  final Map<int, _BallOwner> _ballOwners = {};

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
            ),

            const SizedBox(height: 8),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pinch,
                  size: 18,
                  ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Pincez pour zoomer • Touchez une boule pour l’attribuer',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
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
  });

  final File imageFile;
  final List<PetanqueDetection> detections;
  final Map<int, _BallOwner> ballOwners;

  final String teamAName;
  final String teamBName;

  final ValueChanged<int> onBallTap;

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

              final displayWidth = constraints.maxWidth;
              final displayHeight =
                  displayWidth *
                  imageSize.height /
                  imageSize.width;

              return SizedBox(
                width: displayWidth,
                height: displayHeight,
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 8.0,

                  panEnabled: true,
                  scaleEnabled: true,

                  // Permet de déplacer largement l'image une fois zoomée,
                  // y compris pour ramener les bords vers le centre.
                  boundaryMargin: EdgeInsets.symmetric(
                    horizontal: displayWidth,
                    vertical: displayHeight,
                  ),

                  constrained: true,
                  clipBehavior: Clip.hardEdge,

                  child: GestureDetector();
            },
          );
        },
      ),
    );
  }

  void _handleTap(
    Offset position,
    Size size,
  ) {
    int? bestIndex;
    double? bestDistance;

    for (final entry in detections.asMap().entries) {
      final index = entry.key;
      final detection = entry.value;

      if (detection.type != PetanqueObjectType.boule) {
        continue;
      }

      final center = Offset(
        ((detection.left + detection.right) / 2) *
            size.width,
        ((detection.top + detection.bottom) / 2) *
            size.height,
      );

      final boxWidth =
          (detection.right - detection.left) *
          size.width;

      final boxHeight =
          (detection.bottom - detection.top) *
          size.height;

      //
      // On conserve une zone facile à toucher,
      // mais on ne crée plus plusieurs widgets
      // tactiles qui se chevauchent.
      //
      final touchRadius =
          (boxWidth > boxHeight
                  ? boxWidth
                  : boxHeight)
              .clamp(22.0, 60.0);

      final distance =
          (position - center).distance;

      if (distance <= touchRadius) {
        //
        // Si plusieurs boules sont suffisamment
        // proches, on choisit celle dont le centre
        // est réellement le plus proche du doigt.
        //
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

  Future<Size> _getImageSize(File file) async {
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