import '../../../domain/petanque_format_rules.dart';
import '../../../domain/tournament.dart';

/// What can be done with a tournament's participants.
class RosterStatus {
  const RosterStatus({
    required this.tournament,
    required this.playerCount,
    required this.teamCount,
  });

  final Tournament tournament;
  final int playerCount;
  final int teamCount;

  int get playersPerTeam => tournament.format.playersPerTeam;

  int get completeTeams => playerCount ~/ playersPerTeam;

  int get remainingPlayers => playerCount % playersPerTeam;

  /// Participants can no longer change once teams are formed.
  bool get teamsFormed => teamCount > 0;

  bool get usesRandomTeams =>
      tournament.teamCreationMode == TeamCreationMode.random;

  bool get canGenerateTeams =>
      usesRandomTeams &&
      !teamsFormed &&
      playerCount > 0 &&
      remainingPlayers == 0;
}
