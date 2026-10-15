import '../../../domain/end.dart';
import '../../../domain/match.dart';
import '../../../domain/tournament.dart';

/// Score rules of a petanque match.
class MatchScorer {
  const MatchScorer();

  int maxPointsPerEnd(PetanqueFormat format) {
    return switch (format) {
      PetanqueFormat.singles => 3,
      PetanqueFormat.doubles || PetanqueFormat.triples => 6,
    };
  }

  /// Match after [teamId] scored [points] in a new end.
  Match applyEnd(Match match, {required String teamId, required int points}) {
    final isTeamA = teamId == match.teamAId;
    final teamAScore = match.teamAScore + (isTeamA ? points : 0);
    final teamBScore = match.teamBScore + (isTeamA ? 0 : points);

    String? winnerTeamId;
    if (teamAScore >= match.targetScore) {
      winnerTeamId = match.teamAId;
    } else if (teamBScore >= match.targetScore) {
      winnerTeamId = match.teamBId;
    }

    return match.copyWith(
      teamAScore: teamAScore,
      teamBScore: teamBScore,
      status: winnerTeamId == null
          ? MatchStatus.inProgress
          : MatchStatus.finished,
      winnerTeamId: winnerTeamId,
    );
  }

  /// Match after removing [end], [remainingEnds] being the count left.
  Match revertEnd(Match match, End end, {required int remainingEnds}) {
    final isTeamA = end.scoringTeamId == match.teamAId;

    return match.copyWith(
      teamAScore: isTeamA ? match.teamAScore - end.points : match.teamAScore,
      teamBScore: isTeamA ? match.teamBScore : match.teamBScore - end.points,
      status: remainingEnds == 0 ? MatchStatus.pending : MatchStatus.inProgress,
      clearWinner: true,
    );
  }
}
