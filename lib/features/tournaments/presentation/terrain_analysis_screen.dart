import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/team.dart';
import '../services/petanque_detector.dart';

class TerrainAnalysisScreen extends StatefulWidget {
  const TerrainAnalysisScreen({
    super.key,
    required this.teamA,
    required this.teamB,
  });

  // Conservés dans l'API de l'écran pour ne rien casser côté MatchLiveScreen.
  // L'analyse terrain n'a désormais plus besoin de connaître le propriétaire
  // de chaque boule.
  final Team teamA;
  final Team teamB;

  @override
  State<TerrainAnalysisScreen> createState() =>
      _TerrainAnalysisScreenState();
}

class _RankedBall {
  const _RankedBall({
    required this.detectionIndex,
    required this.distance,
  });

  final int detectionIndex;
  final double distance;
}

class _TerrainAnalysisScreenState extends State<TerrainAnalysisScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;
  bool _pickingImage = false;
  bool _analyzing = false;
  String? _analysisError;
  List<PetanqueDetection> _detections = [];

  // Position normalisée dans la photo (0..1 / 0..1).
  Offset? _jackPosition;
  bool _jackConfirmed = false;
  bool _jackWasDetected = false;

  // detectionIndex -> rang (1 = boule la plus proche du cochonnet).
  Map<int, int> _ballRanks = {};

  // Faux positifs masqués manuellement pendant l'analyse courante.
  final Set<int> _ignoredBallIndices = {};

  Future<void> _takePhoto() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> _choosePhoto() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_pickingImage || _analyzing) return;

    setState(() {
      _pickingImage = true;
      _analysisError = null;
    });

    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 95,
      );

      if (!mounted || image == null) return;

      setState(() {
        _selectedImage = image;
        _detections = [];
        _resetJack();
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
      _resetJack();
    });

    try {
      final detections =
          await PetanqueDetector.instance.detect(image.path);

      if (!mounted) return;

      final detectedJacks = detections
          .where(
            (detection) =>
                detection.type == PetanqueObjectType.cochonnet,
          )
          .toList()
        ..sort(
          (a, b) => b.confidence.compareTo(a.confidence),
        );

      Offset? proposedJack;
      if (detectedJacks.isNotEmpty) {
        final jack = detectedJacks.first;
        proposedJack = Offset(
          ((jack.left + jack.right) / 2).clamp(0.0, 1.0),
          ((jack.top + jack.bottom) / 2).clamp(0.0, 1.0),
        );
      }

      setState(() {
        _detections = detections;
        _jackPosition = proposedJack;
        _jackWasDetected = proposedJack != null;
        _jackConfirmed = false;
        _ballRanks = {};
      });
    } catch (e) {
      if (!mounted) return;
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

  void _resetJack() {
    _jackPosition = null;
    _jackConfirmed = false;
    _jackWasDetected = false;
    _ballRanks = {};
    _ignoredBallIndices.clear();
  }

  void _removePhoto() {
    if (_analyzing) return;

    setState(() {
      _selectedImage = null;
      _detections = [];
      _analysisError = null;
      _resetJack();
    });
  }

  void _setJackPosition(Offset normalizedPosition) {
    setState(() {
      _jackPosition = Offset(
        normalizedPosition.dx.clamp(0.0, 1.0),
        normalizedPosition.dy.clamp(0.0, 1.0),
      );
      _jackConfirmed = false;
      _jackWasDetected = false;
      _ballRanks = {};
    });
  }

  void _confirmJack() {
    if (_jackPosition == null) return;

    setState(() {
      _jackConfirmed = true;
      _computeBallRanking();
    });
  }

  void _repositionJack() {
    setState(() {
      _jackConfirmed = false;
      _ballRanks = {};
    });
  }

  void _computeBallRanking() {
    final jack = _jackPosition;
    if (jack == null) {
      _ballRanks = {};
      return;
    }

    final ranked = <_RankedBall>[];
    final jackBallIndex = _findBallDetectionAtJack(jack);

    for (final entry in _detections.asMap().entries) {
      final detection = entry.value;
      if (detection.type != PetanqueObjectType.boule) continue;
      if (_ignoredBallIndices.contains(entry.key)) continue;

      // Si V3 a classé le cochonnet comme une boule, la confirmation
      // utilisateur a priorité : cette détection est exclue du classement.
      if (entry.key == jackBallIndex) continue;

      // Point utile de la boule : bas-centre de la bounding box, qui est une
      // meilleure approximation du contact au sol que le centre de la sphère.
      final groundPoint = Offset(
        ((detection.left + detection.right) / 2).clamp(0.0, 1.0),
        detection.bottom.clamp(0.0, 1.0),
      );

      ranked.add(
        _RankedBall(
          detectionIndex: entry.key,
          distance: (groundPoint - jack).distance,
        ),
      );
    }

    ranked.sort((a, b) => a.distance.compareTo(b.distance));

    _ballRanks = {
      for (var i = 0; i < ranked.length; i++)
        ranked[i].detectionIndex: i + 1,
    };
  }

  int? _findBallDetectionAtJack(Offset jack) {
    int? bestIndex;
    double? bestScore;

    for (final entry in _detections.asMap().entries) {
      final detection = entry.value;
      if (detection.type != PetanqueObjectType.boule) continue;

      final center = Offset(
        (detection.left + detection.right) / 2,
        (detection.top + detection.bottom) / 2,
      );
      final width = (detection.right - detection.left).abs();
      final height = (detection.bottom - detection.top).abs();
      final radius = (width > height ? width : height) / 2;

      final insideBox =
          jack.dx >= detection.left &&
          jack.dx <= detection.right &&
          jack.dy >= detection.top &&
          jack.dy <= detection.bottom;

      final distance = (jack - center).distance;

      // Un tap légèrement à côté du centre reste accepté, mais on évite
      // d'exclure une vraie boule voisine : la tolérance dépend directement
      // de la taille de la détection concernée.
      final tolerance = radius * 1.35;
      if (!insideBox && distance > tolerance) continue;

      final score = radius <= 0 ? distance : distance / radius;
      if (bestScore == null || score < bestScore) {
        bestScore = score;
        bestIndex = entry.key;
      }
    }

    return bestIndex;
  }

  bool get _isProbablyWideView {
    final balls = _detections
        .where((d) => d.type == PetanqueObjectType.boule)
        .toList();
    if (balls.length < 3) return false;

    final apparentSizes = balls
        .map((d) {
          final width = (d.right - d.left).abs();
          final height = (d.bottom - d.top).abs();
          return width > height ? width : height;
        })
        .toList()
      ..sort();

    final medianSize = apparentSizes[apparentSizes.length ~/ 2];
    final centers = balls
        .map(
          (d) => Offset(
            (d.left + d.right) / 2,
            (d.top + d.bottom) / 2,
          ),
        )
        .toList();

    final minX = centers.map((p) => p.dx).reduce((a, b) => a < b ? a : b);
    final maxX = centers.map((p) => p.dx).reduce((a, b) => a > b ? a : b);
    final minY = centers.map((p) => p.dy).reduce((a, b) => a < b ? a : b);
    final maxY = centers.map((p) => p.dy).reduce((a, b) => a > b ? a : b);

    // Heuristique volontairement prudente et non bloquante : des boules très
    // petites ou très dispersées indiquent souvent une vue générale de partie
    // plutôt qu'un cadrage centré sur le point.
    return medianSize < 0.055 ||
        (maxX - minX) > 0.78 ||
        (maxY - minY) > 0.78;
  }

  Future<void> _handleImageTap(Offset normalizedPosition) async {
    if (!_jackConfirmed) {
      _setJackPosition(normalizedPosition);
      return;
    }

    final detectionIndex = _findBallDetectionAtPosition(normalizedPosition);
    if (detectionIndex == null || _ignoredBallIndices.contains(detectionIndex)) {
      return;
    }

    final shouldIgnore = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Fausse détection ?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Si cet objet n’est pas une boule utile pour le point, vous pouvez l’ignorer. '
                'Le classement sera recalculé immédiatement.',
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.visibility_off),
                label: const Text('Ignorer cette détection'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted || shouldIgnore != true) return;
    setState(() {
      _ignoredBallIndices.add(detectionIndex);
      _computeBallRanking();
    });
  }

  int? _findBallDetectionAtPosition(Offset position) {
    int? bestIndex;
    double? bestDistance;

    for (final entry in _detections.asMap().entries) {
      if (_ignoredBallIndices.contains(entry.key)) continue;
      final detection = entry.value;
      if (detection.type != PetanqueObjectType.boule) continue;

      final center = Offset(
        (detection.left + detection.right) / 2,
        (detection.top + detection.bottom) / 2,
      );
      final width = (detection.right - detection.left).abs();
      final height = (detection.bottom - detection.top).abs();
      final radius = (width > height ? width : height) / 2;
      final distance = (position - center).distance;
      final inside = position.dx >= detection.left &&
          position.dx <= detection.right &&
          position.dy >= detection.top &&
          position.dy <= detection.bottom;

      if (!inside && distance > radius * 1.35) continue;
      if (bestDistance == null || distance < bestDistance) {
        bestDistance = distance;
        bestIndex = entry.key;
      }
    }
    return bestIndex;
  }

  void _restoreIgnoredBalls() {
    setState(() {
      _ignoredBallIndices.clear();
      if (_jackConfirmed) _computeBallRanking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bouleCount = _detections
        .where(
          (detection) => detection.type == PetanqueObjectType.boule,
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
            'Cadrez le cochonnet et les boules susceptibles de prendre le point.',
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
              jackPosition: _jackPosition,
              jackConfirmed: _jackConfirmed,
              ballRanks: _ballRanks,
              ignoredBallIndices: _ignoredBallIndices,
              onImageTap: _handleImageTap,
            ),
            const SizedBox(height: 8),
            Text(
              _jackConfirmed
                  ? 'Pincez pour zoomer • Touchez une fausse boule pour l’ignorer'
                  : 'Pincez pour zoomer • Touchez le vrai cochonnet pour corriger sa position',
              textAlign: TextAlign.center,
            ),
            if (!_analyzing && _isProbablyWideView) ...[
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.photo_size_select_large),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Vue possiblement trop large. Pour un classement plus fiable, '
                          'rapprochez-vous du cochonnet et cadrez surtout les boules susceptibles de prendre le point.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            _JackValidationCard(
              jackPosition: _jackPosition,
              jackConfirmed: _jackConfirmed,
              jackWasDetected: _jackWasDetected,
              onConfirm: _confirmJack,
              onReposition: _repositionJack,
            ),
            if (_jackConfirmed && _ballRanks.isNotEmpty) ...[
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.format_list_numbered),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ordre des boules',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${_ballRanks.length} boule${_ballRanks.length > 1 ? 's' : ''} classée${_ballRanks.length > 1 ? 's' : ''}. '
                              '1 est la plus proche du cochonnet.',
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Les joueurs identifient ensuite à qui appartiennent les boules. '
                              'Aucune attribution d’équipe n’est nécessaire dans l’application.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_ignoredBallIndices.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _restoreIgnoredBalls,
                icon: const Icon(Icons.restore),
                label: Text(
                  'Réafficher ${_ignoredBallIndices.length} détection${_ignoredBallIndices.length > 1 ? 's' : ''} ignorée${_ignoredBallIndices.length > 1 ? 's' : ''}',
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickingImage || _analyzing
                        ? null
                        : _choosePhoto,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Changer'),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _pickingImage || _analyzing
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
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text('Analyse de la photo en cours...'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error_outline),
                          SizedBox(width: 8),
                          Text(
                            'Erreur pendant l\'analyse',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$bouleCount boule${bouleCount > 1 ? 's' : ''} '
                        'détectée${bouleCount > 1 ? 's' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$cochonnetCount cochonnet${cochonnetCount > 1 ? 's' : ''} '
                        'détecté${cochonnetCount > 1 ? 's' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (_detections.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ..._detections.asMap().entries.map((entry) {
                          final detection = entry.value;
                          final rank = _ballRanks[entry.key];
                          final ignored = _ignoredBallIndices.contains(entry.key);
                          final rankText = rank == null ? '' : ' • rang $rank';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${detection.label} — '
                              '${(detection.confidence * 100).toStringAsFixed(1)} %'
                              '$rankText${ignored ? ' • ignorée' : ''}',
                            ),
                          );
                        }),
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
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}

class _JackValidationCard extends StatelessWidget {
  const _JackValidationCard({
    required this.jackPosition,
    required this.jackConfirmed,
    required this.jackWasDetected,
    required this.onConfirm,
    required this.onReposition,
  });

  final Offset? jackPosition;
  final bool jackConfirmed;
  final bool jackWasDetected;
  final VoidCallback onConfirm;
  final VoidCallback onReposition;

  @override
  Widget build(BuildContext context) {
    if (jackPosition == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.touch_app),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Cochonnet non détecté. Zoomez si nécessaire puis touchez '
                  'son centre sur la photo.',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (jackConfirmed) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle_outline),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Cochonnet confirmé',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onReposition,
                icon: const Icon(Icons.my_location),
                label: const Text('Repositionner le cochonnet'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              jackWasDetected
                  ? 'Cochonnet détecté : est-ce bien lui ?'
                  : 'Position manuelle du cochonnet',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              jackWasDetected
                  ? 'Vérifiez le viseur C sur la photo. Si sa position est mauvaise, touchez directement le vrai cochonnet.'
                  : 'Vérifiez le viseur C. Vous pouvez retoucher la photo pour ajuster sa position.',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.check),
              label: const Text('Confirmer le cochonnet'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetectionImage extends StatelessWidget {
  const _DetectionImage({
    required this.imageFile,
    required this.detections,
    required this.jackPosition,
    required this.jackConfirmed,
    required this.ballRanks,
    required this.ignoredBallIndices,
    required this.onImageTap,
  });

  final File imageFile;
  final List<PetanqueDetection> detections;
  final Offset? jackPosition;
  final bool jackConfirmed;
  final Map<int, int> ballRanks;
  final Set<int> ignoredBallIndices;
  final ValueChanged<Offset> onImageTap;

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
                return Image.file(imageFile, fit: BoxFit.contain);
              }

              final imageSize = snapshot.data!;
              final displayWidth = constraints.maxWidth;
              final displayHeight =
                  displayWidth * imageSize.height / imageSize.width;
              final displaySize = Size(displayWidth, displayHeight);

              return SizedBox(
                width: displayWidth,
                height: displayHeight,
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 8.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  boundaryMargin: EdgeInsets.symmetric(
                    horizontal: displayWidth,
                    vertical: displayHeight,
                  ),
                  constrained: true,
                  clipBehavior: Clip.hardEdge,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) {
                      final position = details.localPosition;
                      onImageTap(
                        Offset(
                          (position.dx / displaySize.width).clamp(0.0, 1.0),
                          (position.dy / displaySize.height).clamp(0.0, 1.0),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: displayWidth,
                      height: displayHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(imageFile, fit: BoxFit.fill),
                          IgnorePointer(
                            child: CustomPaint(
                              painter: _DetectionPainter(
                                detections: detections,
                                jackPosition: jackPosition,
                                jackConfirmed: jackConfirmed,
                                ballRanks: ballRanks,
                                ignoredBallIndices: ignoredBallIndices,
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
    required this.jackPosition,
    required this.jackConfirmed,
    required this.ballRanks,
    required this.ignoredBallIndices,
  });

  final List<PetanqueDetection> detections;
  final Offset? jackPosition;
  final bool jackConfirmed;
  final Map<int, int> ballRanks;
  final Set<int> ignoredBallIndices;

  @override
  void paint(Canvas canvas, Size size) {
    for (final entry in detections.asMap().entries) {
      final detection = entry.value;
      if (ignoredBallIndices.contains(entry.key)) continue;

      // Les détections de cochonnet brutes ne sont volontairement plus
      // dessinées : un seul cochonnet de référence est affiché, celui que
      // l'utilisateur doit confirmer ou qu'il a positionné manuellement.
      if (detection.type == PetanqueObjectType.cochonnet) continue;

      // Dès qu'un viseur C est posé sur une détection classée "boule",
      // l'intention utilisateur prime : on ne dessine plus cette détection
      // comme une boule. Le classement applique exactement la même règle.
      if (jackPosition != null &&
          _isBallDetectionAtJack(detection, jackPosition!)) {
        continue;
      }

      final rect = Rect.fromLTRB(
        detection.left * size.width,
        detection.top * size.height,
        detection.right * size.width,
        detection.bottom * size.height,
      );

      final rank = ballRanks[entry.key];
      final color = rank == null
          ? Colors.green.shade700
          : _rankColor(rank);

      final boxPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = rank == null ? 3 : 4
        ..color = color;

      canvas.drawRect(rect, boxPaint);

      if (rank != null) {
        _drawRankBadge(canvas, size, rect, rank, color);
      }
    }

    final jack = jackPosition;
    if (jack != null) {
      _drawJackMarker(
        canvas,
        Offset(jack.dx * size.width, jack.dy * size.height),
      );
    }
  }

  bool _isBallDetectionAtJack(
    PetanqueDetection detection,
    Offset jack,
  ) {
    if (detection.type != PetanqueObjectType.boule) return false;

    final center = Offset(
      (detection.left + detection.right) / 2,
      (detection.top + detection.bottom) / 2,
    );
    final width = (detection.right - detection.left).abs();
    final height = (detection.bottom - detection.top).abs();
    final radius = (width > height ? width : height) / 2;

    final insideBox =
        jack.dx >= detection.left &&
        jack.dx <= detection.right &&
        jack.dy >= detection.top &&
        jack.dy <= detection.bottom;

    return insideBox || (jack - center).distance <= radius * 1.35;
  }

  void _drawRankBadge(
    Canvas canvas,
    Size size,
    Rect rect,
    int rank,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$rank',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final diameter = (textPainter.width > textPainter.height
            ? textPainter.width
            : textPainter.height) +
        12;

    final center = Offset(
      (rect.left + rect.right) / 2,
      (rect.top + rect.bottom) / 2,
    );

    final badgeCenter = Offset(
      center.dx.clamp(diameter / 2, size.width - diameter / 2),
      center.dy.clamp(diameter / 2, size.height - diameter / 2),
    );

    canvas.drawCircle(
      badgeCenter,
      diameter / 2,
      Paint()..color = color,
    );

    canvas.drawCircle(
      badgeCenter,
      diameter / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white,
    );

    textPainter.paint(
      canvas,
      Offset(
        badgeCenter.dx - textPainter.width / 2,
        badgeCenter.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawJackMarker(Canvas canvas, Offset point) {
    final color = jackConfirmed
        ? Colors.green.shade800
        : Colors.orange.shade800;

    const radius = 13.0;

    canvas.drawCircle(
      point,
      radius + 3,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white,
    );

    canvas.drawCircle(
      point,
      radius,
      Paint()..color = color,
    );

    canvas.drawLine(
      Offset(point.dx - 20, point.dy),
      Offset(point.dx + 20, point.dy),
      Paint()
        ..strokeWidth = 2
        ..color = Colors.white,
    );
    canvas.drawLine(
      Offset(point.dx, point.dy - 20),
      Offset(point.dx, point.dy + 20),
      Paint()
        ..strokeWidth = 2
        ..color = Colors.white,
    );

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'C',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        point.dx - textPainter.width / 2,
        point.dy - textPainter.height / 2,
      ),
    );
  }

  Color _rankColor(int rank) {
    // Le numéro reste l'information principale. Les couleurs servent seulement
    // à accélérer la lecture visuelle des premières positions.
    return switch (rank) {
      1 => Colors.red.shade700,
      2 => Colors.orange.shade700,
      3 => Colors.amber.shade800,
      _ => Colors.blueGrey.shade700,
    };
  }

  @override
  bool shouldRepaint(covariant _DetectionPainter oldDelegate) {
    return oldDelegate.detections != detections ||
        oldDelegate.jackPosition != jackPosition ||
        oldDelegate.jackConfirmed != jackConfirmed ||
        oldDelegate.ballRanks != ballRanks ||
        oldDelegate.ignoredBallIndices != ignoredBallIndices;
  }
}
