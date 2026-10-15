import '../../../core/database/transaction_runner.dart';
import '../../../domain/petanque_format_rules.dart';
import '../../../domain/tournament.dart';
import '../domain/team_assignment.dart';
import 'player_repository.dart';
import 'team_repository.dart';

/// Loads and saves teams composed by hand.
class PredefinedTeamsService {
  const PredefinedTeamsService({
    required this.transactions,
    required this.playerRepository,
    required this.teamRepository,
    required this.newId,
  });

  final TransactionRunner transactions;
  final PlayerRepository playerRepository;
  final TeamRepository teamRepository;
  final String Function() newId;

  Future<TeamAssignment> load(Tournament tournament) async {
    final players = await playerRepository.getPlayersForTournament(
      tournament.id,
    );
    final teams = await teamRepository.getTeamsForTournament(tournament.id);

    return TeamAssignment.fromTeams(
      players: players,
      teams: teams,
      playersPerTeam: tournament.format.playersPerTeam,
    );
  }

  /// Replaces the tournament teams in one transaction.
  Future<void> save(Tournament tournament, TeamAssignment assignment) {
    final teams = assignment.buildTeams(
      tournamentId: tournament.id,
      newId: newId,
    );

    return transactions.run(() async {
      await teamRepository.deleteTeamsForTournament(tournament.id);
      for (final team in teams) {
        await teamRepository.saveTeam(team);
      }
    });
  }
}
