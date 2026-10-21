import 'dart:ui';

import 'package:image_picker/image_picker.dart';

import '../domain/analysis_correction.dart';
import '../domain/ranked_ball.dart';
import '../domain/ranked_ball_reference.dart';
import '../services/petanque_detector.dart';

const Object _unset = Object();

/// Immutable state of the terrain analysis screen.
class TerrainAnalysisState {
  const TerrainAnalysisState({
    this.image,
    this.imageAspectRatio = 1.0,
    this.guidedCapture = false,
    this.tiltDegrees,
    this.pickingImage = false,
    this.analyzing = false,
    this.error,
    this.detections = const [],
    this.jackPosition,
    this.jackConfirmed = false,
    this.jackWasDetected = false,
    this.jackBallIndex,
    this.ignoredIndices = const {},
    this.manualBalls = const [],
    this.addingManualBall = false,
    this.corrections = const [],
    this.ranking = const [],
    this.correctingRanking = false,
    this.rankingCorrectionOriginal = const [],
    this.rankingCorrectionSelection = const [],
  });

  final XFile? image;
  final double imageAspectRatio;

  /// True when the photo comes from the guided camera (known tilt).
  final bool guidedCapture;
  final double? tiltDegrees;

  final bool pickingImage;
  final bool analyzing;
  final String? error;

  final List<PetanqueDetection> detections;

  final Offset? jackPosition;
  final bool jackConfirmed;
  final bool jackWasDetected;

  /// Boule detection that is actually the jack, excluded from the ranking.
  final int? jackBallIndex;

  /// Boule detections the user flagged as false positives.
  final Set<int> ignoredIndices;

  /// Boules explicitly added by the user, in normalized image coordinates.
  final List<Offset> manualBalls;

  /// While true, the next tap on the photo adds a missing boule.
  final bool addingManualBall;

  /// Structured feedback kept independently from the UI so it can later be
  /// persisted/exported as training data.
  final List<AnalysisCorrection> corrections;

  final List<RankedBall> ranking;

  /// Human ranking correction currently being edited.
  final bool correctingRanking;
  final List<RankedBall> rankingCorrectionOriginal;
  final List<RankedBallReference> rankingCorrectionSelection;

  bool get isBusy => pickingImage || analyzing;

  /// Detections that are neither drawn nor ranked.
  Set<int> get hiddenIndices => {
    ...ignoredIndices,
    if (jackBallIndex != null) jackBallIndex!,
  };

  /// detectionIndex -> rank (1 = closest to the jack).
  Map<int, int> get ballRanks => {
    for (var i = 0; i < ranking.length; i++)
      if (ranking[i].detectionIndex case final detectionIndex?)
        detectionIndex: i + 1,
  };

  /// manualBallIndex -> rank.
  Map<int, int> get manualBallRanks => {
    for (var i = 0; i < ranking.length; i++)
      if (ranking[i].manualBallIndex case final manualBallIndex?)
        manualBallIndex: i + 1,
  };

  int get rankedBallCount => ranking.length;

  TerrainAnalysisState copyWith({
    bool? pickingImage,
    bool? analyzing,
    Object? error = _unset,
    List<PetanqueDetection>? detections,
    Object? jackPosition = _unset,
    bool? jackConfirmed,
    bool? jackWasDetected,
    Object? jackBallIndex = _unset,
    Set<int>? ignoredIndices,
    List<Offset>? manualBalls,
    bool? addingManualBall,
    List<AnalysisCorrection>? corrections,
    List<RankedBall>? ranking,
    bool? correctingRanking,
    List<RankedBall>? rankingCorrectionOriginal,
    List<RankedBallReference>? rankingCorrectionSelection,
  }) {
    return TerrainAnalysisState(
      image: image,
      imageAspectRatio: imageAspectRatio,
      guidedCapture: guidedCapture,
      tiltDegrees: tiltDegrees,
      pickingImage: pickingImage ?? this.pickingImage,
      analyzing: analyzing ?? this.analyzing,
      error: identical(error, _unset) ? this.error : error as String?,
      detections: detections ?? this.detections,
      jackPosition: identical(jackPosition, _unset)
          ? this.jackPosition
          : jackPosition as Offset?,
      jackConfirmed: jackConfirmed ?? this.jackConfirmed,
      jackWasDetected: jackWasDetected ?? this.jackWasDetected,
      jackBallIndex: identical(jackBallIndex, _unset)
          ? this.jackBallIndex
          : jackBallIndex as int?,
      ignoredIndices: ignoredIndices ?? this.ignoredIndices,
      manualBalls: manualBalls ?? this.manualBalls,
      addingManualBall: addingManualBall ?? this.addingManualBall,
      corrections: corrections ?? this.corrections,
      ranking: ranking ?? this.ranking,
      correctingRanking: correctingRanking ?? this.correctingRanking,
      rankingCorrectionOriginal:
          rankingCorrectionOriginal ?? this.rankingCorrectionOriginal,
      rankingCorrectionSelection:
          rankingCorrectionSelection ?? this.rankingCorrectionSelection,
    );
  }
}
