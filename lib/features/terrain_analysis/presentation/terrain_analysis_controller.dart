import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/media/media_providers.dart';
import '../domain/analysis_correction.dart';
import '../domain/ranked_ball.dart';
import '../domain/ranked_ball_reference.dart';
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
      addingManualBall: false,
      corrections: [
        ...state.corrections,
        JackPositionCorrection(jack),
      ],
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
    state = state.copyWith(
      jackConfirmed: false,
      addingManualBall: false,
      ranking: const [],
      correctingRanking: false,
      rankingCorrectionOriginal: const [],
      rankingCorrectionSelection: const [],
    );
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
      corrections: [
        ...state.corrections,
        RemovedDetectionCorrection(detectionIndex),
      ],
    );
    _updateRanking();
  }

  void startAddingManualBall() {
    if (!state.jackConfirmed) return;
    if (state.correctingRanking) cancelRankingCorrection();
    state = state.copyWith(addingManualBall: true);
  }

  void cancelAddingManualBall() {
    state = state.copyWith(addingManualBall: false);
  }

  void addManualBall(Offset position) {
    if (!state.jackConfirmed) return;
    final ball = Offset(
      position.dx.clamp(0.0, 1.0),
      position.dy.clamp(0.0, 1.0),
    );
    state = state.copyWith(
      manualBalls: [...state.manualBalls, ball],
      addingManualBall: false,
      corrections: [...state.corrections, AddedBallCorrection(ball)],
    );
    _updateRanking();
  }

  void undoLastManualBall() {
    if (state.manualBalls.isEmpty) return;
    final removed = state.manualBalls.last;
    state = state.copyWith(
      manualBalls: state.manualBalls.sublist(0, state.manualBalls.length - 1),
      corrections: [
        ...state.corrections,
        RemovedManualBallCorrection(removed),
      ],
    );
    _updateRanking();
  }

  void restoreIgnoredBalls() {
    if (state.ignoredIndices.isEmpty) return;
    final restored = Set<int>.from(state.ignoredIndices);
    state = state.copyWith(
      ignoredIndices: const {},
      corrections: [
        ...state.corrections,
        RestoredDetectionsCorrection(restored),
      ],
    );
    _updateRanking();
  }

  void startRankingCorrection() {
    if (!state.jackConfirmed || state.ranking.length < 2) return;
    state = state.copyWith(
      addingManualBall: false,
      correctingRanking: true,
      rankingCorrectionOriginal: List<RankedBall>.from(state.ranking),
      rankingCorrectionSelection: const [],
    );
  }

  void cancelRankingCorrection() {
    if (!state.correctingRanking) return;
    state = state.copyWith(
      ranking: List<RankedBall>.from(state.rankingCorrectionOriginal),
      correctingRanking: false,
      rankingCorrectionOriginal: const [],
      rankingCorrectionSelection: const [],
    );
  }

  void undoRankingChoice() {
    if (!state.correctingRanking || state.rankingCorrectionSelection.isEmpty) {
      return;
    }
    final selection = state.rankingCorrectionSelection.sublist(
      0,
      state.rankingCorrectionSelection.length - 1,
    );
    _previewRankingCorrection(selection);
  }

  void confirmRankingCorrection() {
    if (!state.correctingRanking || state.rankingCorrectionSelection.isEmpty) {
      return;
    }
    final automaticOrder = state.rankingCorrectionOriginal
        .map(_referenceFor)
        .toList(growable: false);
    final correctedOrder = state.ranking.map(_referenceFor).toList(growable: false);

    state = state.copyWith(
      corrections: [
        ...state.corrections,
        RankingCorrection(
          automaticOrder: automaticOrder,
          correctedOrder: correctedOrder,
        ),
      ],
      correctingRanking: false,
      rankingCorrectionOriginal: const [],
      rankingCorrectionSelection: const [],
    );
  }

  /// Returns the ranked boule under [position], including manually added ones.
  RankedBallReference? rankedBallAt(Offset position) {
    // Manual boules have no bbox, so give them a small normalized hit target.
    var nearestManualDistance = double.infinity;
    int? nearestManualIndex;
    for (final entry in state.manualBalls.asMap().entries) {
      final distance = (entry.value - position).distance;
      if (distance <= 0.045 && distance < nearestManualDistance) {
        nearestManualDistance = distance;
        nearestManualIndex = entry.key;
      }
    }
    if (nearestManualIndex != null) {
      return ManualBallReference(nearestManualIndex);
    }

    final detectionIndex = ballAt(position);
    if (detectionIndex == null) return null;
    return DetectedBallReference(detectionIndex);
  }

  void selectRankingBall(RankedBallReference reference) {
    if (!state.correctingRanking) return;
    if (state.rankingCorrectionSelection.any(
      (selected) => _sameReference(selected, reference),
    )) {
      return;
    }

    _previewRankingCorrection([
      ...state.rankingCorrectionSelection,
      reference,
    ]);
  }

  void _previewRankingCorrection(List<RankedBallReference> selection) {
    final original = state.rankingCorrectionOriginal;
    final selectedBalls = <RankedBall>[];

    for (final reference in selection) {
      final ball = original.cast<RankedBall?>().firstWhere(
        (candidate) =>
            candidate != null && _sameReference(_referenceFor(candidate), reference),
        orElse: () => null,
      );
      if (ball != null) selectedBalls.add(ball);
    }

    final remaining = original.where(
      (ball) => !selection.any(
        (reference) => _sameReference(_referenceFor(ball), reference),
      ),
    );

    state = state.copyWith(
      rankingCorrectionSelection: selection,
      ranking: [...selectedBalls, ...remaining],
    );
  }

  RankedBallReference _referenceFor(RankedBall ball) {
    if (ball.detectionIndex case final detectionIndex?) {
      return DetectedBallReference(detectionIndex);
    }
    return ManualBallReference(ball.manualBallIndex!);
  }

  bool _sameReference(RankedBallReference a, RankedBallReference b) {
    return switch ((a, b)) {
      (DetectedBallReference a, DetectedBallReference b) =>
        a.detectionIndex == b.detectionIndex,
      (ManualBallReference a, ManualBallReference b) =>
        a.manualBallIndex == b.manualBallIndex,
      _ => false,
    };
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
            manualBalls: state.manualBalls,
            jack: jack,
            excludedIndices: state.hiddenIndices,
            guidedCapture: state.guidedCapture,
            imageAspectRatio: state.imageAspectRatio,
          ),
      correctingRanking: false,
      rankingCorrectionOriginal: const [],
      rankingCorrectionSelection: const [],
    );
  }
}
