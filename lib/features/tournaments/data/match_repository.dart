import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/match.dart';

class MatchRepository {
  final AppDatabase database;

  MatchRepository(this.database);

  Future<void> saveMatch(Match match) async {
    await database.into(database.matches).insertOnConflictUpdate(
      MatchesCompanion(
        id: Value(match.id),
        tournamentId: Value(match.tournamentId),
        round: Value(match.round),
        position: Value(match.position),
        teamAId: Value(match.teamAId),
        teamBId: Value(match.teamBId),
        targetScore: Value(match.targetScore),
        teamAScore: Value(match.teamAScore),
        teamBScore: Value(match.teamBScore),
        status: Value(match.status.name),
        winnerTeamId: Value(match.winnerTeamId),
        type: Value(match.type.name),
      ),
    );
  }

  Future<void> saveMatches(List<Match> matches) async {
    await database.transaction(() async {
      for (final match in matches) {
        await saveMatch(match);
      }
    });
  }

  Future<List<Match>> getMatchesForTournament(
      String tournamentId,
      ) async {
    final rows = await (database.select(database.matches)
      ..where(
            (table) => table.tournamentId.equals(tournamentId),
      )
      ..orderBy([
            (table) => OrderingTerm.asc(table.round),
            (table) => OrderingTerm.asc(table.position),
      ]))
        .get();

    return rows.map(_toDomain).toList();
  }

  Future<List<Match>> getMatchesForRound(
      String tournamentId,
      int round,
      ) async {
    final rows = await (database.select(database.matches)
      ..where(
            (table) =>
        table.tournamentId.equals(tournamentId) &
        table.round.equals(round),
      )
      ..orderBy([
            (table) => OrderingTerm.asc(table.position),
      ]))
        .get();

    return rows.map(_toDomain).toList();
  }

  Future<Match?> getMatch(String matchId) async {
    final row = await (database.select(database.matches)
      ..where((table) => table.id.equals(matchId)))
        .getSingleOrNull();

    return row == null ? null : _toDomain(row);
  }

  Future<void> deleteMatchesForTournament(
      String tournamentId,
      ) async {
    await (database.delete(database.matches)
      ..where(
            (table) => table.tournamentId.equals(tournamentId),
      ))
        .go();
  }

  Match _toDomain(MatchRow row) {
    return Match(
      id: row.id,
      tournamentId: row.tournamentId,
      round: row.round,
      position: row.position,
      teamAId: row.teamAId,
      teamBId: row.teamBId,
      targetScore: row.targetScore,
      teamAScore: row.teamAScore,
      teamBScore: row.teamBScore,
      status: MatchStatus.values.byName(row.status),
      winnerTeamId: row.winnerTeamId,
      type: MatchType.values.byName(row.type),
    );
  }
}