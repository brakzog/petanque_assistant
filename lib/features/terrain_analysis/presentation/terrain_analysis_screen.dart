import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../domain/team.dart';
import '../../tournaments/services/petanque_detector.dart';
import 'petanque_camera_screen.dart';

class TerrainAnalysisScreen extends StatefulWidget {
  const TerrainAnalysisScreen({
    super.key,
    this.teamA,
    this.teamB,
  });

  // Restent optionnelles pour garder la compatibilité avec MatchLiveScreen.
  final Team? teamA;
  final Team? teamB;

  @override
  State<TerrainAnalysisScreen> createState() => _TerrainAnalysisScreenState();
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

  Offset? _jackPosition;
  bool _jackConfirmed = false;
  bool _jackWasDetected = false;

  Map<int, int> _ballRanks = {};
  List<_RankedBall> _rankedBalls = [];
  int? _jackBallDetectionIndex;
  bool _guidedCapture = false;
  double? _captureTiltDegrees;
  double _imageAspectRatio = 1.0;

  Future<void> _takePhoto() async {
    if (_pickingImage || _analyzing) return;
    final result = await Navigator.of(context).push<PetanqueCameraResult>(
      MaterialPageRoute(builder: (_) => const PetanqueCameraScreen()),
    );
    if (!mounted || result == null) return;
    await _useCapturedPhoto(result);
  }

  Future<void> _useCapturedPhoto(PetanqueCameraResult result) async {
    setState(() {
      _pickingImage = true;
      _analysisError = null;
    });
    try {
      final normalized = await _normalizeOrientation(result.image);
      if (!mounted) return;
      setState(() {
        _selectedImage = normalized;
        _guidedCapture = true;
        _captureTiltDegrees = result.tiltDegrees;
        _detections = [];
        _resetJack();
      });
      await _analyzeImage(normalized);
    } catch (e) {
      if (mounted) setState(() => _analysisError = e.toString());
    } finally {
      if (mounted) setState(() => _pickingImage = false);
    }
  }
  Future<void> _choosePhoto() async {
    _guidedCapture = false;
    _captureTiltDegrees = null;
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_pickingImage || _analyzing) return;

    setState(() {
      _pickingImage = true;
      _analysisError = null;
    });

    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 95,
      );

      if (!mounted || picked == null) return;

      final normalized = await _normalizeOrientation(picked);
      if (!mounted) return;

      setState(() {
        _selectedImage = normalized;
        _detections = [];
        _resetJack();
      });

      await _analyzeImage(normalized);
    } catch (e) {
      if (!mounted) return;
      setState(() => _analysisError = e.toString());
    } finally {
      if (mounted) {
        setState(() => _pickingImage = false);
      }
    }
  }

  Future<XFile> _normalizeOrientation(XFile source) async {
    final bytes = await source.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return source;

    final oriented = img.bakeOrientation(decoded);
    _imageAspectRatio = oriented.width / oriented.height;
    final directory = await getTemporaryDirectory();
    final file = File(
      p.join(
        directory.path,
        'petanque_analysis_${DateTime.now().microsecondsSinceEpoch}.jpg',
      ),
    );

    await file.writeAsBytes(
      img.encodeJpg(oriented, quality: 95),
      flush: true,
    );
    return XFile(file.path);
  }

  Future<void> _analyzeImage(XFile image) async {
    setState(() {
      _analyzing = true;
      _analysisError = null;
      _detections = [];
      _resetJack();
    });

    try {
      final detections = await PetanqueDetector.instance.detect(image.path);
      if (!mounted) return;

      final detectedJacks = detections
          .where((d) => d.type == PetanqueObjectType.cochonnet)
          .toList()
        ..sort((a, b) => b.confidence.compareTo(a.confidence));

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
        _rankedBalls = [];
        _jackBallDetectionIndex =
            proposedJack == null ? null : _findBallAtJack(proposedJack);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _analysisError = e.toString());
    } finally {
      if (mounted) setState(() => _analyzing = false);
    }
  }

  void _resetJack() {
    _jackPosition = null;
    _jackConfirmed = false;
    _jackWasDetected = false;
    _ballRanks = {};
    _rankedBalls = [];
    _jackBallDetectionIndex = null;
  }

  void _removePhoto() {
    if (_analyzing) return;
    setState(() {
      _selectedImage = null;
      _guidedCapture = false;
      _captureTiltDegrees = null;
      _detections = [];
      _analysisError = null;
      _resetJack();
    });
  }

  void _setJackPosition(Offset normalizedPosition) {
    final position = Offset(
      normalizedPosition.dx.clamp(0.0, 1.0),
      normalizedPosition.dy.clamp(0.0, 1.0),
    );

    setState(() {
      _jackPosition = position;
      _jackConfirmed = false;
      _jackWasDetected = false;
      _ballRanks = {};
      _rankedBalls = [];
      _jackBallDetectionIndex = _findBallAtJack(position);
    });
  }

  void _confirmJack() {
    if (_jackPosition == null) return;
    setState(() {
      _jackConfirmed = true;
      _jackBallDetectionIndex = _findBallAtJack(_jackPosition!);
      _computeBallRanking();
    });
  }

  void _repositionJack() {
    setState(() {
      _jackConfirmed = false;
      _ballRanks = {};
      _rankedBalls = [];
    });
  }

  int? _findBallAtJack(Offset jack) {
    int? bestIndex;
    double bestDistance = double.infinity;

    for (final entry in _detections.asMap().entries) {
      final d = entry.value;
      if (d.type != PetanqueObjectType.boule) continue;

      final center = Offset(
        (d.left + d.right) / 2,
        (d.top + d.bottom) / 2,
      );
      final size = math.max(
        (d.right - d.left).abs(),
        (d.bottom - d.top).abs(),
      );
      final distance = (center - jack).distance;

      // On n'enlève qu'UNE détection et uniquement si le viseur du cochonnet
      // tombe réellement sur sa bounding box (avec une petite marge).
      final insideWithMargin =
          jack.dx >= d.left - size * 0.15 &&
          jack.dx <= d.right + size * 0.15 &&
          jack.dy >= d.top - size * 0.15 &&
          jack.dy <= d.bottom + size * 0.15;

      if (insideWithMargin && distance < bestDistance) {
        bestDistance = distance;
        bestIndex = entry.key;
      }
    }
    return bestIndex;
  }

  Offset _groundPoint(PetanqueDetection d) {
    final x = ((d.left + d.right) / 2).clamp(0.0, 1.0);
    if (_guidedCapture) {
      return Offset(
        x,
        ((d.top + d.bottom) / 2).clamp(0.0, 1.0),
      );
    }
    return Offset(x, d.bottom.clamp(0.0, 1.0));
  }

  double _apparentDiameter(PetanqueDetection d) {
    final w = (d.right - d.left).abs();
    final h = (d.bottom - d.top).abs();
    return math.sqrt(math.max(w * h, 1e-8));
  }

  void _computeBallRanking() {
    final jack = _jackPosition;
    if (jack == null) return;

    final ranked = <_RankedBall>[];

    for (final entry in _detections.asMap().entries) {
      final d = entry.value;
      if (d.type != PetanqueObjectType.boule) continue;
      if (entry.key == _jackBallDetectionIndex) continue;

      final point = _groundPoint(d);

      double correctedDistance;
      if (_guidedCapture) {
        // La caméra guidée n'autorise la prise que téléphone quasi parallèle
        // au terrain. Dans cette configuration, le plan image est quasi
        // parallèle au plan du sol : une distance 2D corrigée du ratio de
        // l'image conserve directement l'ordre des distances sur le terrain.
        //
        // x et y sont normalisés 0..1 ; multiplier x par le ratio largeur /
        // hauteur remet les deux axes dans la même unité image.
        final image = _selectedImage;
        if (image == null) continue;
        final dx = point.dx - jack.dx;
        final dy = point.dy - jack.dy;
        final dxAspect = dx * _imageAspectRatio;
        correctedDistance = math.sqrt(dxAspect * dxAspect + dy * dy);
      } else {
        // Galerie / ancienne photo : on n'a pas l'inclinaison au déclenchement.
        // On conserve le fallback historique par diamètre apparent.
        final imageDistance = (point - jack).distance;
        correctedDistance =
            imageDistance / math.max(_apparentDiameter(d), 1e-6);
      }

      ranked.add(
        _RankedBall(
          detectionIndex: entry.key,
          distance: correctedDistance,
        ),
      );
    }

    ranked.sort((a, b) => a.distance.compareTo(b.distance));
    _rankedBalls = ranked;
    _ballRanks = {
      for (var i = 0; i < ranked.length; i++)
        ranked[i].detectionIndex: i + 1,
    };
  }

  bool get _closeResult {
    if (_rankedBalls.length < 2) return false;
    final first = _rankedBalls[0].distance;
    final second = _rankedBalls[1].distance;
    if (first <= 1e-9) return true;
    return (second - first).abs() / first < 0.08;
  }

  bool get _possiblyTooWide {
    final balls = _detections
        .where((d) => d.type == PetanqueObjectType.boule)
        .toList();
    if (balls.isEmpty) return false;

    final diameters = balls.map(_apparentDiameter).toList()..sort();
    return diameters[diameters.length ~/ 2] < 0.022;
  }

  @override
  Widget build(BuildContext context) {
    final bouleCount = _detections.asMap().entries.where((entry) {
      return entry.value.type == PetanqueObjectType.boule &&
          entry.key != _jackBallDetectionIndex;
    }).length;

    final cochonnetCount = _detections
        .where((d) => d.type == PetanqueObjectType.cochonnet)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Quelle boule est devant ?')),
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
              onPressed: _pickingImage || _analyzing ? null : _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Prendre une photo'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickingImage || _analyzing ? null : _choosePhoto,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choisir dans la galerie'),
            ),
          ] else ...[
            _DetectionImage(
              imageFile: File(_selectedImage!.path),
              detections: _detections,
              ignoredDetectionIndex: _jackBallDetectionIndex,
              jackPosition: _jackPosition,
              jackConfirmed: _jackConfirmed,
              ballRanks: _ballRanks,
              onJackTap: _setJackPosition,
            ),
            const SizedBox(height: 8),
            if (_guidedCapture && _captureTiltDegrees != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.screen_rotation_alt),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Prise guidée • inclinaison ${_captureTiltDegrees!.toStringAsFixed(1)}° • géométrie terrain activée',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ] else ...[
              const _WarningCard(
                icon: Icons.photo_library_outlined,
                title: 'Photo de galerie',
                message:
                    'L’inclinaison au déclenchement est inconnue : classement en mode estimé.',
              ),
              const SizedBox(height: 8),
            ],
            Text(
              _jackConfirmed
                  ? 'Pincez pour zoomer • Le cochonnet est confirmé'
                  : 'Pincez pour zoomer • Touchez le vrai cochonnet pour corriger sa position',
              textAlign: TextAlign.center,
            ),
            if (_possiblyTooWide) ...[
              const SizedBox(height: 12),
              const _WarningCard(
                icon: Icons.zoom_out_map,
                title: 'Vue possiblement trop large',
                message:
                    'Les boules sont petites dans l’image. Rapprochez-vous si possible pour améliorer la précision.',
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
                              '${_ballRanks.length} boule${_ballRanks.length > 1 ? 's' : ''} '
                              'classée${_ballRanks.length > 1 ? 's' : ''}. '
                              '1 est la plus proche du cochonnet.',
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Le classement applique une correction de perspective relative. '
                              'Aucune fausse distance en centimètres n’est affichée.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_closeResult) ...[
                const SizedBox(height: 12),
                const _WarningCard(
                  icon: Icons.straighten,
                  title: 'Résultat très serré',
                  message:
                      'Possible besoin de revue au mètre : les deux premières boules sont très proches.',
                ),
              ],
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        _pickingImage || _analyzing ? null : _choosePhoto,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Changer'),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed:
                      _pickingImage || _analyzing ? null : _removePhoto,
                  tooltip: 'Supprimer la photo',
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Résultat de l’analyse',
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
                      Expanded(child: Text('Analyse de la photo en cours...')),
                    ],
                  ),
                ),
              )
            else if (_analysisError != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(_analysisError!),
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
                        ..._detections.asMap().entries
                            .where((e) => e.key != _jackBallDetectionIndex)
                            .map((entry) {
                          final d = entry.value;
                          final rank = _ballRanks[entry.key];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${d.label} — '
                              '${(d.confidence * 100).toStringAsFixed(1)} %'
                              '${rank == null ? '' : ' • rang $rank'}',
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

class _WarningCard extends StatelessWidget {
  const _WarningCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.onTertiaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.onTertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(color: colors.onTertiaryContainer),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  'Cochonnet non détecté. Zoomez si nécessaire puis touchez son centre sur la photo.',
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
                  ? 'Vérifiez le viseur C sur la photo. Sinon, touchez directement le vrai cochonnet.'
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
    required this.ignoredDetectionIndex,
    required this.jackPosition,
    required this.jackConfirmed,
    required this.ballRanks,
    required this.onJackTap,
  });

  final File imageFile;
  final List<PetanqueDetection> detections;
  final int? ignoredDetectionIndex;
  final Offset? jackPosition;
  final bool jackConfirmed;
  final Map<int, int> ballRanks;
  final ValueChanged<Offset> onJackTap;

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
              final imageRatio = imageSize.width / imageSize.height;
              final maxWidth = constraints.maxWidth;
              final maxHeight = MediaQuery.sizeOf(context).height * 0.68;

              double displayWidth = maxWidth;
              double displayHeight = displayWidth / imageRatio;

              if (displayHeight > maxHeight) {
                displayHeight = maxHeight;
                displayWidth = displayHeight * imageRatio;
              }

              final displaySize = Size(displayWidth, displayHeight);

              return Center(
                child: SizedBox(
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
                        final pos = details.localPosition;
                        onJackTap(
                          Offset(
                            (pos.dx / displaySize.width).clamp(0.0, 1.0),
                            (pos.dy / displaySize.height).clamp(0.0, 1.0),
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
                                  ignoredDetectionIndex:
                                      ignoredDetectionIndex,
                                  jackPosition: jackPosition,
                                  jackConfirmed: jackConfirmed,
                                  ballRanks: ballRanks,
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
          );
        },
      ),
    );
  }

  Future<Size> _getImageSize(File file) async {
    final decoded = await decodeImageFromList(await file.readAsBytes());
    return Size(decoded.width.toDouble(), decoded.height.toDouble());
  }
}

class _DetectionPainter extends CustomPainter {
  const _DetectionPainter({
    required this.detections,
    required this.ignoredDetectionIndex,
    required this.jackPosition,
    required this.jackConfirmed,
    required this.ballRanks,
  });

  final List<PetanqueDetection> detections;
  final int? ignoredDetectionIndex;
  final Offset? jackPosition;
  final bool jackConfirmed;
  final Map<int, int> ballRanks;

  @override
  void paint(Canvas canvas, Size size) {
    for (final entry in detections.asMap().entries) {
      if (entry.key == ignoredDetectionIndex) continue;

      final detection = entry.value;
      if (detection.type == PetanqueObjectType.cochonnet) continue;

      final rect = Rect.fromLTRB(
        detection.left * size.width,
        detection.top * size.height,
        detection.right * size.width,
        detection.bottom * size.height,
      );

      final rank = ballRanks[entry.key];
      final color =
          rank == null ? Colors.green.shade700 : _rankColor(rank);

      canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = rank == null ? 3 : 4
          ..color = color,
      );

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

    final diameter =
        math.max(textPainter.width, textPainter.height) + 12;
    final center = rect.center;
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
    final color =
        jackConfirmed ? Colors.green.shade800 : Colors.orange.shade800;
    const radius = 13.0;

    canvas.drawCircle(
      point,
      radius + 3,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white,
    );
    canvas.drawCircle(point, radius, Paint()..color = color);

    final linePaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.white;
    canvas.drawLine(
      Offset(point.dx - 20, point.dy),
      Offset(point.dx + 20, point.dy),
      linePaint,
    );
    canvas.drawLine(
      Offset(point.dx, point.dy - 20),
      Offset(point.dx, point.dy + 20),
      linePaint,
    );

    final tp = TextPainter(
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
    tp.paint(
      canvas,
      Offset(point.dx - tp.width / 2, point.dy - tp.height / 2),
    );
  }

  Color _rankColor(int rank) => switch (rank) {
        1 => Colors.red.shade700,
        2 => Colors.orange.shade700,
        3 => Colors.amber.shade800,
        _ => Colors.blueGrey.shade700,
      };

  @override
  bool shouldRepaint(covariant _DetectionPainter oldDelegate) {
    return oldDelegate.detections != detections ||
        oldDelegate.ignoredDetectionIndex != ignoredDetectionIndex ||
        oldDelegate.jackPosition != jackPosition ||
        oldDelegate.jackConfirmed != jackConfirmed ||
        oldDelegate.ballRanks != ballRanks;
  }
}
