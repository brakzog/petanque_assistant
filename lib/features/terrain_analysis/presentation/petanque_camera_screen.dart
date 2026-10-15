import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/back_camera_opener.dart';
import '../terrain_analysis_providers.dart';
import 'petanque_camera_result.dart';
import 'widgets/camera_guide_painter.dart';
import 'widgets/shutter_button.dart';
import 'widgets/tilt_indicator.dart';
import 'widgets/zoom_badge.dart';

export 'petanque_camera_result.dart';

/// Guided capture: only allows shooting when the phone is nearly flat.
class PetanqueCameraScreen extends ConsumerStatefulWidget {
  const PetanqueCameraScreen({super.key});

  @override
  ConsumerState<PetanqueCameraScreen> createState() =>
      _PetanqueCameraScreenState();
}

class _PetanqueCameraScreenState extends ConsumerState<PetanqueCameraScreen>
    with WidgetsBindingObserver {
  OpenedCamera? _camera;
  StreamSubscription<double>? _tiltSubscription;
  double? _tiltDegrees;

  double _zoomLevel = 1.0;
  double _zoomLevelOnScaleStart = 1.0;

  bool _initializing = true;
  bool _takingPicture = false;
  bool _pausedByLifecycle = false;
  String? _error;

  bool get _canShoot =>
      !_initializing &&
      !_takingPicture &&
      _camera?.controller.value.isInitialized == true &&
      ref.read(tiltPolicyProvider).allowsCapture(_tiltDegrees);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tiltSubscription = ref.read(tiltSensorProvider).tiltDegrees().listen((
      tilt,
    ) {
      if (mounted) setState(() => _tiltDegrees = tilt);
    });
    _openCamera();
  }

  Future<void> _openCamera() async {
    try {
      final camera = await ref.read(backCameraOpenerProvider).open();
      if (!mounted) {
        await camera.controller.dispose();
        return;
      }
      setState(() {
        _camera = camera;
        _zoomLevel = camera.zoomRange.min;
        _zoomLevelOnScaleStart = camera.zoomRange.min;
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

  void _onScaleStart(ScaleStartDetails details) {
    _zoomLevelOnScaleStart = _zoomLevel;
  }

  Future<void> _onScaleUpdate(ScaleUpdateDetails details) async {
    final camera = _camera;
    if (camera == null ||
        !camera.controller.value.isInitialized ||
        details.pointerCount != 2) {
      return;
    }

    final target = camera.zoomRange.forPinch(
      _zoomLevelOnScaleStart,
      details.scale,
    );
    if ((target - _zoomLevel).abs() < 0.02) return;
    _zoomLevel = target;

    try {
      await camera.controller.setZoomLevel(target);
      if (mounted) setState(() {});
    } catch (_) {
      // Une erreur native transitoire pendant le geste ne doit pas bloquer la caméra.
    }
  }

  Future<void> _takePicture() async {
    final camera = _camera;
    final tilt = _tiltDegrees;
    if (!_canShoot || camera == null || tilt == null) return;

    setState(() => _takingPicture = true);
    try {
      final image = await camera.controller.takePicture();
      if (!mounted) return;
      Navigator.of(
        context,
      ).pop(PetanqueCameraResult(image: image, tiltDegrees: tilt));
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
    if (state == AppLifecycleState.inactive) {
      final camera = _camera;
      if (camera == null) return;
      setState(() {
        _camera = null;
        _pausedByLifecycle = true;
      });
      camera.controller.dispose();
    } else if (state == AppLifecycleState.resumed && _pausedByLifecycle) {
      setState(() {
        _pausedByLifecycle = false;
        _initializing = true;
        _error = null;
      });
      _openCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tiltSubscription?.cancel();
    _camera?.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiltQuality = ref.read(tiltPolicyProvider).qualityOf(_tiltDegrees);

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
            Expanded(child: Center(child: _buildPreview())),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              color: Colors.black,
              child: Column(
                children: [
                  TiltIndicator(
                    tiltDegrees: _tiltDegrees,
                    quality: tiltQuality,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Écran vers le ciel, caméra arrière vers le terrain. '
                    'Cadrez le cochonnet et les boules à départager. Pincez l’image pour zoomer si nécessaire.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 14),
                  ShutterButton(
                    busy: _takingPicture,
                    onPressed: _canShoot ? _takePicture : null,
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
    if (_initializing || _pausedByLifecycle) {
      return const CircularProgressIndicator();
    }

    final error = _error;
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    final controller = _camera?.controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Caméra indisponible',
        style: TextStyle(color: Colors.white),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: CameraPreview(controller)),
          const IgnorePointer(
            child: CustomPaint(painter: CameraGuidePainter()),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Center(child: ZoomBadge(zoomLevel: _zoomLevel)),
          ),
        ],
      ),
    );
  }
}
