import '../../../domain/player.dart';
import '../../../domain/team.dart';
import '../../../domain/tournament.dart';
import 'petanque_ball_repository.dart';
import 'player_repository.dart';
import 'team_generator.dart';
import 'team_repository.dart';

class Roster {
  const Roster({
    required this.players,
    required this.teams,
    required this.balls,
  });

  final List<Player> players;
  final List<Team> teams;

  /// playerId -> ball set, null when not filled in.
  final Map<String, PlayerBallData?> balls;
}

/// A change refused because of the tournament state, with a user message.
class RosterException implements Exception {
  const RosterException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Manages the participants and teams of a tournament.
class RosterService {
  const RosterService({
    required this.playerRepository,
    required this.teamRepository,
    required this.ballRepository,
    required this.teamGenerator,
    required this.newId,
  });

  static const _teamsLockedMessage =
      'Les équipes sont déjà constituées. '
      'Supprimez le tirage avant de modifier les participants.';

  final PlayerRepository playerRepository;
  final TeamRepository teamRepository;
  final PetanqueBallRepository ballRepository;
  final TeamGenerator teamGenerator;
  final String Function() newId;

  Future<Roster> load(Tournament tournament) async {
    final players = await playerRepository.getPlayersForTournament(
      tournament.id,
    );
    final teams = await teamRepository.getTeamsForTournament(tournament.id);

    final balls = <String, PlayerBallData?>{};
    for (final player in players) {
      balls[player.id] = await ballRepository.getForPlayer(player.id);
    }

    return Roster(players: players, teams: teams, balls: balls);
  }

  Future<void> addPlayer(
    Roster roster,
    Tournament tournament,
    String name,
  ) async {
    if (roster.teams.isNotEmpty) {
      throw const RosterException(_teamsLockedMessage);
    }
    await playerRepository.savePlayer(
      Player(id: newId(), tournamentId: tournament.id, name: name),
    );
  }

  Future<void> deletePlayer(Roster roster, Player player) async {
    if (roster.teams.isNotEmpty) {
      throw const RosterException(_teamsLockedMessage);
    }
    await playerRepository.deletePlayer(player.id);
  }

  Future<void> generateTeams(Roster roster, Tournament tournament) async {
    if (tournament.teamCreationMode != TeamCreationMode.random) {
      throw const RosterException(
        'Ce tournoi utilise des équipes prédéfinies.',
      );
    }
    if (roster.teams.isNotEmpty) {
      throw const RosterException('Les équipes ont déjà été constituées.');
    }

    final List<Team> teams;
    try {
      teams = teamGenerator.generateRandomTeams(
        tournament: tournament,
        players: roster.players,
      );
    } on ArgumentError catch (error) {
      throw RosterException(
        error.message?.toString() ?? 'Impossible de constituer les équipes.',
      );
    }

    for (final team in teams) {
      await teamRepository.saveTeam(team);
    }
  }

  Future<void> resetTeams(Tournament tournament) async {
    await teamRepository.deleteTeamsForTournament(tournament.id);
  }
}
