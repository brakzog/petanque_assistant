import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/team.dart';
import '../services/ground_geometry.dart';
import '../services/petanque_detector.dart';
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
class _MeasuredBall {
  const _MeasuredBall({
    required this.index,
    required this.owner,
    required this.distance,
  });
  final int index;
  final _BallOwner owner;
  final double distance;
}
class _PointAnalysisResult {
  const _PointAnalysisResult({
    required this.uncertain,
    required this.message,
    this.owner,
    this.points = 0,
  });
  final bool uncertain;
  final String message;
  final _BallOwner? owner;
  final int points;
}
class _TerrainAnalysisScreenState extends State<TerrainAnalysisScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _pickingImage = false;
  bool _analyzing = false;
  String? _analysisError;
  List<PetanqueDetection> _detections = [];
  final Map<int, _BallOwner> _ballOwners = {};
  _PointAnalysisResult? _pointAnalysis;
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
        _ballOwners.clear();
        _pointAnalysis = null;
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
      _pointAnalysis = null;
    });
    try {
      final detections =
          await PetanqueDetector.instance.detect(image.path);
      if (!mounted) return;
      setState(() {
        _detections = detections;
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
  void _removePhoto() {
    if (_analyzing) return;
    setState(() {
      _selectedImage = null;
      _detections = [];
      _ballOwners.clear();
      _analysisError = null;
      _pointAnalysis = null;
    });
  }
  Future<void> _assignBall(int detectionIndex) async {
    final detection = _detections[detectionIndex];
    if (detection.type != PetanqueObjectType.boule) return;
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
                  onPressed: () =>
                      Navigator.pop(context, _BallOwner.teamA),
                  child: Text('A — ${widget.teamA.name}'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: () =>
                      Navigator.pop(context, _BallOwner.teamB),
                  child: Text('B — ${widget.teamB.name}'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () =>
                      Navigator.pop(context, _BallOwner.unknown),
                  child: const Text('Indéterminée'),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (result == null || !mounted) return;
    setState(() {
      _ballOwners[detectionIndex] = result;
      _pointAnalysis = null;
    });
  }
  Future<void> _analyzePoint() async {
    final cochonnets = _detections
        .where(
          (detection) =>
              detection.type == PetanqueObjectType.cochonnet,
        )
        .toList();
    if (cochonnets.isEmpty) {
      _setPointAnalysis(
        const _PointAnalysisResult(
          uncertain: true,
          message:
              'Impossible de déterminer le point : aucun cochonnet détecté.',
        ),
      );
      return;
    }
    // V0 : en cas de plusieurs détections de cochonnet, on prend celle
    // ayant la meilleure confiance. Plus tard, l'utilisateur pourra
    // confirmer/corriger explicitement le cochonnet retenu.
    cochonnets.sort(
      (a, b) => b.confidence.compareTo(a.confidence),
    );
    final jack = cochonnets.first;
    if (_selectedImage == null) return;
    final decodedImage = await decodeImageFromList(
      await File(_selectedImage!.path).readAsBytes(),
    );
    if (!mounted) return;
    final geometry = GroundGeometry.build(
      detections: _detections,
      imageSize: Size(
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble(),
      ),
    );
    final unassignedBallCount = _detections
        .asMap()
        .entries
        .where((entry) {
          if (entry.value.type != PetanqueObjectType.boule) {
            return false;
          }
          final owner = _ballOwners[entry.key];
          return owner == null || owner == _BallOwner.unknown;
        })
        .length;
    if (unassignedBallCount > 0) {
      _setPointAnalysis(
        _PointAnalysisResult(
          uncertain: true,
          message:
              '$unassignedBallCount boule${unassignedBallCount > 1 ? 's' : ''} '
              '${unassignedBallCount > 1 ? 'ne sont pas attribuées' : 'n’est pas attribuée'}. '
              'Attribuez les boules à A ou B avant de calculer le point.',
        ),
      );
      return;
    }
    final measuredBalls = <_MeasuredBall>[];
    for (final entry in _detections.asMap().entries) {
      final index = entry.key;
      final detection = entry.value;
      if (detection.type != PetanqueObjectType.boule) continue;
      final owner = _ballOwners[index];
      if (owner == null || owner == _BallOwner.unknown) continue;
      measuredBalls.add(
        _MeasuredBall(
          index: index,
          owner: owner,
          distance: geometry.distanceMm(detection, jack),
        ),
      );
    }
    final teamABalls = measuredBalls
        .where((ball) => ball.owner == _BallOwner.teamA)
        .toList();
    final teamBBalls = measuredBalls
        .where((ball) => ball.owner == _BallOwner.teamB)
        .toList();
    if (teamABalls.isEmpty || teamBBalls.isEmpty) {
      _setPointAnalysis(
        const _PointAnalysisResult(
          uncertain: true,
          message:
              'Il faut au moins une boule attribuée à chaque équipe pour comparer le point.',
        ),
      );
      return;
    }
    measuredBalls.sort(
      (a, b) => a.distance.compareTo(b.distance),
    );
    final closest = measuredBalls.first;
    final opponentBalls = measuredBalls
        .where((ball) => ball.owner != closest.owner)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
    final opponentClosest = opponentBalls.first;
    final difference = opponentClosest.distance - closest.distance;
    final referenceDistance =
        opponentClosest.distance > closest.distance
            ? opponentClosest.distance
            : closest.distance;
    final relativeDifference = referenceDistance <= 0
        ? 0.0
        : difference.abs() / referenceDistance;
    // Première correction locale de perspective. On reste volontairement
    // prudent tant que nous n'avons pas une rectification complète du sol.
    final differenceMm = difference.abs();
    if (differenceMm < 10.0 || relativeDifference < 0.10) {
      _setPointAnalysis(
        _PointAnalysisResult(
          uncertain: true,
          message:
              'Les deux meilleures boules sont trop proches pour cette estimation corrigée '
              '(${differenceMm.toStringAsFixed(0)} mm d’écart estimé). '
              'Mesure manuelle recommandée.',
        ),
      );
      return;
    }
    final points = measuredBalls
        .where(
          (ball) =>
              ball.owner == closest.owner &&
              ball.distance < opponentClosest.distance,
        )
        .length;
    final teamName = closest.owner == _BallOwner.teamA
        ? widget.teamA.name
        : widget.teamB.name;
    _setPointAnalysis(
      _PointAnalysisResult(
        uncertain: false,
        owner: closest.owner,
        points: points,
        message: points == 1
            ? '$teamName a actuellement le point. '
                'Écart estimé avec la meilleure boule adverse : '
                '${differenceMm.toStringAsFixed(0)} mm.'
            : '$teamName a actuellement $points points. '
                'Écart estimé avec la meilleure boule adverse : '
                '${differenceMm.toStringAsFixed(0)} mm.',
      ),
    );
  }
  void _setPointAnalysis(_PointAnalysisResult result) {
    setState(() {
      _pointAnalysis = result;
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
              ballOwners: _ballOwners,
              onBallTap: _assignBall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Pincez pour zoomer • Touchez une boule pour l’attribuer',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _TeamLegend(
              teamAName: widget.teamA.name,
              teamBName: widget.teamB.name,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _analyzing || _detections.isEmpty
                  ? null
                  : _analyzePoint,
              icon: const Icon(Icons.straighten),
              label: const Text('Qui a le point ?'),
            ),
            if (_pointAnalysis != null) ...[
              const SizedBox(height: 12),
              _PointAnalysisCard(result: _pointAnalysis!),
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
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
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
                          final index = entry.key;
                          final detection = entry.value;
                          final owner = _ballOwners[index];
                          final ownerText =
                              detection.type == PetanqueObjectType.boule
                                  ? switch (owner) {
                                      _BallOwner.teamA => ' • A',
                                      _BallOwner.teamB => ' • B',
                                      _BallOwner.unknown => ' • ?',
                                      null => '',
                                    }
                                  : '';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${detection.label} — '
                              '${(detection.confidence * 100).toStringAsFixed(1)} %'
                              '$ownerText',
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
class _PointAnalysisCard extends StatelessWidget {
  const _PointAnalysisCard({required this.result});
  final _PointAnalysisResult result;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              result.uncertain ? Icons.warning_amber : Icons.flag,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.uncertain
                        ? 'Analyse incertaine'
                        : 'Estimation du point',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(result.message),
                  if (!result.uncertain) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Correction locale de perspective active. Les distances restent '
                      'expérimentales : mesure manuelle si le cas est serré.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _TeamLegend extends StatelessWidget {
  const _TeamLegend({
    required this.teamAName,
    required this.teamBName,
  });
  final String teamAName;
  final String teamBName;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 6,
      children: [
        Text('A = $teamAName'),
        Text('B = $teamBName'),
        const Text('? = indéterminée'),
      ],
    );
  }
}
class _DetectionImage extends StatelessWidget {
  const _DetectionImage({
    required this.imageFile,
    required this.detections,
    required this.ballOwners,
    required this.onBallTap,
  });
  final File imageFile;
  final List<PetanqueDetection> detections;
  final Map<int, _BallOwner> ballOwners;
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
                              painter: _DetectionPainter(
                                detections: detections,
                                ballOwners: ballOwners,
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
  void _handleBallTap(Offset position, Size size) {
    int? bestIndex;
    double? bestDistance;
    for (final entry in detections.asMap().entries) {
      final index = entry.key;
      final detection = entry.value;
      if (detection.type != PetanqueObjectType.boule) continue;
      final center = Offset(
        ((detection.left + detection.right) / 2) * size.width,
        ((detection.top + detection.bottom) / 2) * size.height,
      );
      final boxWidth =
          (detection.right - detection.left) * size.width;
      final boxHeight =
          (detection.bottom - detection.top) * size.height;
      final touchRadius =
          (boxWidth > boxHeight ? boxWidth : boxHeight).clamp(22.0, 60.0);
      final distance = (position - center).distance;
      if (distance <= touchRadius &&
          (bestDistance == null || distance < bestDistance)) {
        bestDistance = distance;
        bestIndex = index;
      }
    }
    if (bestIndex != null) {
      onBallTap(bestIndex);
    }
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
    required this.ballOwners,
  });
  final List<PetanqueDetection> detections;
  final Map<int, _BallOwner> ballOwners;
  @override
  void paint(Canvas canvas, Size size) {
    for (final entry in detections.asMap().entries) {
      final index = entry.key;
      final detection = entry.value;
      final owner = ballOwners[index];
      final rect = Rect.fromLTRB(
        detection.left * size.width,
        detection.top * size.height,
        detection.right * size.width,
        detection.bottom * size.height,
      );
      final boxPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = owner == null ? 3 : 5
        ..color = _colorForDetection(detection, owner);
      canvas.drawRect(rect, boxPaint);
      final label = detection.type == PetanqueObjectType.cochonnet
          ? 'C'
          : _ownerLabel(owner);
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      // Keep the marker deliberately tiny: it only identifies the object.
      // Confidence values remain available in the diagnostic section below
      // the image and no longer obscure neighbouring balls.
      const horizontalPadding = 4.0;
      const verticalPadding = 2.0;
      final badgeWidth = textPainter.width + horizontalPadding * 2;
      final badgeHeight = textPainter.height + verticalPadding * 2;
      final labelLeft = rect.left.clamp(
        0.0,
        (size.width - badgeWidth).clamp(0.0, size.width),
      );
      final labelTop = rect.top.clamp(
        0.0,
        (size.height - badgeHeight).clamp(0.0, size.height),
      );
      final backgroundRect = Rect.fromLTWH(
        labelLeft,
        labelTop,
        badgeWidth,
        badgeHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          backgroundRect,
          const Radius.circular(3),
        ),
        Paint()..color = _colorForDetection(detection, owner),
      );
      textPainter.paint(
        canvas,
        Offset(
          labelLeft + horizontalPadding,
          labelTop + verticalPadding,
        ),
      );
    }
  }
  String _ownerLabel(_BallOwner? owner) {
    return switch (owner) {
      _BallOwner.teamA => 'A',
      _BallOwner.teamB => 'B',
      _BallOwner.unknown => '?',
      null => '•',
    };
  }
  Color _colorForDetection(
    PetanqueDetection detection,
    _BallOwner? owner,
  ) {
    if (detection.type == PetanqueObjectType.cochonnet) {
      return Colors.orange.shade700;
    }
    return switch (owner) {
      _BallOwner.teamA => Colors.blue.shade700,
      _BallOwner.teamB => Colors.red.shade700,
      _BallOwner.unknown => Colors.grey.shade700,
      null => Colors.green.shade700,
    };
  }
  @override
  bool shouldRepaint(covariant _DetectionPainter oldDelegate) {
    return oldDelegate.detections != detections ||
        oldDelegate.ballOwners != ballOwners;
  }
}
