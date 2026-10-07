import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PetanqueCameraResult {
  const PetanqueCameraResult({
    required this.image,
    required this.tiltDegrees,
  });

  final XFile image;
  final double tiltDegrees;
}

class PetanqueCameraScreen extends StatefulWidget {
  const PetanqueCameraScreen({super.key});

  @override
  State<PetanqueCameraScreen> createState() => _PetanqueCameraScreenState();
}

class _PetanqueCameraScreenState extends State<PetanqueCameraScreen>
    with WidgetsBindingObserver {
  static const double _excellentTilt = 6.0;
  static const double _maximumTilt = 10.0;

  CameraController? _controller;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  double? _tiltDegrees;
  bool _initializing = true;
  bool _takingPicture = false;
  String? _error;

  bool get _canShoot =>
      !_initializing &&
      !_takingPicture &&
      _controller?.value.isInitialized == true &&
      _tiltDegrees != null &&
      _tiltDegrees! <= _maximumTilt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenToTilt();
    _initializeCamera();
  }

  void _listenToTilt() {
    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen((event) {
      final magnitude =
          math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (magnitude < 1e-6) return;

      // Téléphone écran vers le ciel / caméra arrière vers le terrain :
      // z porte presque toute la gravité lorsque le téléphone est parallèle
      // au sol. L'angle vaut 0° quand le téléphone est parfaitement à plat.
      final cosAngle = (event.z.abs() / magnitude).clamp(0.0, 1.0);
      final angle = math.acos(cosAngle) * 180.0 / math.pi;

      if (!mounted) return;
      setState(() => _tiltDegrees = angle);
    });
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw StateError('Aucune caméra disponible.');
      }

      final backCameras =
          cameras.where((c) => c.lensDirection == CameraLensDirection.back);
      final selected = backCameras.isNotEmpty ? backCameras.first : cameras.first;

      final controller = CameraController(
        selected,
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _initializing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _initializing = false;
      });
    }
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    final tilt = _tiltDegrees;
    if (!_canShoot || controller == null || tilt == null) return;

    setState(() => _takingPicture = true);
    try {
      final image = await controller.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop(
        PetanqueCameraResult(
          image: image,
          tiltDegrees: tilt,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _takingPicture = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      setState(() => _initializing = true);
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _accelerometerSubscription?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tilt = _tiltDegrees;
    final excellent = tilt != null && tilt <= _excellentTilt;
    final acceptable = tilt != null && tilt <= _maximumTilt;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Prise de mesure'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _buildPreview(),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              color: Colors.black,
              child: Column(
                children: [
                  Text(
                    tilt == null
                        ? 'Lecture de l’inclinaison…'
                        : excellent
                            ? '✓ Angle excellent • ${tilt.toStringAsFixed(1)}°'
                            : acceptable
                                ? '✓ Angle exploitable • ${tilt.toStringAsFixed(1)}°'
                                : 'Mettez le téléphone plus à plat • ${tilt.toStringAsFixed(1)}°',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: acceptable ? Colors.greenAccent : Colors.orangeAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Écran vers le ciel, caméra arrière vers le terrain. '
                    'Cadrez le cochonnet et les boules à départager.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: 76,
                    height: 76,
                    child: FilledButton(
                      onPressed: _canShoot ? _takePicture : null,
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: _takingPicture
                          ? const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )
                          : const Icon(Icons.camera_alt, size: 34),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_initializing) {
      return const CircularProgressIndicator();
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          _error!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Caméra indisponible',
        style: TextStyle(color: Colors.white),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: CameraPreview(controller)),
        IgnorePointer(
          child: CustomPaint(
            painter: _GuidePainter(),
          ),
        ),
      ],
    );
  }
}

class _GuidePainter extends CustomPainter {
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
