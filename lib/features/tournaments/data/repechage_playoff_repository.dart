import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/repechage_playoff.dart';

class RepechagePlayoffRepository {
  final AppDatabase database;

  RepechagePlayoffRepository(this.database);

  Future<void> save(
      RepechagePlayoff playoff,
      ) async {
    await database
        .into(database.repechagePlayoffs)
        .insertOnConflictUpdate(
      RepechagePlayoffsCompanion(
        id: Value(playoff.id),
        tournamentId: Value(playoff.tournamentId),
        teamIds: Value(playoff.teamIds.join(',')),
        qualificationSlots:
        Value(playoff.qualificationSlots),
        qualifiedTeamIds:
        Value(playoff.qualifiedTeamIds.join(',')),
        status: Value(playoff.status.name),
      ),
    );
  }

  Future<RepechagePlayoff?> getForTournament(
      String tournamentId,
      ) async {
    final row = await (database
        .select(database.repechagePlayoffs)
      ..where(
            (table) =>
            table.tournamentId.equals(tournamentId),
      ))
        .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return _toDomain(row);
  }

  Future<void> resolve({
    required RepechagePlayoff playoff,
    required List<String> qualifiedTeamIds,
  }) async {
    if (qualifiedTeamIds.length !=
        playoff.qualificationSlots) {
      throw ArgumentError(
        'Le nombre de qualifiés doit correspondre '
            'au nombre de places disponibles.',
      );
    }

    final allowedTeams = playoff.teamIds.toSet();

    if (!qualifiedTeamIds.every(allowedTeams.contains)) {
      throw ArgumentError(
        'Une équipe qualifiée ne fait pas partie du barrage.',
      );
    }

    if (qualifiedTeamIds.toSet().length !=
        qualifiedTeamIds.length) {
      throw ArgumentError(
        'Une équipe ne peut pas être qualifiée plusieurs fois.',
      );
    }

    await save(
      playoff.copyWith(
        qualifiedTeamIds: qualifiedTeamIds,
        status: RepechagePlayoffStatus.resolved,
      ),
    );
  }

  RepechagePlayoff _toDomain(
      RepechagePlayoffRow row,
      ) {
    return RepechagePlayoff(
      id: row.id,
      tournamentId: row.tournamentId,
      teamIds: _decodeIds(row.teamIds),
      qualificationSlots: row.qualificationSlots,
      qualifiedTeamIds:
      _decodeIds(row.qualifiedTeamIds),
      status: RepechagePlayoffStatus.values.byName(
        row.status,
      ),
    );
  }

  List<String> _decodeIds(String value) {
    if (value.trim().isEmpty) {
      return [];
    }

    return value
        .split(',')
        .where((id) => id.isNotEmpty)
        .toList();
  }
}