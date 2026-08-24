import '../../../domain/match.dart';
import '../../../domain/repechage_result.dart';

class RepechageService {
  const RepechageService();

  RepechageResult calculate({
    required List<Match> firstRoundMatches,
    required int numberOfRepechageSlots,
  }) {
    final finishedMatches = firstRoundMatches
        .where(
          (match) =>
      match.status == MatchStatus.finished &&
          match.winnerTeamId != null &&
          !match.isBye,
    )
        .toList();

    if (finishedMatches.length != firstRoundMatches.length) {
      throw StateError(
        'Tous les matchs du premier tour doivent être terminés.',
      );
    }

    final losers = <_LoserResult>[];

    for (final match in finishedMatches) {
      final winnerTeamId = match.winnerTeamId!;

      late final String loserTeamId;
      late final int loserScore;

      if (winnerTeamId == match.teamAId) {
        loserTeamId = match.teamBId!;
        loserScore = match.teamBScore;
      } else {
        loserTeamId = match.teamAId!;
        loserScore = match.teamAScore;
      }

      losers.add(
        _LoserResult(
          teamId: loserTeamId,
          score: loserScore,
        ),
      );
    }

    losers.sort(
          (a, b) => b.score.compareTo(a.score),
    );

    if (numberOfRepechageSlots <= 0) {
      return RepechageResult(
        qualifiedTeamIds: const [],
        eliminatedTeamIds:
        losers.map((loser) => loser.teamId).toList(),
        playoffTeamIds: const [],
        playoffQualificationSlots: 0,
      );
    }

    if (numberOfRepechageSlots >= losers.length) {
      return RepechageResult(
        qualifiedTeamIds:
        losers.map((loser) => loser.teamId).toList(),
        eliminatedTeamIds: const [],
        playoffTeamIds: const [],
        playoffQualificationSlots: 0,
      );
    }

    final cutoffScore =
        losers[numberOfRepechageSlots - 1].score;

    final aboveCutoff = losers
        .where((loser) => loser.score > cutoffScore)
        .toList();

    final atCutoff = losers
        .where((loser) => loser.score == cutoffScore)
        .toList();

    final belowCutoff = losers
        .where((loser) => loser.score < cutoffScore)
        .toList();

    final remainingSlots =
        numberOfRepechageSlots - aboveCutoff.length;

    if (atCutoff.length == remainingSlots) {
      return RepechageResult(
        qualifiedTeamIds: [
          ...aboveCutoff.map((loser) => loser.teamId),
          ...atCutoff.map((loser) => loser.teamId),
        ],
        eliminatedTeamIds:
        belowCutoff.map((loser) => loser.teamId).toList(),
        playoffTeamIds: const [],
        playoffQualificationSlots: 0,
      );
    }

    return RepechageResult(
      qualifiedTeamIds:
      aboveCutoff.map((loser) => loser.teamId).toList(),
      eliminatedTeamIds:
      belowCutoff.map((loser) => loser.teamId).toList(),
      playoffTeamIds:
      atCutoff.map((loser) => loser.teamId).toList(),
      playoffQualificationSlots: remainingSlots,
    );
  }
}

class _LoserResult {
  final String teamId;
  final int score;

  const _LoserResult({
    required this.teamId,
    required this.score,
  });
}