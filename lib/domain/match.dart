enum MatchStatus {
  pending,
  inProgress,
  finished,
}

enum MatchType {
  tournament,
  repechagePlayoff,
}

class Match {
  final String id;
  final String tournamentId;

  final int round;
  final int position;

  final String? teamAId;
  final String? teamBId;

  final int targetScore;

  final int teamAScore;
  final int teamBScore;

  final MatchStatus status;

  final String? winnerTeamId;

  final MatchType type;

  const Match({
    required this.id,
    required this.tournamentId,
    required this.round,
    required this.position,
    required this.teamAId,
    required this.teamBId,
    required this.targetScore,
    this.teamAScore = 0,
    this.teamBScore = 0,
    this.status = MatchStatus.pending,
    this.winnerTeamId,
    this.type = MatchType.tournament,
  });

  bool get isBye =>
      (teamAId != null && teamBId == null) ||
          (teamAId == null && teamBId != null);

  bool get isFinished => status == MatchStatus.finished;

  Match copyWith({
    String? id,
    String? tournamentId,
    int? round,
    int? position,
    String? teamAId,
    String? teamBId,
    int? targetScore,
    int? teamAScore,
    int? teamBScore,
    MatchStatus? status,
    String? winnerTeamId,
    MatchType? type,
  }) {
    return Match(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      round: round ?? this.round,
      position: position ?? this.position,
      teamAId: teamAId ?? this.teamAId,
      teamBId: teamBId ?? this.teamBId,
      targetScore: targetScore ?? this.targetScore,
      teamAScore: teamAScore ?? this.teamAScore,
      teamBScore: teamBScore ?? this.teamBScore,
      status: status ?? this.status,
      winnerTeamId: winnerTeamId ?? this.winnerTeamId,
      type: type ?? this.type,
    );
  }
}