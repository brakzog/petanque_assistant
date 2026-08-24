import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/end.dart';

class EndRepository {
  final AppDatabase database;

  EndRepository(this.database);

  Future<List<End>> getEndsForMatch(String matchId) async {
    final rows = await (database.select(database.ends)
      ..where((table) => table.matchId.equals(matchId))
      ..orderBy([
            (table) => OrderingTerm.asc(table.number),
      ]))
        .get();

    return rows.map(_toDomain).toList();
  }

  Future<void> saveEnd(End end) async {
    await database.into(database.ends).insert(
      EndsCompanion(
        id: Value(end.id),
        matchId: Value(end.matchId),
        number: Value(end.number),
        scoringTeamId: Value(end.scoringTeamId),
        points: Value(end.points),
        createdAt: Value(end.createdAt),
      ),
    );
  }

  Future<void> deleteEnd(String endId) async {
    await (database.delete(database.ends)
      ..where((table) => table.id.equals(endId)))
        .go();
  }

  Future<void> deleteLastEnd(String matchId) async {
    final lastEnd = await (database.select(database.ends)
      ..where((table) => table.matchId.equals(matchId))
      ..orderBy([
            (table) => OrderingTerm.desc(table.number),
      ])
      ..limit(1))
        .getSingleOrNull();

    if (lastEnd == null) {
      return;
    }

    await (database.delete(database.ends)
      ..where((table) => table.id.equals(lastEnd.id)))
        .go();
  }

  End _toDomain(EndRow row) {
    return End(
      id: row.id,
      matchId: row.matchId,
      number: row.number,
      scoringTeamId: row.scoringTeamId,
      points: row.points,
      createdAt: row.createdAt,
    );
  }
}