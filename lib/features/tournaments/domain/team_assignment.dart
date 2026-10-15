import '../../../domain/player.dart';
import '../../../domain/team.dart';

/// Which team each player belongs to while composing predefined teams.
/// Teams are identified by their index, named "Équipe 1", "Équipe 2"...
class TeamAssignment {
  const TeamAssignment({
    required this.players,
    required this.playersPerTeam,
    this.teamByPlayer = const {},
  });

  /// Rebuilds the assignment from saved teams, in their saved order.
  factory TeamAssignment.fromTeams({
    required List<Player> players,
    required List<Team> teams,
    required int playersPerTeam,
  }) {
    final known = {for (final player in players) player.id};
    return TeamAssignment(
      players: players,
      playersPerTeam: playersPerTeam,
      teamByPlayer: {
        for (var index = 0; index < teams.length; index++)
          for (final player in teams[index].players)
            if (known.contains(player.id)) player.id: index,
      },
    );
  }

  final List<Player> players;
  final int playersPerTeam;
  final Map<String, int> teamByPlayer;

  int get teamCount => players.length ~/ playersPerTeam;

  static String teamName(int index) => 'Équipe ${index + 1}';

  int? teamOf(Player player) => teamByPlayer[player.id];

  List<Player> playersOf(int team) =>
      players.where((player) => teamByPlayer[player.id] == team).toList();

  bool isFull(int team) => playersOf(team).length >= playersPerTeam;

  /// False when moving [player] into [team] would overfill it.
  bool canAssign(Player player, int? team) {
    return team == null || teamOf(player) == team || !isFull(team);
  }

  /// Puts [player] in [team], or removes them from any team when null.
  TeamAssignment assign(Player player, int? team) {
    final updated = Map<String, int>.of(teamByPlayer);
    if (team == null) {
      updated.remove(player.id);
    } else {
      updated[player.id] = team;
    }
    return TeamAssignment(
      players: players,
      playersPerTeam: playersPerTeam,
      teamByPlayer: updated,
    );
  }

  /// Every player is placed and every team has exactly [playersPerTeam].
  bool get isComplete {
    if (teamCount == 0) return false;
    if (players.any((player) => teamOf(player) == null)) return false;
    for (var team = 0; team < teamCount; team++) {
      if (playersOf(team).length != playersPerTeam) return false;
    }
    return true;
  }

  List<Team> buildTeams({
    required String tournamentId,
    required String Function() newId,
  }) {
    return [
      for (var team = 0; team < teamCount; team++)
        Team(
          id: newId(),
          tournamentId: tournamentId,
          name: teamName(team),
          players: playersOf(team),
        ),
    ];
  }
}
