import 'package:camera/camera.dart';

import '../domain/zoom_range.dart';

/// An initialized camera ready for preview and capture.
class OpenedCamera {
  const OpenedCamera({required this.controller, required this.zoomRange});

  final CameraController controller;
  final ZoomRange zoomRange;
}

/// Opens the back camera configured for a measurement photo.
class BackCameraOpener {
  const BackCameraOpener({this.listCameras = availableCameras});

  final Future<List<CameraDescription>> Function() listCameras;

  Future<OpenedCamera> open() async {
    final cameras = await listCameras();
    if (cameras.isEmpty) {
      throw StateError('Aucune caméra disponible.');
    }

    final backCameras = cameras.where(
      (c) => c.lensDirection == CameraLensDirection.back,
    );
    final selected = backCameras.isNotEmpty ? backCameras.first : cameras.first;

    final controller = CameraController(
      selected,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      final minZoom = await controller.getMinZoomLevel();
      final maxZoom = await controller.getMaxZoomLevel();
      await controller.setZoomLevel(minZoom);
      return OpenedCamera(
        controller: controller,
        zoomRange: ZoomRange(min: minZoom, max: maxZoom),
      );
    } catch (_) {
      await controller.dispose();
      rethrow;
    }
  }
}
