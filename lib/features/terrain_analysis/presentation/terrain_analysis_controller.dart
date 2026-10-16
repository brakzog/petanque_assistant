import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/media/media_providers.dart';
import '../terrain_analysis_providers.dart';
import 'terrain_analysis_state.dart';

final terrainAnalysisControllerProvider =
    NotifierProvider.autoDispose<
      TerrainAnalysisController,
      TerrainAnalysisState
    >(TerrainAnalysisController.new);

/// Drives a terrain analysis: photo, detection, jack, ranking.
class TerrainAnalysisController extends Notifier<TerrainAnalysisState> {
  @override
  TerrainAnalysisState build() => const TerrainAnalysisState();

  Future<void> useCapturedPhoto(XFile photo, double tiltDegrees) {
    return _loadPhoto(
      () async => photo,
      guidedCapture: true,
      tiltDegrees: tiltDegrees,
    );
  }

  Future<void> pickFromGallery() {
    return _loadPhoto(
      ref.read(photoPickerProvider).pickFromGallery,
      guidedCapture: false,
    );
  }

  void removePhoto() {
    if (state.analyzing) return;
    state = const TerrainAnalysisState();
  }

  void setJack(Offset position) {
    final jack = Offset(
      position.dx.clamp(0.0, 1.0),
      position.dy.clamp(0.0, 1.0),
    );
    state = state.copyWith(
      jackPosition: jack,
      jackConfirmed: false,
      jackWasDetected: false,
      jackBallIndex: ref
          .read(detectionLocatorProvider)
          .findBallAtJack(state.detections, jack),
      ranking: const [],
    );
  }

  void confirmJack() {
    final jack = state.jackPosition;
    if (jack == null) return;
    state = state.copyWith(
      jackConfirmed: true,
      jackBallIndex: ref
          .read(detectionLocatorProvider)
          .findBallAtJack(state.detections, jack),
    );
    _updateRanking();
  }

  void repositionJack() {
    state = state.copyWith(jackConfirmed: false, ranking: const []);
  }

  /// Visible boule detection under a tap on the photo.
  int? ballAt(Offset position) {
    return ref
        .read(detectionLocatorProvider)
        .findBallAt(
          state.detections,
          position,
          excludedIndices: state.hiddenIndices,
        );
  }

  void ignoreBall(int detectionIndex) {
    state = state.copyWith(
      ignoredIndices: {...state.ignoredIndices, detectionIndex},
    );
    _updateRanking();
  }

  void restoreIgnoredBalls() {
    state = state.copyWith(ignoredIndices: const {});
    _updateRanking();
  }

  Future<void> _loadPhoto(
    Future<XFile?> Function() source, {
    required bool guidedCapture,
    double? tiltDegrees,
  }) async {
    if (state.isBusy) return;
    state = state.copyWith(pickingImage: true, error: null);

    try {
      final photo = await source();
      if (!ref.mounted || photo == null) return;

      final normalized = await ref
          .read(imageOrientationNormalizerProvider)
          .normalize(photo);
      if (!ref.mounted) return;

      state = TerrainAnalysisState(
        image: normalized.file,
        imageAspectRatio: normalized.aspectRatio,
        guidedCapture: guidedCapture,
        tiltDegrees: tiltDegrees,
        pickingImage: true,
      );
      await _analyze(normalized.file);
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: e.toString());
    } finally {
      if (ref.mounted) state = state.copyWith(pickingImage: false);
    }
  }

  Future<void> _analyze(XFile image) async {
    state = state.copyWith(analyzing: true);

    try {
      final detections = await ref
          .read(ballDetectorProvider)
          .detect(image.path);
      if (!ref.mounted) return;

      final locator = ref.read(detectionLocatorProvider);
      final jack = locator.proposeJack(detections);
      state = state.copyWith(
        detections: detections,
        jackPosition: jack,
        jackWasDetected: jack != null,
        jackBallIndex: jack == null
            ? null
            : locator.findBallAtJack(detections, jack),
      );
    } catch (e) {
      if (ref.mounted) state = state.copyWith(error: e.toString());
    } finally {
      if (ref.mounted) state = state.copyWith(analyzing: false);
    }
  }

  void _updateRanking() {
    final jack = state.jackPosition;
    if (!state.jackConfirmed || jack == null) {
      state = state.copyWith(ranking: const []);
      return;
    }

    state = state.copyWith(
      ranking: ref
          .read(ballRankerProvider)
          .rank(
            detections: state.detections,
            jack: jack,
            excludedIndices: state.hiddenIndices,
            guidedCapture: state.guidedCapture,
            imageAspectRatio: state.imageAspectRatio,
          ),
    );
  }
}
