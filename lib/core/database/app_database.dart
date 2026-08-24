import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('TournamentRow')
class Tournaments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get location => text().withDefault(const Constant(''))();
  TextColumn get format => text()();
  TextColumn get teamCreationMode => text()();
  IntColumn get targetScore => integer().withDefault(const Constant(13))();
  BoolColumn get allowFirstRoundRepechage =>
      boolean().withDefault(const Constant(false))();
  IntColumn get firstRoundRepechageSlots =>
      integer().withDefault(const Constant(0))();

  TextColumn get repechageRule =>
      text().withDefault(const Constant('bestScore'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PlayerRow')
class Players extends Table {
  TextColumn get id => text()();

  TextColumn get tournamentId => text().references(
    Tournaments,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PetanqueBallRow')
class PetanqueBalls extends Table {
  TextColumn get id => text()();

  TextColumn get playerId => text().references(
    Players,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get brand => text().nullable()();
  TextColumn get model => text().nullable()();
  IntColumn get diameter => integer().nullable()();
  IntColumn get weight => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TeamRow')
class Teams extends Table {
  TextColumn get id => text()();

  TextColumn get tournamentId => text().references(
    Tournaments,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TeamPlayerRow')
class TeamPlayers extends Table {
  TextColumn get teamId => text().references(
    Teams,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get playerId => text().references(
    Players,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column<Object>> get primaryKey => {
    teamId,
    playerId,
  };
}

@DataClassName('MatchRow')
class Matches extends Table {
  TextColumn get id => text()();

  TextColumn get tournamentId => text().references(
    Tournaments,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get round => integer()();

  IntColumn get position => integer()();

  TextColumn get teamAId => text().nullable().references(
    Teams,
    #id,
    onDelete: KeyAction.setNull,
  )();

  TextColumn get teamBId => text().nullable().references(
    Teams,
    #id,
    onDelete: KeyAction.setNull,
  )();

  IntColumn get targetScore => integer()();

  IntColumn get teamAScore =>
      integer().withDefault(const Constant(0))();

  IntColumn get teamBScore =>
      integer().withDefault(const Constant(0))();

  TextColumn get status =>
      text().withDefault(const Constant('pending'))();

  TextColumn get winnerTeamId =>
      text().nullable().references(
        Teams,
        #id,
        onDelete: KeyAction.setNull,
      )();

  @override
  Set<Column<Object>> get primaryKey => {id};

  TextColumn get type =>
      text().withDefault(const Constant('tournament'))();
}


@DataClassName('EndRow')
class Ends extends Table {
  TextColumn get id => text()();

  TextColumn get matchId => text().references(
    Matches,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get number => integer()();

  TextColumn get scoringTeamId => text().references(
    Teams,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get points => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RepechagePlayoffRow')
class RepechagePlayoffs extends Table {
  TextColumn get id => text()();

  TextColumn get tournamentId => text().references(
    Tournaments,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// IDs séparés par des virgules.
  TextColumn get teamIds => text()();

  IntColumn get qualificationSlots => integer()();

  /// Vide tant que le barrage n'est pas résolu.
  TextColumn get qualifiedTeamIds =>
      text().withDefault(const Constant(''))();

  TextColumn get status =>
      text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Tournaments,
    Players,
    PetanqueBalls,
    Teams,
    TeamPlayers,
    Matches,
    Ends,
    RepechagePlayoffs,
  ],
)

class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.createTable(players);
          await migrator.createTable(petanqueBalls);
        }

        if (from < 3) {
          await migrator.createTable(teams);
          await migrator.createTable(teamPlayers);
        }
        if (from < 4) {
          await migrator.createTable(matches);
        }
        if (from < 5) {
          await migrator.createTable(ends);
        }
        if (from < 6) {
          await migrator.addColumn(
            tournaments,
            tournaments.firstRoundRepechageSlots,
          );
        }

        if (from < 7) {
          await migrator.addColumn(
            matches,
            matches.type,
          );
        }

        if (from < 8) {
          await migrator.createTable(repechagePlayoffs);
        }

      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(
        directory.path,
        'tournoi_de_petanque.sqlite',
      ),
    );

    return NativeDatabase.createInBackground(file);
  });
}