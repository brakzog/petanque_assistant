import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/player.dart';

class PlayerRepository {
  final AppDatabase database;

  PlayerRepository(this.database);

  Future<void> savePlayer(Player player) async {
    await database.into(database.players).insertOnConflictUpdate(
      PlayersCompanion(
        id: Value(player.id),
        tournamentId: Value(player.tournamentId),
        name: Value(player.name),
      ),
    );
  }

  Future<List<Player>> getPlayersForTournament(String tournamentId) async {
    final rows = await (database.select(database.players)
      ..where((table) => table.tournamentId.equals(tournamentId))
      ..orderBy([
            (table) => OrderingTerm.asc(table.name),
      ]))
        .get();

    return rows.map(_toDomain).toList();
  }

  Future<void> deletePlayer(String playerId) async {
    await (database.delete(database.players)
      ..where((table) => table.id.equals(playerId)))
        .go();
  }

  Player _toDomain(PlayerRow row) {
    return Player(
      id: row.id,
      tournamentId: row.tournamentId,
      name: row.name,
    );
  }
}