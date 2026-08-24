enum TournamentProgressionState {
  waiting,
  progressed,
  finished,
  playoffRequired,
}

class TournamentProgressionResult {
  final TournamentProgressionState state;
  final List<String> playoffTeamIds;
  final int playoffQualificationSlots;

  const TournamentProgressionResult({
    required this.state,
    this.playoffTeamIds = const [],
    this.playoffQualificationSlots = 0,
  });
}