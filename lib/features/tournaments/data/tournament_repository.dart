import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/tournament.dart';
import '../../../domain/tournament_rules.dart';

class TournamentRepository {
  final AppDatabase database;

  TournamentRepository(this.database);

  Future<void> saveTournament(Tournament tournament) async {
    await database.into(database.tournaments).insertOnConflictUpdate(
      TournamentsCompanion(
        id: Value(tournament.id),
        name: Value(tournament.name),
        date: Value(tournament.date),
        location: Value(tournament.location),
        format: Value(tournament.format.name),
        teamCreationMode: Value(tournament.teamCreationMode.name),
        targetScore: Value(tournament.rules.targetScore),
        allowFirstRoundRepechage:
        Value(tournament.rules.allowFirstRoundRepechage),
        firstRoundRepechageSlots:
        Value(tournament.rules.firstRoundRepechageSlots),
        repechageRule: Value(tournament.rules.repechageRule.name),
      ),
    );
  }

  Future<List<Tournament>> getTournaments() async {
    final rows = await (database.select(database.tournaments)
      ..orderBy([
            (table) => OrderingTerm.desc(table.date),
      ]))
        .get();

    return rows.map(_toDomain).toList();
  }

  Future<Tournament?> getTournament(String id) async {
    final row = await (database.select(database.tournaments)
      ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    return row == null ? null : _toDomain(row);
  }

  Future<void> deleteTournament(String id) async {
    await (database.delete(database.tournaments)
      ..where((table) => table.id.equals(id)))
        .go();
  }

  Tournament _toDomain(TournamentRow row) {
    return Tournament(
      id: row.id,
      name: row.name,
      date: row.date,
      location: row.location,
      format: PetanqueFormat.values.byName(row.format),
      teamCreationMode:
      TeamCreationMode.values.byName(row.teamCreationMode),
      rules: TournamentRules(
        targetScore: row.targetScore,
        allowFirstRoundRepechage: row.allowFirstRoundRepechage,
        firstRoundRepechageSlots: row.firstRoundRepechageSlots,
        repechageRule: RepechageRule.values.byName(
          row.repechageRule,
        ),
      ),
    );
  }
}