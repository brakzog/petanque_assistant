import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/player.dart';
import '../../../domain/team.dart';

class TeamRepository {
  final AppDatabase database;

  TeamRepository(this.database);

  Future<List<Team>> getTeamsForTournament(String tournamentId) async {
    final teamRows = await (database.select(database.teams)
      ..where((table) => table.tournamentId.equals(tournamentId))
      ..orderBy([
            (table) => OrderingTerm.asc(table.name),
      ]))
        .get();

    final result = <Team>[];

    for (final teamRow in teamRows) {
      final query = database.select(database.players).join([
        innerJoin(
          database.teamPlayers,
          database.teamPlayers.playerId.equalsExp(database.players.id),
        ),
      ])
        ..where(database.teamPlayers.teamId.equals(teamRow.id));

      final rows = await query.get();

      final players = rows.map((row) {
        final playerRow = row.readTable(database.players);

        return Player(
          id: playerRow.id,
          tournamentId: playerRow.tournamentId,
          name: playerRow.name,
        );
      }).toList();

      result.add(
        Team(
          id: teamRow.id,
          tournamentId: teamRow.tournamentId,
          name: teamRow.name,
          players: players,
        ),
      );
    }

    return result;
  }

  Future<void> saveTeam(Team team) async {
    await database.transaction(() async {
      await database.into(database.teams).insertOnConflictUpdate(
        TeamsCompanion(
          id: Value(team.id),
          tournamentId: Value(team.tournamentId),
          name: Value(team.name),
        ),
      );

      await (database.delete(database.teamPlayers)
        ..where((table) => table.teamId.equals(team.id)))
          .go();

      for (final player in team.players) {
        await database.into(database.teamPlayers).insert(
          TeamPlayersCompanion.insert(
            teamId: team.id,
            playerId: player.id,
          ),
        );
      }
    });
  }

  Future<void> deleteTeamsForTournament(String tournamentId) async {
    await (database.delete(database.teams)
      ..where((table) => table.tournamentId.equals(tournamentId)))
        .go();
  }
}