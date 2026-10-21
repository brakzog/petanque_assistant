import 'dart:ui';

/// User feedback produced while reviewing an analysis.
///
/// Keeping corrections as domain data makes them persistable/exportable later
/// without coupling the analysis UI to Firebase or any backend.
sealed class AnalysisCorrection {
  const AnalysisCorrection();
}

final class AddedBallCorrection extends AnalysisCorrection {
  const AddedBallCorrection(this.position);

  final Offset position;
}

final class RemovedDetectionCorrection extends AnalysisCorrection {
  const RemovedDetectionCorrection(this.detectionIndex);

  final int detectionIndex;
}

final class JackPositionCorrection extends AnalysisCorrection {
  const JackPositionCorrection(this.position);

  final Offset position;
}

final class RemovedManualBallCorrection extends AnalysisCorrection {
  const RemovedManualBallCorrection(this.position);

  final Offset position;
}

final class RestoredDetectionsCorrection extends AnalysisCorrection {
  const RestoredDetectionsCorrection(this.detectionIndices);

  final Set<int> detectionIndices;
}
