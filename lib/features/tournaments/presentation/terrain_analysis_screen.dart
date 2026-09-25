import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/petanque_detector.dart';

class TerrainAnalysisScreen extends StatefulWidget {
  const TerrainAnalysisScreen({
    super.key,
  });

  @override
  State<TerrainAnalysisScreen> createState() =>
      _TerrainAnalysisScreenState();
}

class _TerrainAnalysisScreenState extends State<TerrainAnalysisScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;

  bool _pickingImage = false;
  bool _analyzing = false;

  String? _analysisError;
  List<PetanqueDetection> _detections = [];

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
      _analysisError = null;
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
  });

  final File imageFile;
  final List<PetanqueDetection> detections;

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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      imageFile,
                      fit: BoxFit.fill,
                    ),
                    CustomPaint(
                      painter: _DetectionPainter(
                        detections: detections,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<Size> _getImageSize(File file) async {
    final decoded =
        await decodeImageFromList(await file.readAsBytes());

    return Size(
      decoded.width.toDouble(),
      decoded.height.toDouble(),
    );
  }
}

class _DetectionPainter extends CustomPainter {
  const _DetectionPainter({
    required this.detections,
  });

  final List<PetanqueDetection> detections;

  @override
  void paint(Canvas canvas, Size size) {
    for (final detection in detections) {
      final rect = Rect.fromLTRB(
        detection.left * size.width,
        detection.top * size.height,
        detection.right * size.width,
        detection.bottom * size.height,
      );

      final boxPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawRect(rect, boxPaint);

      final label =
          '${detection.label} '
          '${(detection.confidence * 100).toStringAsFixed(0)}%';

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
    return oldDelegate.detections != detections;
  }
}