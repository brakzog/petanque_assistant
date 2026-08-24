// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TournamentsTable extends Tournaments
    with TableInfo<$TournamentsTable, TournamentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamCreationModeMeta = const VerificationMeta(
    'teamCreationMode',
  );
  @override
  late final GeneratedColumn<String> teamCreationMode = GeneratedColumn<String>(
    'team_creation_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetScoreMeta = const VerificationMeta(
    'targetScore',
  );
  @override
  late final GeneratedColumn<int> targetScore = GeneratedColumn<int>(
    'target_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(13),
  );
  static const VerificationMeta _allowFirstRoundRepechageMeta =
      const VerificationMeta('allowFirstRoundRepechage');
  @override
  late final GeneratedColumn<bool> allowFirstRoundRepechage =
      GeneratedColumn<bool>(
        'allow_first_round_repechage',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("allow_first_round_repechage" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _firstRoundRepechageSlotsMeta =
      const VerificationMeta('firstRoundRepechageSlots');
  @override
  late final GeneratedColumn<int> firstRoundRepechageSlots =
      GeneratedColumn<int>(
        'first_round_repechage_slots',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _repechageRuleMeta = const VerificationMeta(
    'repechageRule',
  );
  @override
  late final GeneratedColumn<String> repechageRule = GeneratedColumn<String>(
    'repechage_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bestScore'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    date,
    location,
    format,
    teamCreationMode,
    targetScore,
    allowFirstRoundRepechage,
    firstRoundRepechageSlots,
    repechageRule,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournaments';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('team_creation_mode')) {
      context.handle(
        _teamCreationModeMeta,
        teamCreationMode.isAcceptableOrUnknown(
          data['team_creation_mode']!,
          _teamCreationModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_teamCreationModeMeta);
    }
    if (data.containsKey('target_score')) {
      context.handle(
        _targetScoreMeta,
        targetScore.isAcceptableOrUnknown(
          data['target_score']!,
          _targetScoreMeta,
        ),
      );
    }
    if (data.containsKey('allow_first_round_repechage')) {
      context.handle(
        _allowFirstRoundRepechageMeta,
        allowFirstRoundRepechage.isAcceptableOrUnknown(
          data['allow_first_round_repechage']!,
          _allowFirstRoundRepechageMeta,
        ),
      );
    }
    if (data.containsKey('first_round_repechage_slots')) {
      context.handle(
        _firstRoundRepechageSlotsMeta,
        firstRoundRepechageSlots.isAcceptableOrUnknown(
          data['first_round_repechage_slots']!,
          _firstRoundRepechageSlotsMeta,
        ),
      );
    }
    if (data.containsKey('repechage_rule')) {
      context.handle(
        _repechageRuleMeta,
        repechageRule.isAcceptableOrUnknown(
          data['repechage_rule']!,
          _repechageRuleMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TournamentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      teamCreationMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_creation_mode'],
      )!,
      targetScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_score'],
      )!,
      allowFirstRoundRepechage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allow_first_round_repechage'],
      )!,
      firstRoundRepechageSlots: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_round_repechage_slots'],
      )!,
      repechageRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repechage_rule'],
      )!,
    );
  }

  @override
  $TournamentsTable createAlias(String alias) {
    return $TournamentsTable(attachedDatabase, alias);
  }
}

class TournamentRow extends DataClass implements Insertable<TournamentRow> {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final String format;
  final String teamCreationMode;
  final int targetScore;
  final bool allowFirstRoundRepechage;
  final int firstRoundRepechageSlots;
  final String repechageRule;
  const TournamentRow({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.format,
    required this.teamCreationMode,
    required this.targetScore,
    required this.allowFirstRoundRepechage,
    required this.firstRoundRepechageSlots,
    required this.repechageRule,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<DateTime>(date);
    map['location'] = Variable<String>(location);
    map['format'] = Variable<String>(format);
    map['team_creation_mode'] = Variable<String>(teamCreationMode);
    map['target_score'] = Variable<int>(targetScore);
    map['allow_first_round_repechage'] = Variable<bool>(
      allowFirstRoundRepechage,
    );
    map['first_round_repechage_slots'] = Variable<int>(
      firstRoundRepechageSlots,
    );
    map['repechage_rule'] = Variable<String>(repechageRule);
    return map;
  }

  TournamentsCompanion toCompanion(bool nullToAbsent) {
    return TournamentsCompanion(
      id: Value(id),
      name: Value(name),
      date: Value(date),
      location: Value(location),
      format: Value(format),
      teamCreationMode: Value(teamCreationMode),
      targetScore: Value(targetScore),
      allowFirstRoundRepechage: Value(allowFirstRoundRepechage),
      firstRoundRepechageSlots: Value(firstRoundRepechageSlots),
      repechageRule: Value(repechageRule),
    );
  }

  factory TournamentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<DateTime>(json['date']),
      location: serializer.fromJson<String>(json['location']),
      format: serializer.fromJson<String>(json['format']),
      teamCreationMode: serializer.fromJson<String>(json['teamCreationMode']),
      targetScore: serializer.fromJson<int>(json['targetScore']),
      allowFirstRoundRepechage: serializer.fromJson<bool>(
        json['allowFirstRoundRepechage'],
      ),
      firstRoundRepechageSlots: serializer.fromJson<int>(
        json['firstRoundRepechageSlots'],
      ),
      repechageRule: serializer.fromJson<String>(json['repechageRule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<DateTime>(date),
      'location': serializer.toJson<String>(location),
      'format': serializer.toJson<String>(format),
      'teamCreationMode': serializer.toJson<String>(teamCreationMode),
      'targetScore': serializer.toJson<int>(targetScore),
      'allowFirstRoundRepechage': serializer.toJson<bool>(
        allowFirstRoundRepechage,
      ),
      'firstRoundRepechageSlots': serializer.toJson<int>(
        firstRoundRepechageSlots,
      ),
      'repechageRule': serializer.toJson<String>(repechageRule),
    };
  }

  TournamentRow copyWith({
    String? id,
    String? name,
    DateTime? date,
    String? location,
    String? format,
    String? teamCreationMode,
    int? targetScore,
    bool? allowFirstRoundRepechage,
    int? firstRoundRepechageSlots,
    String? repechageRule,
  }) => TournamentRow(
    id: id ?? this.id,
    name: name ?? this.name,
    date: date ?? this.date,
    location: location ?? this.location,
    format: format ?? this.format,
    teamCreationMode: teamCreationMode ?? this.teamCreationMode,
    targetScore: targetScore ?? this.targetScore,
    allowFirstRoundRepechage:
        allowFirstRoundRepechage ?? this.allowFirstRoundRepechage,
    firstRoundRepechageSlots:
        firstRoundRepechageSlots ?? this.firstRoundRepechageSlots,
    repechageRule: repechageRule ?? this.repechageRule,
  );
  TournamentRow copyWithCompanion(TournamentsCompanion data) {
    return TournamentRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      date: data.date.present ? data.date.value : this.date,
      location: data.location.present ? data.location.value : this.location,
      format: data.format.present ? data.format.value : this.format,
      teamCreationMode: data.teamCreationMode.present
          ? data.teamCreationMode.value
          : this.teamCreationMode,
      targetScore: data.targetScore.present
          ? data.targetScore.value
          : this.targetScore,
      allowFirstRoundRepechage: data.allowFirstRoundRepechage.present
          ? data.allowFirstRoundRepechage.value
          : this.allowFirstRoundRepechage,
      firstRoundRepechageSlots: data.firstRoundRepechageSlots.present
          ? data.firstRoundRepechageSlots.value
          : this.firstRoundRepechageSlots,
      repechageRule: data.repechageRule.present
          ? data.repechageRule.value
          : this.repechageRule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('location: $location, ')
          ..write('format: $format, ')
          ..write('teamCreationMode: $teamCreationMode, ')
          ..write('targetScore: $targetScore, ')
          ..write('allowFirstRoundRepechage: $allowFirstRoundRepechage, ')
          ..write('firstRoundRepechageSlots: $firstRoundRepechageSlots, ')
          ..write('repechageRule: $repechageRule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    date,
    location,
    format,
    teamCreationMode,
    targetScore,
    allowFirstRoundRepechage,
    firstRoundRepechageSlots,
    repechageRule,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.date == this.date &&
          other.location == this.location &&
          other.format == this.format &&
          other.teamCreationMode == this.teamCreationMode &&
          other.targetScore == this.targetScore &&
          other.allowFirstRoundRepechage == this.allowFirstRoundRepechage &&
          other.firstRoundRepechageSlots == this.firstRoundRepechageSlots &&
          other.repechageRule == this.repechageRule);
}

class TournamentsCompanion extends UpdateCompanion<TournamentRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> date;
  final Value<String> location;
  final Value<String> format;
  final Value<String> teamCreationMode;
  final Value<int> targetScore;
  final Value<bool> allowFirstRoundRepechage;
  final Value<int> firstRoundRepechageSlots;
  final Value<String> repechageRule;
  final Value<int> rowid;
  const TournamentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.location = const Value.absent(),
    this.format = const Value.absent(),
    this.teamCreationMode = const Value.absent(),
    this.targetScore = const Value.absent(),
    this.allowFirstRoundRepechage = const Value.absent(),
    this.firstRoundRepechageSlots = const Value.absent(),
    this.repechageRule = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TournamentsCompanion.insert({
    required String id,
    required String name,
    required DateTime date,
    this.location = const Value.absent(),
    required String format,
    required String teamCreationMode,
    this.targetScore = const Value.absent(),
    this.allowFirstRoundRepechage = const Value.absent(),
    this.firstRoundRepechageSlots = const Value.absent(),
    this.repechageRule = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       date = Value(date),
       format = Value(format),
       teamCreationMode = Value(teamCreationMode);
  static Insertable<TournamentRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? date,
    Expression<String>? location,
    Expression<String>? format,
    Expression<String>? teamCreationMode,
    Expression<int>? targetScore,
    Expression<bool>? allowFirstRoundRepechage,
    Expression<int>? firstRoundRepechageSlots,
    Expression<String>? repechageRule,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (location != null) 'location': location,
      if (format != null) 'format': format,
      if (teamCreationMode != null) 'team_creation_mode': teamCreationMode,
      if (targetScore != null) 'target_score': targetScore,
      if (allowFirstRoundRepechage != null)
        'allow_first_round_repechage': allowFirstRoundRepechage,
      if (firstRoundRepechageSlots != null)
        'first_round_repechage_slots': firstRoundRepechageSlots,
      if (repechageRule != null) 'repechage_rule': repechageRule,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TournamentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? date,
    Value<String>? location,
    Value<String>? format,
    Value<String>? teamCreationMode,
    Value<int>? targetScore,
    Value<bool>? allowFirstRoundRepechage,
    Value<int>? firstRoundRepechageSlots,
    Value<String>? repechageRule,
    Value<int>? rowid,
  }) {
    return TournamentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      location: location ?? this.location,
      format: format ?? this.format,
      teamCreationMode: teamCreationMode ?? this.teamCreationMode,
      targetScore: targetScore ?? this.targetScore,
      allowFirstRoundRepechage:
          allowFirstRoundRepechage ?? this.allowFirstRoundRepechage,
      firstRoundRepechageSlots:
          firstRoundRepechageSlots ?? this.firstRoundRepechageSlots,
      repechageRule: repechageRule ?? this.repechageRule,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (teamCreationMode.present) {
      map['team_creation_mode'] = Variable<String>(teamCreationMode.value);
    }
    if (targetScore.present) {
      map['target_score'] = Variable<int>(targetScore.value);
    }
    if (allowFirstRoundRepechage.present) {
      map['allow_first_round_repechage'] = Variable<bool>(
        allowFirstRoundRepechage.value,
      );
    }
    if (firstRoundRepechageSlots.present) {
      map['first_round_repechage_slots'] = Variable<int>(
        firstRoundRepechageSlots.value,
      );
    }
    if (repechageRule.present) {
      map['repechage_rule'] = Variable<String>(repechageRule.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('location: $location, ')
          ..write('format: $format, ')
          ..write('teamCreationMode: $teamCreationMode, ')
          ..write('targetScore: $targetScore, ')
          ..write('allowFirstRoundRepechage: $allowFirstRoundRepechage, ')
          ..write('firstRoundRepechageSlots: $firstRoundRepechageSlots, ')
          ..write('repechageRule: $repechageRule, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, PlayerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<String> tournamentId = GeneratedColumn<String>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournaments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tournamentId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class PlayerRow extends DataClass implements Insertable<PlayerRow> {
  final String id;
  final String tournamentId;
  final String name;
  const PlayerRow({
    required this.id,
    required this.tournamentId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tournament_id'] = Variable<String>(tournamentId);
    map['name'] = Variable<String>(name);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      tournamentId: Value(tournamentId),
      name: Value(name),
    );
  }

  factory PlayerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerRow(
      id: serializer.fromJson<String>(json['id']),
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tournamentId': serializer.toJson<String>(tournamentId),
      'name': serializer.toJson<String>(name),
    };
  }

  PlayerRow copyWith({String? id, String? tournamentId, String? name}) =>
      PlayerRow(
        id: id ?? this.id,
        tournamentId: tournamentId ?? this.tournamentId,
        name: name ?? this.name,
      );
  PlayerRow copyWithCompanion(PlayersCompanion data) {
    return PlayerRow(
      id: data.id.present ? data.id.value : this.id,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerRow(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tournamentId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerRow &&
          other.id == this.id &&
          other.tournamentId == this.tournamentId &&
          other.name == this.name);
}

class PlayersCompanion extends UpdateCompanion<PlayerRow> {
  final Value<String> id;
  final Value<String> tournamentId;
  final Value<String> name;
  final Value<int> rowid;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayersCompanion.insert({
    required String id,
    required String tournamentId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tournamentId = Value(tournamentId),
       name = Value(name);
  static Insertable<PlayerRow> custom({
    Expression<String>? id,
    Expression<String>? tournamentId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayersCompanion copyWith({
    Value<String>? id,
    Value<String>? tournamentId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PetanqueBallsTable extends PetanqueBalls
    with TableInfo<$PetanqueBallsTable, PetanqueBallRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetanqueBallsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diameterMeta = const VerificationMeta(
    'diameter',
  );
  @override
  late final GeneratedColumn<int> diameter = GeneratedColumn<int>(
    'diameter',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    playerId,
    brand,
    model,
    diameter,
    weight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'petanque_balls';
  @override
  VerificationContext validateIntegrity(
    Insertable<PetanqueBallRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('diameter')) {
      context.handle(
        _diameterMeta,
        diameter.isAcceptableOrUnknown(data['diameter']!, _diameterMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PetanqueBallRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PetanqueBallRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      diameter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diameter'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight'],
      ),
    );
  }

  @override
  $PetanqueBallsTable createAlias(String alias) {
    return $PetanqueBallsTable(attachedDatabase, alias);
  }
}

class PetanqueBallRow extends DataClass implements Insertable<PetanqueBallRow> {
  final String id;
  final String playerId;
  final String? brand;
  final String? model;
  final int? diameter;
  final int? weight;
  const PetanqueBallRow({
    required this.id,
    required this.playerId,
    this.brand,
    this.model,
    this.diameter,
    this.weight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['player_id'] = Variable<String>(playerId);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || diameter != null) {
      map['diameter'] = Variable<int>(diameter);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<int>(weight);
    }
    return map;
  }

  PetanqueBallsCompanion toCompanion(bool nullToAbsent) {
    return PetanqueBallsCompanion(
      id: Value(id),
      playerId: Value(playerId),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      diameter: diameter == null && nullToAbsent
          ? const Value.absent()
          : Value(diameter),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
    );
  }

  factory PetanqueBallRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PetanqueBallRow(
      id: serializer.fromJson<String>(json['id']),
      playerId: serializer.fromJson<String>(json['playerId']),
      brand: serializer.fromJson<String?>(json['brand']),
      model: serializer.fromJson<String?>(json['model']),
      diameter: serializer.fromJson<int?>(json['diameter']),
      weight: serializer.fromJson<int?>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'playerId': serializer.toJson<String>(playerId),
      'brand': serializer.toJson<String?>(brand),
      'model': serializer.toJson<String?>(model),
      'diameter': serializer.toJson<int?>(diameter),
      'weight': serializer.toJson<int?>(weight),
    };
  }

  PetanqueBallRow copyWith({
    String? id,
    String? playerId,
    Value<String?> brand = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<int?> diameter = const Value.absent(),
    Value<int?> weight = const Value.absent(),
  }) => PetanqueBallRow(
    id: id ?? this.id,
    playerId: playerId ?? this.playerId,
    brand: brand.present ? brand.value : this.brand,
    model: model.present ? model.value : this.model,
    diameter: diameter.present ? diameter.value : this.diameter,
    weight: weight.present ? weight.value : this.weight,
  );
  PetanqueBallRow copyWithCompanion(PetanqueBallsCompanion data) {
    return PetanqueBallRow(
      id: data.id.present ? data.id.value : this.id,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      diameter: data.diameter.present ? data.diameter.value : this.diameter,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PetanqueBallRow(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('diameter: $diameter, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playerId, brand, model, diameter, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetanqueBallRow &&
          other.id == this.id &&
          other.playerId == this.playerId &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.diameter == this.diameter &&
          other.weight == this.weight);
}

class PetanqueBallsCompanion extends UpdateCompanion<PetanqueBallRow> {
  final Value<String> id;
  final Value<String> playerId;
  final Value<String?> brand;
  final Value<String?> model;
  final Value<int?> diameter;
  final Value<int?> weight;
  final Value<int> rowid;
  const PetanqueBallsCompanion({
    this.id = const Value.absent(),
    this.playerId = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.diameter = const Value.absent(),
    this.weight = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetanqueBallsCompanion.insert({
    required String id,
    required String playerId,
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.diameter = const Value.absent(),
    this.weight = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       playerId = Value(playerId);
  static Insertable<PetanqueBallRow> custom({
    Expression<String>? id,
    Expression<String>? playerId,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? diameter,
    Expression<int>? weight,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playerId != null) 'player_id': playerId,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (diameter != null) 'diameter': diameter,
      if (weight != null) 'weight': weight,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetanqueBallsCompanion copyWith({
    Value<String>? id,
    Value<String>? playerId,
    Value<String?>? brand,
    Value<String?>? model,
    Value<int?>? diameter,
    Value<int?>? weight,
    Value<int>? rowid,
  }) {
    return PetanqueBallsCompanion(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      diameter: diameter ?? this.diameter,
      weight: weight ?? this.weight,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (diameter.present) {
      map['diameter'] = Variable<int>(diameter.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetanqueBallsCompanion(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('diameter: $diameter, ')
          ..write('weight: $weight, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeamsTable extends Teams with TableInfo<$TeamsTable, TeamRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<String> tournamentId = GeneratedColumn<String>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournaments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tournamentId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeamRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeamRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TeamsTable createAlias(String alias) {
    return $TeamsTable(attachedDatabase, alias);
  }
}

class TeamRow extends DataClass implements Insertable<TeamRow> {
  final String id;
  final String tournamentId;
  final String name;
  const TeamRow({
    required this.id,
    required this.tournamentId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tournament_id'] = Variable<String>(tournamentId);
    map['name'] = Variable<String>(name);
    return map;
  }

  TeamsCompanion toCompanion(bool nullToAbsent) {
    return TeamsCompanion(
      id: Value(id),
      tournamentId: Value(tournamentId),
      name: Value(name),
    );
  }

  factory TeamRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamRow(
      id: serializer.fromJson<String>(json['id']),
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tournamentId': serializer.toJson<String>(tournamentId),
      'name': serializer.toJson<String>(name),
    };
  }

  TeamRow copyWith({String? id, String? tournamentId, String? name}) => TeamRow(
    id: id ?? this.id,
    tournamentId: tournamentId ?? this.tournamentId,
    name: name ?? this.name,
  );
  TeamRow copyWithCompanion(TeamsCompanion data) {
    return TeamRow(
      id: data.id.present ? data.id.value : this.id,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamRow(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tournamentId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamRow &&
          other.id == this.id &&
          other.tournamentId == this.tournamentId &&
          other.name == this.name);
}

class TeamsCompanion extends UpdateCompanion<TeamRow> {
  final Value<String> id;
  final Value<String> tournamentId;
  final Value<String> name;
  final Value<int> rowid;
  const TeamsCompanion({
    this.id = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeamsCompanion.insert({
    required String id,
    required String tournamentId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tournamentId = Value(tournamentId),
       name = Value(name);
  static Insertable<TeamRow> custom({
    Expression<String>? id,
    Expression<String>? tournamentId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeamsCompanion copyWith({
    Value<String>? id,
    Value<String>? tournamentId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return TeamsCompanion(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsCompanion(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeamPlayersTable extends TeamPlayers
    with TableInfo<$TeamPlayersTable, TeamPlayerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamPlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<String> teamId = GeneratedColumn<String>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [teamId, playerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_players';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeamPlayerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {teamId, playerId};
  @override
  TeamPlayerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamPlayerRow(
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
    );
  }

  @override
  $TeamPlayersTable createAlias(String alias) {
    return $TeamPlayersTable(attachedDatabase, alias);
  }
}

class TeamPlayerRow extends DataClass implements Insertable<TeamPlayerRow> {
  final String teamId;
  final String playerId;
  const TeamPlayerRow({required this.teamId, required this.playerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['team_id'] = Variable<String>(teamId);
    map['player_id'] = Variable<String>(playerId);
    return map;
  }

  TeamPlayersCompanion toCompanion(bool nullToAbsent) {
    return TeamPlayersCompanion(
      teamId: Value(teamId),
      playerId: Value(playerId),
    );
  }

  factory TeamPlayerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamPlayerRow(
      teamId: serializer.fromJson<String>(json['teamId']),
      playerId: serializer.fromJson<String>(json['playerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'teamId': serializer.toJson<String>(teamId),
      'playerId': serializer.toJson<String>(playerId),
    };
  }

  TeamPlayerRow copyWith({String? teamId, String? playerId}) => TeamPlayerRow(
    teamId: teamId ?? this.teamId,
    playerId: playerId ?? this.playerId,
  );
  TeamPlayerRow copyWithCompanion(TeamPlayersCompanion data) {
    return TeamPlayerRow(
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamPlayerRow(')
          ..write('teamId: $teamId, ')
          ..write('playerId: $playerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(teamId, playerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamPlayerRow &&
          other.teamId == this.teamId &&
          other.playerId == this.playerId);
}

class TeamPlayersCompanion extends UpdateCompanion<TeamPlayerRow> {
  final Value<String> teamId;
  final Value<String> playerId;
  final Value<int> rowid;
  const TeamPlayersCompanion({
    this.teamId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeamPlayersCompanion.insert({
    required String teamId,
    required String playerId,
    this.rowid = const Value.absent(),
  }) : teamId = Value(teamId),
       playerId = Value(playerId);
  static Insertable<TeamPlayerRow> custom({
    Expression<String>? teamId,
    Expression<String>? playerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (teamId != null) 'team_id': teamId,
      if (playerId != null) 'player_id': playerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeamPlayersCompanion copyWith({
    Value<String>? teamId,
    Value<String>? playerId,
    Value<int>? rowid,
  }) {
    return TeamPlayersCompanion(
      teamId: teamId ?? this.teamId,
      playerId: playerId ?? this.playerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (teamId.present) {
      map['team_id'] = Variable<String>(teamId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamPlayersCompanion(')
          ..write('teamId: $teamId, ')
          ..write('playerId: $playerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MatchesTable extends Matches with TableInfo<$MatchesTable, MatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<String> tournamentId = GeneratedColumn<String>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournaments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
    'round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamAIdMeta = const VerificationMeta(
    'teamAId',
  );
  @override
  late final GeneratedColumn<String> teamAId = GeneratedColumn<String>(
    'team_a_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _teamBIdMeta = const VerificationMeta(
    'teamBId',
  );
  @override
  late final GeneratedColumn<String> teamBId = GeneratedColumn<String>(
    'team_b_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _targetScoreMeta = const VerificationMeta(
    'targetScore',
  );
  @override
  late final GeneratedColumn<int> targetScore = GeneratedColumn<int>(
    'target_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamAScoreMeta = const VerificationMeta(
    'teamAScore',
  );
  @override
  late final GeneratedColumn<int> teamAScore = GeneratedColumn<int>(
    'team_a_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _teamBScoreMeta = const VerificationMeta(
    'teamBScore',
  );
  @override
  late final GeneratedColumn<int> teamBScore = GeneratedColumn<int>(
    'team_b_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _winnerTeamIdMeta = const VerificationMeta(
    'winnerTeamId',
  );
  @override
  late final GeneratedColumn<String> winnerTeamId = GeneratedColumn<String>(
    'winner_team_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tournament'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tournamentId,
    round,
    position,
    teamAId,
    teamBId,
    targetScore,
    teamAScore,
    teamBScore,
    status,
    winnerTeamId,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'matches';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('round')) {
      context.handle(
        _roundMeta,
        round.isAcceptableOrUnknown(data['round']!, _roundMeta),
      );
    } else if (isInserting) {
      context.missing(_roundMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('team_a_id')) {
      context.handle(
        _teamAIdMeta,
        teamAId.isAcceptableOrUnknown(data['team_a_id']!, _teamAIdMeta),
      );
    }
    if (data.containsKey('team_b_id')) {
      context.handle(
        _teamBIdMeta,
        teamBId.isAcceptableOrUnknown(data['team_b_id']!, _teamBIdMeta),
      );
    }
    if (data.containsKey('target_score')) {
      context.handle(
        _targetScoreMeta,
        targetScore.isAcceptableOrUnknown(
          data['target_score']!,
          _targetScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetScoreMeta);
    }
    if (data.containsKey('team_a_score')) {
      context.handle(
        _teamAScoreMeta,
        teamAScore.isAcceptableOrUnknown(
          data['team_a_score']!,
          _teamAScoreMeta,
        ),
      );
    }
    if (data.containsKey('team_b_score')) {
      context.handle(
        _teamBScoreMeta,
        teamBScore.isAcceptableOrUnknown(
          data['team_b_score']!,
          _teamBScoreMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('winner_team_id')) {
      context.handle(
        _winnerTeamIdMeta,
        winnerTeamId.isAcceptableOrUnknown(
          data['winner_team_id']!,
          _winnerTeamIdMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      round: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      teamAId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_a_id'],
      ),
      teamBId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_b_id'],
      ),
      targetScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_score'],
      )!,
      teamAScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_a_score'],
      )!,
      teamBScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_b_score'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      winnerTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}winner_team_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $MatchesTable createAlias(String alias) {
    return $MatchesTable(attachedDatabase, alias);
  }
}

class MatchRow extends DataClass implements Insertable<MatchRow> {
  final String id;
  final String tournamentId;
  final int round;
  final int position;
  final String? teamAId;
  final String? teamBId;
  final int targetScore;
  final int teamAScore;
  final int teamBScore;
  final String status;
  final String? winnerTeamId;
  final String type;
  const MatchRow({
    required this.id,
    required this.tournamentId,
    required this.round,
    required this.position,
    this.teamAId,
    this.teamBId,
    required this.targetScore,
    required this.teamAScore,
    required this.teamBScore,
    required this.status,
    this.winnerTeamId,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tournament_id'] = Variable<String>(tournamentId);
    map['round'] = Variable<int>(round);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || teamAId != null) {
      map['team_a_id'] = Variable<String>(teamAId);
    }
    if (!nullToAbsent || teamBId != null) {
      map['team_b_id'] = Variable<String>(teamBId);
    }
    map['target_score'] = Variable<int>(targetScore);
    map['team_a_score'] = Variable<int>(teamAScore);
    map['team_b_score'] = Variable<int>(teamBScore);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || winnerTeamId != null) {
      map['winner_team_id'] = Variable<String>(winnerTeamId);
    }
    map['type'] = Variable<String>(type);
    return map;
  }

  MatchesCompanion toCompanion(bool nullToAbsent) {
    return MatchesCompanion(
      id: Value(id),
      tournamentId: Value(tournamentId),
      round: Value(round),
      position: Value(position),
      teamAId: teamAId == null && nullToAbsent
          ? const Value.absent()
          : Value(teamAId),
      teamBId: teamBId == null && nullToAbsent
          ? const Value.absent()
          : Value(teamBId),
      targetScore: Value(targetScore),
      teamAScore: Value(teamAScore),
      teamBScore: Value(teamBScore),
      status: Value(status),
      winnerTeamId: winnerTeamId == null && nullToAbsent
          ? const Value.absent()
          : Value(winnerTeamId),
      type: Value(type),
    );
  }

  factory MatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchRow(
      id: serializer.fromJson<String>(json['id']),
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      round: serializer.fromJson<int>(json['round']),
      position: serializer.fromJson<int>(json['position']),
      teamAId: serializer.fromJson<String?>(json['teamAId']),
      teamBId: serializer.fromJson<String?>(json['teamBId']),
      targetScore: serializer.fromJson<int>(json['targetScore']),
      teamAScore: serializer.fromJson<int>(json['teamAScore']),
      teamBScore: serializer.fromJson<int>(json['teamBScore']),
      status: serializer.fromJson<String>(json['status']),
      winnerTeamId: serializer.fromJson<String?>(json['winnerTeamId']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tournamentId': serializer.toJson<String>(tournamentId),
      'round': serializer.toJson<int>(round),
      'position': serializer.toJson<int>(position),
      'teamAId': serializer.toJson<String?>(teamAId),
      'teamBId': serializer.toJson<String?>(teamBId),
      'targetScore': serializer.toJson<int>(targetScore),
      'teamAScore': serializer.toJson<int>(teamAScore),
      'teamBScore': serializer.toJson<int>(teamBScore),
      'status': serializer.toJson<String>(status),
      'winnerTeamId': serializer.toJson<String?>(winnerTeamId),
      'type': serializer.toJson<String>(type),
    };
  }

  MatchRow copyWith({
    String? id,
    String? tournamentId,
    int? round,
    int? position,
    Value<String?> teamAId = const Value.absent(),
    Value<String?> teamBId = const Value.absent(),
    int? targetScore,
    int? teamAScore,
    int? teamBScore,
    String? status,
    Value<String?> winnerTeamId = const Value.absent(),
    String? type,
  }) => MatchRow(
    id: id ?? this.id,
    tournamentId: tournamentId ?? this.tournamentId,
    round: round ?? this.round,
    position: position ?? this.position,
    teamAId: teamAId.present ? teamAId.value : this.teamAId,
    teamBId: teamBId.present ? teamBId.value : this.teamBId,
    targetScore: targetScore ?? this.targetScore,
    teamAScore: teamAScore ?? this.teamAScore,
    teamBScore: teamBScore ?? this.teamBScore,
    status: status ?? this.status,
    winnerTeamId: winnerTeamId.present ? winnerTeamId.value : this.winnerTeamId,
    type: type ?? this.type,
  );
  MatchRow copyWithCompanion(MatchesCompanion data) {
    return MatchRow(
      id: data.id.present ? data.id.value : this.id,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      round: data.round.present ? data.round.value : this.round,
      position: data.position.present ? data.position.value : this.position,
      teamAId: data.teamAId.present ? data.teamAId.value : this.teamAId,
      teamBId: data.teamBId.present ? data.teamBId.value : this.teamBId,
      targetScore: data.targetScore.present
          ? data.targetScore.value
          : this.targetScore,
      teamAScore: data.teamAScore.present
          ? data.teamAScore.value
          : this.teamAScore,
      teamBScore: data.teamBScore.present
          ? data.teamBScore.value
          : this.teamBScore,
      status: data.status.present ? data.status.value : this.status,
      winnerTeamId: data.winnerTeamId.present
          ? data.winnerTeamId.value
          : this.winnerTeamId,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchRow(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('round: $round, ')
          ..write('position: $position, ')
          ..write('teamAId: $teamAId, ')
          ..write('teamBId: $teamBId, ')
          ..write('targetScore: $targetScore, ')
          ..write('teamAScore: $teamAScore, ')
          ..write('teamBScore: $teamBScore, ')
          ..write('status: $status, ')
          ..write('winnerTeamId: $winnerTeamId, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tournamentId,
    round,
    position,
    teamAId,
    teamBId,
    targetScore,
    teamAScore,
    teamBScore,
    status,
    winnerTeamId,
    type,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchRow &&
          other.id == this.id &&
          other.tournamentId == this.tournamentId &&
          other.round == this.round &&
          other.position == this.position &&
          other.teamAId == this.teamAId &&
          other.teamBId == this.teamBId &&
          other.targetScore == this.targetScore &&
          other.teamAScore == this.teamAScore &&
          other.teamBScore == this.teamBScore &&
          other.status == this.status &&
          other.winnerTeamId == this.winnerTeamId &&
          other.type == this.type);
}

class MatchesCompanion extends UpdateCompanion<MatchRow> {
  final Value<String> id;
  final Value<String> tournamentId;
  final Value<int> round;
  final Value<int> position;
  final Value<String?> teamAId;
  final Value<String?> teamBId;
  final Value<int> targetScore;
  final Value<int> teamAScore;
  final Value<int> teamBScore;
  final Value<String> status;
  final Value<String?> winnerTeamId;
  final Value<String> type;
  final Value<int> rowid;
  const MatchesCompanion({
    this.id = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.round = const Value.absent(),
    this.position = const Value.absent(),
    this.teamAId = const Value.absent(),
    this.teamBId = const Value.absent(),
    this.targetScore = const Value.absent(),
    this.teamAScore = const Value.absent(),
    this.teamBScore = const Value.absent(),
    this.status = const Value.absent(),
    this.winnerTeamId = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MatchesCompanion.insert({
    required String id,
    required String tournamentId,
    required int round,
    required int position,
    this.teamAId = const Value.absent(),
    this.teamBId = const Value.absent(),
    required int targetScore,
    this.teamAScore = const Value.absent(),
    this.teamBScore = const Value.absent(),
    this.status = const Value.absent(),
    this.winnerTeamId = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tournamentId = Value(tournamentId),
       round = Value(round),
       position = Value(position),
       targetScore = Value(targetScore);
  static Insertable<MatchRow> custom({
    Expression<String>? id,
    Expression<String>? tournamentId,
    Expression<int>? round,
    Expression<int>? position,
    Expression<String>? teamAId,
    Expression<String>? teamBId,
    Expression<int>? targetScore,
    Expression<int>? teamAScore,
    Expression<int>? teamBScore,
    Expression<String>? status,
    Expression<String>? winnerTeamId,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (round != null) 'round': round,
      if (position != null) 'position': position,
      if (teamAId != null) 'team_a_id': teamAId,
      if (teamBId != null) 'team_b_id': teamBId,
      if (targetScore != null) 'target_score': targetScore,
      if (teamAScore != null) 'team_a_score': teamAScore,
      if (teamBScore != null) 'team_b_score': teamBScore,
      if (status != null) 'status': status,
      if (winnerTeamId != null) 'winner_team_id': winnerTeamId,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MatchesCompanion copyWith({
    Value<String>? id,
    Value<String>? tournamentId,
    Value<int>? round,
    Value<int>? position,
    Value<String?>? teamAId,
    Value<String?>? teamBId,
    Value<int>? targetScore,
    Value<int>? teamAScore,
    Value<int>? teamBScore,
    Value<String>? status,
    Value<String?>? winnerTeamId,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return MatchesCompanion(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      round: round ?? this.round,
      position: position ?? this.position,
      teamAId: teamAId ?? this.teamAId,
      teamBId: teamBId ?? this.teamBId,
      targetScore: targetScore ?? this.targetScore,
      teamAScore: teamAScore ?? this.teamAScore,
      teamBScore: teamBScore ?? this.teamBScore,
      status: status ?? this.status,
      winnerTeamId: winnerTeamId ?? this.winnerTeamId,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (round.present) {
      map['round'] = Variable<int>(round.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (teamAId.present) {
      map['team_a_id'] = Variable<String>(teamAId.value);
    }
    if (teamBId.present) {
      map['team_b_id'] = Variable<String>(teamBId.value);
    }
    if (targetScore.present) {
      map['target_score'] = Variable<int>(targetScore.value);
    }
    if (teamAScore.present) {
      map['team_a_score'] = Variable<int>(teamAScore.value);
    }
    if (teamBScore.present) {
      map['team_b_score'] = Variable<int>(teamBScore.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (winnerTeamId.present) {
      map['winner_team_id'] = Variable<String>(winnerTeamId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchesCompanion(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('round: $round, ')
          ..write('position: $position, ')
          ..write('teamAId: $teamAId, ')
          ..write('teamBId: $teamBId, ')
          ..write('targetScore: $targetScore, ')
          ..write('teamAScore: $teamAScore, ')
          ..write('teamBScore: $teamBScore, ')
          ..write('status: $status, ')
          ..write('winnerTeamId: $winnerTeamId, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EndsTable extends Ends with TableInfo<$EndsTable, EndRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EndsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _matchIdMeta = const VerificationMeta(
    'matchId',
  );
  @override
  late final GeneratedColumn<String> matchId = GeneratedColumn<String>(
    'match_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES matches (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoringTeamIdMeta = const VerificationMeta(
    'scoringTeamId',
  );
  @override
  late final GeneratedColumn<String> scoringTeamId = GeneratedColumn<String>(
    'scoring_team_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    matchId,
    number,
    scoringTeamId,
    points,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ends';
  @override
  VerificationContext validateIntegrity(
    Insertable<EndRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('match_id')) {
      context.handle(
        _matchIdMeta,
        matchId.isAcceptableOrUnknown(data['match_id']!, _matchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_matchIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('scoring_team_id')) {
      context.handle(
        _scoringTeamIdMeta,
        scoringTeamId.isAcceptableOrUnknown(
          data['scoring_team_id']!,
          _scoringTeamIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scoringTeamIdMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EndRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EndRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      matchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      scoringTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scoring_team_id'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EndsTable createAlias(String alias) {
    return $EndsTable(attachedDatabase, alias);
  }
}

class EndRow extends DataClass implements Insertable<EndRow> {
  final String id;
  final String matchId;
  final int number;
  final String scoringTeamId;
  final int points;
  final DateTime createdAt;
  const EndRow({
    required this.id,
    required this.matchId,
    required this.number,
    required this.scoringTeamId,
    required this.points,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['match_id'] = Variable<String>(matchId);
    map['number'] = Variable<int>(number);
    map['scoring_team_id'] = Variable<String>(scoringTeamId);
    map['points'] = Variable<int>(points);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EndsCompanion toCompanion(bool nullToAbsent) {
    return EndsCompanion(
      id: Value(id),
      matchId: Value(matchId),
      number: Value(number),
      scoringTeamId: Value(scoringTeamId),
      points: Value(points),
      createdAt: Value(createdAt),
    );
  }

  factory EndRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EndRow(
      id: serializer.fromJson<String>(json['id']),
      matchId: serializer.fromJson<String>(json['matchId']),
      number: serializer.fromJson<int>(json['number']),
      scoringTeamId: serializer.fromJson<String>(json['scoringTeamId']),
      points: serializer.fromJson<int>(json['points']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'matchId': serializer.toJson<String>(matchId),
      'number': serializer.toJson<int>(number),
      'scoringTeamId': serializer.toJson<String>(scoringTeamId),
      'points': serializer.toJson<int>(points),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EndRow copyWith({
    String? id,
    String? matchId,
    int? number,
    String? scoringTeamId,
    int? points,
    DateTime? createdAt,
  }) => EndRow(
    id: id ?? this.id,
    matchId: matchId ?? this.matchId,
    number: number ?? this.number,
    scoringTeamId: scoringTeamId ?? this.scoringTeamId,
    points: points ?? this.points,
    createdAt: createdAt ?? this.createdAt,
  );
  EndRow copyWithCompanion(EndsCompanion data) {
    return EndRow(
      id: data.id.present ? data.id.value : this.id,
      matchId: data.matchId.present ? data.matchId.value : this.matchId,
      number: data.number.present ? data.number.value : this.number,
      scoringTeamId: data.scoringTeamId.present
          ? data.scoringTeamId.value
          : this.scoringTeamId,
      points: data.points.present ? data.points.value : this.points,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EndRow(')
          ..write('id: $id, ')
          ..write('matchId: $matchId, ')
          ..write('number: $number, ')
          ..write('scoringTeamId: $scoringTeamId, ')
          ..write('points: $points, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, matchId, number, scoringTeamId, points, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EndRow &&
          other.id == this.id &&
          other.matchId == this.matchId &&
          other.number == this.number &&
          other.scoringTeamId == this.scoringTeamId &&
          other.points == this.points &&
          other.createdAt == this.createdAt);
}

class EndsCompanion extends UpdateCompanion<EndRow> {
  final Value<String> id;
  final Value<String> matchId;
  final Value<int> number;
  final Value<String> scoringTeamId;
  final Value<int> points;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EndsCompanion({
    this.id = const Value.absent(),
    this.matchId = const Value.absent(),
    this.number = const Value.absent(),
    this.scoringTeamId = const Value.absent(),
    this.points = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EndsCompanion.insert({
    required String id,
    required String matchId,
    required int number,
    required String scoringTeamId,
    required int points,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       matchId = Value(matchId),
       number = Value(number),
       scoringTeamId = Value(scoringTeamId),
       points = Value(points),
       createdAt = Value(createdAt);
  static Insertable<EndRow> custom({
    Expression<String>? id,
    Expression<String>? matchId,
    Expression<int>? number,
    Expression<String>? scoringTeamId,
    Expression<int>? points,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (matchId != null) 'match_id': matchId,
      if (number != null) 'number': number,
      if (scoringTeamId != null) 'scoring_team_id': scoringTeamId,
      if (points != null) 'points': points,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EndsCompanion copyWith({
    Value<String>? id,
    Value<String>? matchId,
    Value<int>? number,
    Value<String>? scoringTeamId,
    Value<int>? points,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EndsCompanion(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      number: number ?? this.number,
      scoringTeamId: scoringTeamId ?? this.scoringTeamId,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (matchId.present) {
      map['match_id'] = Variable<String>(matchId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (scoringTeamId.present) {
      map['scoring_team_id'] = Variable<String>(scoringTeamId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EndsCompanion(')
          ..write('id: $id, ')
          ..write('matchId: $matchId, ')
          ..write('number: $number, ')
          ..write('scoringTeamId: $scoringTeamId, ')
          ..write('points: $points, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepechagePlayoffsTable extends RepechagePlayoffs
    with TableInfo<$RepechagePlayoffsTable, RepechagePlayoffRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepechagePlayoffsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tournamentIdMeta = const VerificationMeta(
    'tournamentId',
  );
  @override
  late final GeneratedColumn<String> tournamentId = GeneratedColumn<String>(
    'tournament_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournaments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _teamIdsMeta = const VerificationMeta(
    'teamIds',
  );
  @override
  late final GeneratedColumn<String> teamIds = GeneratedColumn<String>(
    'team_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualificationSlotsMeta =
      const VerificationMeta('qualificationSlots');
  @override
  late final GeneratedColumn<int> qualificationSlots = GeneratedColumn<int>(
    'qualification_slots',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualifiedTeamIdsMeta = const VerificationMeta(
    'qualifiedTeamIds',
  );
  @override
  late final GeneratedColumn<String> qualifiedTeamIds = GeneratedColumn<String>(
    'qualified_team_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tournamentId,
    teamIds,
    qualificationSlots,
    qualifiedTeamIds,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repechage_playoffs';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepechagePlayoffRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tournament_id')) {
      context.handle(
        _tournamentIdMeta,
        tournamentId.isAcceptableOrUnknown(
          data['tournament_id']!,
          _tournamentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentIdMeta);
    }
    if (data.containsKey('team_ids')) {
      context.handle(
        _teamIdsMeta,
        teamIds.isAcceptableOrUnknown(data['team_ids']!, _teamIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdsMeta);
    }
    if (data.containsKey('qualification_slots')) {
      context.handle(
        _qualificationSlotsMeta,
        qualificationSlots.isAcceptableOrUnknown(
          data['qualification_slots']!,
          _qualificationSlotsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_qualificationSlotsMeta);
    }
    if (data.containsKey('qualified_team_ids')) {
      context.handle(
        _qualifiedTeamIdsMeta,
        qualifiedTeamIds.isAcceptableOrUnknown(
          data['qualified_team_ids']!,
          _qualifiedTeamIdsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepechagePlayoffRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepechagePlayoffRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tournamentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_id'],
      )!,
      teamIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_ids'],
      )!,
      qualificationSlots: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qualification_slots'],
      )!,
      qualifiedTeamIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qualified_team_ids'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $RepechagePlayoffsTable createAlias(String alias) {
    return $RepechagePlayoffsTable(attachedDatabase, alias);
  }
}

class RepechagePlayoffRow extends DataClass
    implements Insertable<RepechagePlayoffRow> {
  final String id;
  final String tournamentId;

  /// IDs séparés par des virgules.
  final String teamIds;
  final int qualificationSlots;

  /// Vide tant que le barrage n'est pas résolu.
  final String qualifiedTeamIds;
  final String status;
  const RepechagePlayoffRow({
    required this.id,
    required this.tournamentId,
    required this.teamIds,
    required this.qualificationSlots,
    required this.qualifiedTeamIds,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tournament_id'] = Variable<String>(tournamentId);
    map['team_ids'] = Variable<String>(teamIds);
    map['qualification_slots'] = Variable<int>(qualificationSlots);
    map['qualified_team_ids'] = Variable<String>(qualifiedTeamIds);
    map['status'] = Variable<String>(status);
    return map;
  }

  RepechagePlayoffsCompanion toCompanion(bool nullToAbsent) {
    return RepechagePlayoffsCompanion(
      id: Value(id),
      tournamentId: Value(tournamentId),
      teamIds: Value(teamIds),
      qualificationSlots: Value(qualificationSlots),
      qualifiedTeamIds: Value(qualifiedTeamIds),
      status: Value(status),
    );
  }

  factory RepechagePlayoffRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepechagePlayoffRow(
      id: serializer.fromJson<String>(json['id']),
      tournamentId: serializer.fromJson<String>(json['tournamentId']),
      teamIds: serializer.fromJson<String>(json['teamIds']),
      qualificationSlots: serializer.fromJson<int>(json['qualificationSlots']),
      qualifiedTeamIds: serializer.fromJson<String>(json['qualifiedTeamIds']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tournamentId': serializer.toJson<String>(tournamentId),
      'teamIds': serializer.toJson<String>(teamIds),
      'qualificationSlots': serializer.toJson<int>(qualificationSlots),
      'qualifiedTeamIds': serializer.toJson<String>(qualifiedTeamIds),
      'status': serializer.toJson<String>(status),
    };
  }

  RepechagePlayoffRow copyWith({
    String? id,
    String? tournamentId,
    String? teamIds,
    int? qualificationSlots,
    String? qualifiedTeamIds,
    String? status,
  }) => RepechagePlayoffRow(
    id: id ?? this.id,
    tournamentId: tournamentId ?? this.tournamentId,
    teamIds: teamIds ?? this.teamIds,
    qualificationSlots: qualificationSlots ?? this.qualificationSlots,
    qualifiedTeamIds: qualifiedTeamIds ?? this.qualifiedTeamIds,
    status: status ?? this.status,
  );
  RepechagePlayoffRow copyWithCompanion(RepechagePlayoffsCompanion data) {
    return RepechagePlayoffRow(
      id: data.id.present ? data.id.value : this.id,
      tournamentId: data.tournamentId.present
          ? data.tournamentId.value
          : this.tournamentId,
      teamIds: data.teamIds.present ? data.teamIds.value : this.teamIds,
      qualificationSlots: data.qualificationSlots.present
          ? data.qualificationSlots.value
          : this.qualificationSlots,
      qualifiedTeamIds: data.qualifiedTeamIds.present
          ? data.qualifiedTeamIds.value
          : this.qualifiedTeamIds,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepechagePlayoffRow(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('teamIds: $teamIds, ')
          ..write('qualificationSlots: $qualificationSlots, ')
          ..write('qualifiedTeamIds: $qualifiedTeamIds, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tournamentId,
    teamIds,
    qualificationSlots,
    qualifiedTeamIds,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepechagePlayoffRow &&
          other.id == this.id &&
          other.tournamentId == this.tournamentId &&
          other.teamIds == this.teamIds &&
          other.qualificationSlots == this.qualificationSlots &&
          other.qualifiedTeamIds == this.qualifiedTeamIds &&
          other.status == this.status);
}

class RepechagePlayoffsCompanion extends UpdateCompanion<RepechagePlayoffRow> {
  final Value<String> id;
  final Value<String> tournamentId;
  final Value<String> teamIds;
  final Value<int> qualificationSlots;
  final Value<String> qualifiedTeamIds;
  final Value<String> status;
  final Value<int> rowid;
  const RepechagePlayoffsCompanion({
    this.id = const Value.absent(),
    this.tournamentId = const Value.absent(),
    this.teamIds = const Value.absent(),
    this.qualificationSlots = const Value.absent(),
    this.qualifiedTeamIds = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepechagePlayoffsCompanion.insert({
    required String id,
    required String tournamentId,
    required String teamIds,
    required int qualificationSlots,
    this.qualifiedTeamIds = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tournamentId = Value(tournamentId),
       teamIds = Value(teamIds),
       qualificationSlots = Value(qualificationSlots);
  static Insertable<RepechagePlayoffRow> custom({
    Expression<String>? id,
    Expression<String>? tournamentId,
    Expression<String>? teamIds,
    Expression<int>? qualificationSlots,
    Expression<String>? qualifiedTeamIds,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tournamentId != null) 'tournament_id': tournamentId,
      if (teamIds != null) 'team_ids': teamIds,
      if (qualificationSlots != null) 'qualification_slots': qualificationSlots,
      if (qualifiedTeamIds != null) 'qualified_team_ids': qualifiedTeamIds,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepechagePlayoffsCompanion copyWith({
    Value<String>? id,
    Value<String>? tournamentId,
    Value<String>? teamIds,
    Value<int>? qualificationSlots,
    Value<String>? qualifiedTeamIds,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return RepechagePlayoffsCompanion(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      teamIds: teamIds ?? this.teamIds,
      qualificationSlots: qualificationSlots ?? this.qualificationSlots,
      qualifiedTeamIds: qualifiedTeamIds ?? this.qualifiedTeamIds,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tournamentId.present) {
      map['tournament_id'] = Variable<String>(tournamentId.value);
    }
    if (teamIds.present) {
      map['team_ids'] = Variable<String>(teamIds.value);
    }
    if (qualificationSlots.present) {
      map['qualification_slots'] = Variable<int>(qualificationSlots.value);
    }
    if (qualifiedTeamIds.present) {
      map['qualified_team_ids'] = Variable<String>(qualifiedTeamIds.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepechagePlayoffsCompanion(')
          ..write('id: $id, ')
          ..write('tournamentId: $tournamentId, ')
          ..write('teamIds: $teamIds, ')
          ..write('qualificationSlots: $qualificationSlots, ')
          ..write('qualifiedTeamIds: $qualifiedTeamIds, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TournamentsTable tournaments = $TournamentsTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $PetanqueBallsTable petanqueBalls = $PetanqueBallsTable(this);
  late final $TeamsTable teams = $TeamsTable(this);
  late final $TeamPlayersTable teamPlayers = $TeamPlayersTable(this);
  late final $MatchesTable matches = $MatchesTable(this);
  late final $EndsTable ends = $EndsTable(this);
  late final $RepechagePlayoffsTable repechagePlayoffs =
      $RepechagePlayoffsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tournaments,
    players,
    petanqueBalls,
    teams,
    teamPlayers,
    matches,
    ends,
    repechagePlayoffs,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournaments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('players', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'players',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('petanque_balls', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournaments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('teams', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'teams',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('team_players', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'players',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('team_players', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournaments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('matches', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'teams',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('matches', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'teams',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('matches', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'teams',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('matches', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'matches',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ends', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'teams',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ends', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournaments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('repechage_playoffs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$TournamentsTableCreateCompanionBuilder =
    TournamentsCompanion Function({
      required String id,
      required String name,
      required DateTime date,
      Value<String> location,
      required String format,
      required String teamCreationMode,
      Value<int> targetScore,
      Value<bool> allowFirstRoundRepechage,
      Value<int> firstRoundRepechageSlots,
      Value<String> repechageRule,
      Value<int> rowid,
    });
typedef $$TournamentsTableUpdateCompanionBuilder =
    TournamentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> date,
      Value<String> location,
      Value<String> format,
      Value<String> teamCreationMode,
      Value<int> targetScore,
      Value<bool> allowFirstRoundRepechage,
      Value<int> firstRoundRepechageSlots,
      Value<String> repechageRule,
      Value<int> rowid,
    });

final class $$TournamentsTableReferences
    extends BaseReferences<_$AppDatabase, $TournamentsTable, TournamentRow> {
  $$TournamentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlayersTable, List<PlayerRow>> _playersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.players,
    aliasName: 'tournaments__id__players__tournament_id',
  );

  $$PlayersTableProcessedTableManager get playersRefs {
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TeamsTable, List<TeamRow>> _teamsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.teams,
    aliasName: 'tournaments__id__teams__tournament_id',
  );

  $$TeamsTableProcessedTableManager get teamsRefs {
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MatchesTable, List<MatchRow>> _matchesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.matches,
    aliasName: 'tournaments__id__matches__tournament_id',
  );

  $$MatchesTableProcessedTableManager get matchesRefs {
    final manager = $$MatchesTableTableManager(
      $_db,
      $_db.matches,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RepechagePlayoffsTable, List<RepechagePlayoffRow>>
  _repechagePlayoffsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.repechagePlayoffs,
        aliasName: 'tournaments__id__repechage_playoffs__tournament_id',
      );

  $$RepechagePlayoffsTableProcessedTableManager get repechagePlayoffsRefs {
    final manager = $$RepechagePlayoffsTableTableManager(
      $_db,
      $_db.repechagePlayoffs,
    ).filter((f) => f.tournamentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _repechagePlayoffsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TournamentsTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentsTable> {
  $$TournamentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamCreationMode => $composableBuilder(
    column: $table.teamCreationMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetScore => $composableBuilder(
    column: $table.targetScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowFirstRoundRepechage => $composableBuilder(
    column: $table.allowFirstRoundRepechage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstRoundRepechageSlots => $composableBuilder(
    column: $table.firstRoundRepechageSlots,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repechageRule => $composableBuilder(
    column: $table.repechageRule,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playersRefs(
    Expression<bool> Function($$PlayersTableFilterComposer f) f,
  ) {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> teamsRefs(
    Expression<bool> Function($$TeamsTableFilterComposer f) f,
  ) {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> matchesRefs(
    Expression<bool> Function($$MatchesTableFilterComposer f) f,
  ) {
    final $$MatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableFilterComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> repechagePlayoffsRefs(
    Expression<bool> Function($$RepechagePlayoffsTableFilterComposer f) f,
  ) {
    final $$RepechagePlayoffsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repechagePlayoffs,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepechagePlayoffsTableFilterComposer(
            $db: $db,
            $table: $db.repechagePlayoffs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TournamentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentsTable> {
  $$TournamentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamCreationMode => $composableBuilder(
    column: $table.teamCreationMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetScore => $composableBuilder(
    column: $table.targetScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowFirstRoundRepechage => $composableBuilder(
    column: $table.allowFirstRoundRepechage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstRoundRepechageSlots => $composableBuilder(
    column: $table.firstRoundRepechageSlots,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repechageRule => $composableBuilder(
    column: $table.repechageRule,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TournamentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentsTable> {
  $$TournamentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get teamCreationMode => $composableBuilder(
    column: $table.teamCreationMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetScore => $composableBuilder(
    column: $table.targetScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allowFirstRoundRepechage => $composableBuilder(
    column: $table.allowFirstRoundRepechage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstRoundRepechageSlots => $composableBuilder(
    column: $table.firstRoundRepechageSlots,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repechageRule => $composableBuilder(
    column: $table.repechageRule,
    builder: (column) => column,
  );

  Expression<T> playersRefs<T extends Object>(
    Expression<T> Function($$PlayersTableAnnotationComposer a) f,
  ) {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> teamsRefs<T extends Object>(
    Expression<T> Function($$TeamsTableAnnotationComposer a) f,
  ) {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> matchesRefs<T extends Object>(
    Expression<T> Function($$MatchesTableAnnotationComposer a) f,
  ) {
    final $$MatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.tournamentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> repechagePlayoffsRefs<T extends Object>(
    Expression<T> Function($$RepechagePlayoffsTableAnnotationComposer a) f,
  ) {
    final $$RepechagePlayoffsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.repechagePlayoffs,
          getReferencedColumn: (t) => t.tournamentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RepechagePlayoffsTableAnnotationComposer(
                $db: $db,
                $table: $db.repechagePlayoffs,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TournamentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentsTable,
          TournamentRow,
          $$TournamentsTableFilterComposer,
          $$TournamentsTableOrderingComposer,
          $$TournamentsTableAnnotationComposer,
          $$TournamentsTableCreateCompanionBuilder,
          $$TournamentsTableUpdateCompanionBuilder,
          (TournamentRow, $$TournamentsTableReferences),
          TournamentRow,
          PrefetchHooks Function({
            bool playersRefs,
            bool teamsRefs,
            bool matchesRefs,
            bool repechagePlayoffsRefs,
          })
        > {
  $$TournamentsTableTableManager(_$AppDatabase db, $TournamentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TournamentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TournamentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String> teamCreationMode = const Value.absent(),
                Value<int> targetScore = const Value.absent(),
                Value<bool> allowFirstRoundRepechage = const Value.absent(),
                Value<int> firstRoundRepechageSlots = const Value.absent(),
                Value<String> repechageRule = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentsCompanion(
                id: id,
                name: name,
                date: date,
                location: location,
                format: format,
                teamCreationMode: teamCreationMode,
                targetScore: targetScore,
                allowFirstRoundRepechage: allowFirstRoundRepechage,
                firstRoundRepechageSlots: firstRoundRepechageSlots,
                repechageRule: repechageRule,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime date,
                Value<String> location = const Value.absent(),
                required String format,
                required String teamCreationMode,
                Value<int> targetScore = const Value.absent(),
                Value<bool> allowFirstRoundRepechage = const Value.absent(),
                Value<int> firstRoundRepechageSlots = const Value.absent(),
                Value<String> repechageRule = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentsCompanion.insert(
                id: id,
                name: name,
                date: date,
                location: location,
                format: format,
                teamCreationMode: teamCreationMode,
                targetScore: targetScore,
                allowFirstRoundRepechage: allowFirstRoundRepechage,
                firstRoundRepechageSlots: firstRoundRepechageSlots,
                repechageRule: repechageRule,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TournamentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                playersRefs = false,
                teamsRefs = false,
                matchesRefs = false,
                repechagePlayoffsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playersRefs) db.players,
                    if (teamsRefs) db.teams,
                    if (matchesRefs) db.matches,
                    if (repechagePlayoffsRefs) db.repechagePlayoffs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playersRefs)
                        await $_getPrefetchedData<
                          TournamentRow,
                          $TournamentsTable,
                          PlayerRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentsTableReferences
                              ._playersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentsTableReferences(
                                db,
                                table,
                                p0,
                              ).playersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (teamsRefs)
                        await $_getPrefetchedData<
                          TournamentRow,
                          $TournamentsTable,
                          TeamRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentsTableReferences
                              ._teamsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentsTableReferences(
                                db,
                                table,
                                p0,
                              ).teamsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchesRefs)
                        await $_getPrefetchedData<
                          TournamentRow,
                          $TournamentsTable,
                          MatchRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentsTableReferences
                              ._matchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentsTableReferences(
                                db,
                                table,
                                p0,
                              ).matchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (repechagePlayoffsRefs)
                        await $_getPrefetchedData<
                          TournamentRow,
                          $TournamentsTable,
                          RepechagePlayoffRow
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentsTableReferences
                              ._repechagePlayoffsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentsTableReferences(
                                db,
                                table,
                                p0,
                              ).repechagePlayoffsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tournamentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TournamentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentsTable,
      TournamentRow,
      $$TournamentsTableFilterComposer,
      $$TournamentsTableOrderingComposer,
      $$TournamentsTableAnnotationComposer,
      $$TournamentsTableCreateCompanionBuilder,
      $$TournamentsTableUpdateCompanionBuilder,
      (TournamentRow, $$TournamentsTableReferences),
      TournamentRow,
      PrefetchHooks Function({
        bool playersRefs,
        bool teamsRefs,
        bool matchesRefs,
        bool repechagePlayoffsRefs,
      })
    >;
typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      required String id,
      required String tournamentId,
      required String name,
      Value<int> rowid,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<String> id,
      Value<String> tournamentId,
      Value<String> name,
      Value<int> rowid,
    });

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, PlayerRow> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TournamentsTable _tournamentIdTable(_$AppDatabase db) =>
      db.tournaments.createAlias('players__tournament_id__tournaments__id');

  $$TournamentsTableProcessedTableManager get tournamentId {
    final $_column = $_itemColumn<String>('tournament_id')!;

    final manager = $$TournamentsTableTableManager(
      $_db,
      $_db.tournaments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tournamentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PetanqueBallsTable, List<PetanqueBallRow>>
  _petanqueBallsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.petanqueBalls,
    aliasName: 'players__id__petanque_balls__player_id',
  );

  $$PetanqueBallsTableProcessedTableManager get petanqueBallsRefs {
    final manager = $$PetanqueBallsTableTableManager(
      $_db,
      $_db.petanqueBalls,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_petanqueBallsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TeamPlayersTable, List<TeamPlayerRow>>
  _teamPlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.teamPlayers,
    aliasName: 'players__id__team_players__player_id',
  );

  $$TeamPlayersTableProcessedTableManager get teamPlayersRefs {
    final manager = $$TeamPlayersTableTableManager(
      $_db,
      $_db.teamPlayers,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamPlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentsTableFilterComposer get tournamentId {
    final $$TournamentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableFilterComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> petanqueBallsRefs(
    Expression<bool> Function($$PetanqueBallsTableFilterComposer f) f,
  ) {
    final $$PetanqueBallsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.petanqueBalls,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetanqueBallsTableFilterComposer(
            $db: $db,
            $table: $db.petanqueBalls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> teamPlayersRefs(
    Expression<bool> Function($$TeamPlayersTableFilterComposer f) f,
  ) {
    final $$TeamPlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamPlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamPlayersTableFilterComposer(
            $db: $db,
            $table: $db.teamPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentsTableOrderingComposer get tournamentId {
    final $$TournamentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableOrderingComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$TournamentsTableAnnotationComposer get tournamentId {
    final $$TournamentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableAnnotationComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> petanqueBallsRefs<T extends Object>(
    Expression<T> Function($$PetanqueBallsTableAnnotationComposer a) f,
  ) {
    final $$PetanqueBallsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.petanqueBalls,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetanqueBallsTableAnnotationComposer(
            $db: $db,
            $table: $db.petanqueBalls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> teamPlayersRefs<T extends Object>(
    Expression<T> Function($$TeamPlayersTableAnnotationComposer a) f,
  ) {
    final $$TeamPlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamPlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamPlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.teamPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          PlayerRow,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (PlayerRow, $$PlayersTableReferences),
          PlayerRow,
          PrefetchHooks Function({
            bool tournamentId,
            bool petanqueBallsRefs,
            bool teamPlayersRefs,
          })
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tournamentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                tournamentId: tournamentId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tournamentId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                tournamentId: tournamentId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tournamentId = false,
                petanqueBallsRefs = false,
                teamPlayersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (petanqueBallsRefs) db.petanqueBalls,
                    if (teamPlayersRefs) db.teamPlayers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (tournamentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tournamentId,
                                    referencedTable: $$PlayersTableReferences
                                        ._tournamentIdTable(db),
                                    referencedColumn: $$PlayersTableReferences
                                        ._tournamentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (petanqueBallsRefs)
                        await $_getPrefetchedData<
                          PlayerRow,
                          $PlayersTable,
                          PetanqueBallRow
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._petanqueBallsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).petanqueBallsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (teamPlayersRefs)
                        await $_getPrefetchedData<
                          PlayerRow,
                          $PlayersTable,
                          TeamPlayerRow
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._teamPlayersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).teamPlayersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      PlayerRow,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (PlayerRow, $$PlayersTableReferences),
      PlayerRow,
      PrefetchHooks Function({
        bool tournamentId,
        bool petanqueBallsRefs,
        bool teamPlayersRefs,
      })
    >;
typedef $$PetanqueBallsTableCreateCompanionBuilder =
    PetanqueBallsCompanion Function({
      required String id,
      required String playerId,
      Value<String?> brand,
      Value<String?> model,
      Value<int?> diameter,
      Value<int?> weight,
      Value<int> rowid,
    });
typedef $$PetanqueBallsTableUpdateCompanionBuilder =
    PetanqueBallsCompanion Function({
      Value<String> id,
      Value<String> playerId,
      Value<String?> brand,
      Value<String?> model,
      Value<int?> diameter,
      Value<int?> weight,
      Value<int> rowid,
    });

final class $$PetanqueBallsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PetanqueBallsTable, PetanqueBallRow> {
  $$PetanqueBallsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('petanque_balls__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<String>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PetanqueBallsTableFilterComposer
    extends Composer<_$AppDatabase, $PetanqueBallsTable> {
  $$PetanqueBallsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diameter => $composableBuilder(
    column: $table.diameter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PetanqueBallsTableOrderingComposer
    extends Composer<_$AppDatabase, $PetanqueBallsTable> {
  $$PetanqueBallsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diameter => $composableBuilder(
    column: $table.diameter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PetanqueBallsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetanqueBallsTable> {
  $$PetanqueBallsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get diameter =>
      $composableBuilder(column: $table.diameter, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PetanqueBallsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PetanqueBallsTable,
          PetanqueBallRow,
          $$PetanqueBallsTableFilterComposer,
          $$PetanqueBallsTableOrderingComposer,
          $$PetanqueBallsTableAnnotationComposer,
          $$PetanqueBallsTableCreateCompanionBuilder,
          $$PetanqueBallsTableUpdateCompanionBuilder,
          (PetanqueBallRow, $$PetanqueBallsTableReferences),
          PetanqueBallRow,
          PrefetchHooks Function({bool playerId})
        > {
  $$PetanqueBallsTableTableManager(_$AppDatabase db, $PetanqueBallsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetanqueBallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetanqueBallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetanqueBallsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int?> diameter = const Value.absent(),
                Value<int?> weight = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetanqueBallsCompanion(
                id: id,
                playerId: playerId,
                brand: brand,
                model: model,
                diameter: diameter,
                weight: weight,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String playerId,
                Value<String?> brand = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int?> diameter = const Value.absent(),
                Value<int?> weight = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PetanqueBallsCompanion.insert(
                id: id,
                playerId: playerId,
                brand: brand,
                model: model,
                diameter: diameter,
                weight: weight,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PetanqueBallsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (playerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playerId,
                                referencedTable: $$PetanqueBallsTableReferences
                                    ._playerIdTable(db),
                                referencedColumn: $$PetanqueBallsTableReferences
                                    ._playerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PetanqueBallsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PetanqueBallsTable,
      PetanqueBallRow,
      $$PetanqueBallsTableFilterComposer,
      $$PetanqueBallsTableOrderingComposer,
      $$PetanqueBallsTableAnnotationComposer,
      $$PetanqueBallsTableCreateCompanionBuilder,
      $$PetanqueBallsTableUpdateCompanionBuilder,
      (PetanqueBallRow, $$PetanqueBallsTableReferences),
      PetanqueBallRow,
      PrefetchHooks Function({bool playerId})
    >;
typedef $$TeamsTableCreateCompanionBuilder =
    TeamsCompanion Function({
      required String id,
      required String tournamentId,
      required String name,
      Value<int> rowid,
    });
typedef $$TeamsTableUpdateCompanionBuilder =
    TeamsCompanion Function({
      Value<String> id,
      Value<String> tournamentId,
      Value<String> name,
      Value<int> rowid,
    });

final class $$TeamsTableReferences
    extends BaseReferences<_$AppDatabase, $TeamsTable, TeamRow> {
  $$TeamsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TournamentsTable _tournamentIdTable(_$AppDatabase db) =>
      db.tournaments.createAlias('teams__tournament_id__tournaments__id');

  $$TournamentsTableProcessedTableManager get tournamentId {
    final $_column = $_itemColumn<String>('tournament_id')!;

    final manager = $$TournamentsTableTableManager(
      $_db,
      $_db.tournaments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tournamentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TeamPlayersTable, List<TeamPlayerRow>>
  _teamPlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.teamPlayers,
    aliasName: 'teams__id__team_players__team_id',
  );

  $$TeamPlayersTableProcessedTableManager get teamPlayersRefs {
    final manager = $$TeamPlayersTableTableManager(
      $_db,
      $_db.teamPlayers,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamPlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EndsTable, List<EndRow>> _endsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ends,
    aliasName: 'teams__id__ends__scoring_team_id',
  );

  $$EndsTableProcessedTableManager get endsRefs {
    final manager = $$EndsTableTableManager(
      $_db,
      $_db.ends,
    ).filter((f) => f.scoringTeamId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_endsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TeamsTableFilterComposer extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentsTableFilterComposer get tournamentId {
    final $$TournamentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableFilterComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> teamPlayersRefs(
    Expression<bool> Function($$TeamPlayersTableFilterComposer f) f,
  ) {
    final $$TeamPlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamPlayers,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamPlayersTableFilterComposer(
            $db: $db,
            $table: $db.teamPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> endsRefs(
    Expression<bool> Function($$EndsTableFilterComposer f) f,
  ) {
    final $$EndsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ends,
      getReferencedColumn: (t) => t.scoringTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EndsTableFilterComposer(
            $db: $db,
            $table: $db.ends,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentsTableOrderingComposer get tournamentId {
    final $$TournamentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableOrderingComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$TournamentsTableAnnotationComposer get tournamentId {
    final $$TournamentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableAnnotationComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> teamPlayersRefs<T extends Object>(
    Expression<T> Function($$TeamPlayersTableAnnotationComposer a) f,
  ) {
    final $$TeamPlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamPlayers,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamPlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.teamPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> endsRefs<T extends Object>(
    Expression<T> Function($$EndsTableAnnotationComposer a) f,
  ) {
    final $$EndsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ends,
      getReferencedColumn: (t) => t.scoringTeamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EndsTableAnnotationComposer(
            $db: $db,
            $table: $db.ends,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamsTable,
          TeamRow,
          $$TeamsTableFilterComposer,
          $$TeamsTableOrderingComposer,
          $$TeamsTableAnnotationComposer,
          $$TeamsTableCreateCompanionBuilder,
          $$TeamsTableUpdateCompanionBuilder,
          (TeamRow, $$TeamsTableReferences),
          TeamRow,
          PrefetchHooks Function({
            bool tournamentId,
            bool teamPlayersRefs,
            bool endsRefs,
          })
        > {
  $$TeamsTableTableManager(_$AppDatabase db, $TeamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tournamentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeamsCompanion(
                id: id,
                tournamentId: tournamentId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tournamentId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => TeamsCompanion.insert(
                id: id,
                tournamentId: tournamentId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TeamsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tournamentId = false,
                teamPlayersRefs = false,
                endsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (teamPlayersRefs) db.teamPlayers,
                    if (endsRefs) db.ends,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (tournamentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tournamentId,
                                    referencedTable: $$TeamsTableReferences
                                        ._tournamentIdTable(db),
                                    referencedColumn: $$TeamsTableReferences
                                        ._tournamentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (teamPlayersRefs)
                        await $_getPrefetchedData<
                          TeamRow,
                          $TeamsTable,
                          TeamPlayerRow
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._teamPlayersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).teamPlayersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (endsRefs)
                        await $_getPrefetchedData<TeamRow, $TeamsTable, EndRow>(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._endsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(db, table, p0).endsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.scoringTeamId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TeamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamsTable,
      TeamRow,
      $$TeamsTableFilterComposer,
      $$TeamsTableOrderingComposer,
      $$TeamsTableAnnotationComposer,
      $$TeamsTableCreateCompanionBuilder,
      $$TeamsTableUpdateCompanionBuilder,
      (TeamRow, $$TeamsTableReferences),
      TeamRow,
      PrefetchHooks Function({
        bool tournamentId,
        bool teamPlayersRefs,
        bool endsRefs,
      })
    >;
typedef $$TeamPlayersTableCreateCompanionBuilder =
    TeamPlayersCompanion Function({
      required String teamId,
      required String playerId,
      Value<int> rowid,
    });
typedef $$TeamPlayersTableUpdateCompanionBuilder =
    TeamPlayersCompanion Function({
      Value<String> teamId,
      Value<String> playerId,
      Value<int> rowid,
    });

final class $$TeamPlayersTableReferences
    extends BaseReferences<_$AppDatabase, $TeamPlayersTable, TeamPlayerRow> {
  $$TeamPlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('team_players__team_id__teams__id');

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<String>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('team_players__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<String>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TeamPlayersTableFilterComposer
    extends Composer<_$AppDatabase, $TeamPlayersTable> {
  $$TeamPlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamPlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamPlayersTable> {
  $$TeamPlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamPlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamPlayersTable> {
  $$TeamPlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamPlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamPlayersTable,
          TeamPlayerRow,
          $$TeamPlayersTableFilterComposer,
          $$TeamPlayersTableOrderingComposer,
          $$TeamPlayersTableAnnotationComposer,
          $$TeamPlayersTableCreateCompanionBuilder,
          $$TeamPlayersTableUpdateCompanionBuilder,
          (TeamPlayerRow, $$TeamPlayersTableReferences),
          TeamPlayerRow,
          PrefetchHooks Function({bool teamId, bool playerId})
        > {
  $$TeamPlayersTableTableManager(_$AppDatabase db, $TeamPlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamPlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamPlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamPlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> teamId = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeamPlayersCompanion(
                teamId: teamId,
                playerId: playerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String teamId,
                required String playerId,
                Value<int> rowid = const Value.absent(),
              }) => TeamPlayersCompanion.insert(
                teamId: teamId,
                playerId: playerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TeamPlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({teamId = false, playerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (teamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.teamId,
                                referencedTable: $$TeamPlayersTableReferences
                                    ._teamIdTable(db),
                                referencedColumn: $$TeamPlayersTableReferences
                                    ._teamIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (playerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playerId,
                                referencedTable: $$TeamPlayersTableReferences
                                    ._playerIdTable(db),
                                referencedColumn: $$TeamPlayersTableReferences
                                    ._playerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TeamPlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamPlayersTable,
      TeamPlayerRow,
      $$TeamPlayersTableFilterComposer,
      $$TeamPlayersTableOrderingComposer,
      $$TeamPlayersTableAnnotationComposer,
      $$TeamPlayersTableCreateCompanionBuilder,
      $$TeamPlayersTableUpdateCompanionBuilder,
      (TeamPlayerRow, $$TeamPlayersTableReferences),
      TeamPlayerRow,
      PrefetchHooks Function({bool teamId, bool playerId})
    >;
typedef $$MatchesTableCreateCompanionBuilder =
    MatchesCompanion Function({
      required String id,
      required String tournamentId,
      required int round,
      required int position,
      Value<String?> teamAId,
      Value<String?> teamBId,
      required int targetScore,
      Value<int> teamAScore,
      Value<int> teamBScore,
      Value<String> status,
      Value<String?> winnerTeamId,
      Value<String> type,
      Value<int> rowid,
    });
typedef $$MatchesTableUpdateCompanionBuilder =
    MatchesCompanion Function({
      Value<String> id,
      Value<String> tournamentId,
      Value<int> round,
      Value<int> position,
      Value<String?> teamAId,
      Value<String?> teamBId,
      Value<int> targetScore,
      Value<int> teamAScore,
      Value<int> teamBScore,
      Value<String> status,
      Value<String?> winnerTeamId,
      Value<String> type,
      Value<int> rowid,
    });

final class $$MatchesTableReferences
    extends BaseReferences<_$AppDatabase, $MatchesTable, MatchRow> {
  $$MatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TournamentsTable _tournamentIdTable(_$AppDatabase db) =>
      db.tournaments.createAlias('matches__tournament_id__tournaments__id');

  $$TournamentsTableProcessedTableManager get tournamentId {
    final $_column = $_itemColumn<String>('tournament_id')!;

    final manager = $$TournamentsTableTableManager(
      $_db,
      $_db.tournaments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tournamentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _teamAIdTable(_$AppDatabase db) =>
      db.teams.createAlias('matches__team_a_id__teams__id');

  $$TeamsTableProcessedTableManager? get teamAId {
    final $_column = $_itemColumn<String>('team_a_id');
    if ($_column == null) return null;
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamAIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _teamBIdTable(_$AppDatabase db) =>
      db.teams.createAlias('matches__team_b_id__teams__id');

  $$TeamsTableProcessedTableManager? get teamBId {
    final $_column = $_itemColumn<String>('team_b_id');
    if ($_column == null) return null;
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamBIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _winnerTeamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('matches__winner_team_id__teams__id');

  $$TeamsTableProcessedTableManager? get winnerTeamId {
    final $_column = $_itemColumn<String>('winner_team_id');
    if ($_column == null) return null;
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_winnerTeamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EndsTable, List<EndRow>> _endsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ends,
    aliasName: 'matches__id__ends__match_id',
  );

  $$EndsTableProcessedTableManager get endsRefs {
    final manager = $$EndsTableTableManager(
      $_db,
      $_db.ends,
    ).filter((f) => f.matchId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_endsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MatchesTableFilterComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetScore => $composableBuilder(
    column: $table.targetScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get teamAScore => $composableBuilder(
    column: $table.teamAScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get teamBScore => $composableBuilder(
    column: $table.teamBScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentsTableFilterComposer get tournamentId {
    final $$TournamentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableFilterComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get teamAId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamAId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get teamBId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamBId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get winnerTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.winnerTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> endsRefs(
    Expression<bool> Function($$EndsTableFilterComposer f) f,
  ) {
    final $$EndsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ends,
      getReferencedColumn: (t) => t.matchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EndsTableFilterComposer(
            $db: $db,
            $table: $db.ends,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetScore => $composableBuilder(
    column: $table.targetScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get teamAScore => $composableBuilder(
    column: $table.teamAScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get teamBScore => $composableBuilder(
    column: $table.teamBScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentsTableOrderingComposer get tournamentId {
    final $$TournamentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableOrderingComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get teamAId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamAId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get teamBId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamBId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get winnerTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.winnerTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get targetScore => $composableBuilder(
    column: $table.targetScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get teamAScore => $composableBuilder(
    column: $table.teamAScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get teamBScore => $composableBuilder(
    column: $table.teamBScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  $$TournamentsTableAnnotationComposer get tournamentId {
    final $$TournamentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableAnnotationComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get teamAId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamAId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get teamBId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamBId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get winnerTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.winnerTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> endsRefs<T extends Object>(
    Expression<T> Function($$EndsTableAnnotationComposer a) f,
  ) {
    final $$EndsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ends,
      getReferencedColumn: (t) => t.matchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EndsTableAnnotationComposer(
            $db: $db,
            $table: $db.ends,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchesTable,
          MatchRow,
          $$MatchesTableFilterComposer,
          $$MatchesTableOrderingComposer,
          $$MatchesTableAnnotationComposer,
          $$MatchesTableCreateCompanionBuilder,
          $$MatchesTableUpdateCompanionBuilder,
          (MatchRow, $$MatchesTableReferences),
          MatchRow,
          PrefetchHooks Function({
            bool tournamentId,
            bool teamAId,
            bool teamBId,
            bool winnerTeamId,
            bool endsRefs,
          })
        > {
  $$MatchesTableTableManager(_$AppDatabase db, $MatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tournamentId = const Value.absent(),
                Value<int> round = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> teamAId = const Value.absent(),
                Value<String?> teamBId = const Value.absent(),
                Value<int> targetScore = const Value.absent(),
                Value<int> teamAScore = const Value.absent(),
                Value<int> teamBScore = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> winnerTeamId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchesCompanion(
                id: id,
                tournamentId: tournamentId,
                round: round,
                position: position,
                teamAId: teamAId,
                teamBId: teamBId,
                targetScore: targetScore,
                teamAScore: teamAScore,
                teamBScore: teamBScore,
                status: status,
                winnerTeamId: winnerTeamId,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tournamentId,
                required int round,
                required int position,
                Value<String?> teamAId = const Value.absent(),
                Value<String?> teamBId = const Value.absent(),
                required int targetScore,
                Value<int> teamAScore = const Value.absent(),
                Value<int> teamBScore = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> winnerTeamId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchesCompanion.insert(
                id: id,
                tournamentId: tournamentId,
                round: round,
                position: position,
                teamAId: teamAId,
                teamBId: teamBId,
                targetScore: targetScore,
                teamAScore: teamAScore,
                teamBScore: teamBScore,
                status: status,
                winnerTeamId: winnerTeamId,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tournamentId = false,
                teamAId = false,
                teamBId = false,
                winnerTeamId = false,
                endsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (endsRefs) db.ends],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (tournamentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tournamentId,
                                    referencedTable: $$MatchesTableReferences
                                        ._tournamentIdTable(db),
                                    referencedColumn: $$MatchesTableReferences
                                        ._tournamentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (teamAId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.teamAId,
                                    referencedTable: $$MatchesTableReferences
                                        ._teamAIdTable(db),
                                    referencedColumn: $$MatchesTableReferences
                                        ._teamAIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (teamBId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.teamBId,
                                    referencedTable: $$MatchesTableReferences
                                        ._teamBIdTable(db),
                                    referencedColumn: $$MatchesTableReferences
                                        ._teamBIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (winnerTeamId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.winnerTeamId,
                                    referencedTable: $$MatchesTableReferences
                                        ._winnerTeamIdTable(db),
                                    referencedColumn: $$MatchesTableReferences
                                        ._winnerTeamIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (endsRefs)
                        await $_getPrefetchedData<
                          MatchRow,
                          $MatchesTable,
                          EndRow
                        >(
                          currentTable: table,
                          referencedTable: $$MatchesTableReferences
                              ._endsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MatchesTableReferences(db, table, p0).endsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.matchId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchesTable,
      MatchRow,
      $$MatchesTableFilterComposer,
      $$MatchesTableOrderingComposer,
      $$MatchesTableAnnotationComposer,
      $$MatchesTableCreateCompanionBuilder,
      $$MatchesTableUpdateCompanionBuilder,
      (MatchRow, $$MatchesTableReferences),
      MatchRow,
      PrefetchHooks Function({
        bool tournamentId,
        bool teamAId,
        bool teamBId,
        bool winnerTeamId,
        bool endsRefs,
      })
    >;
typedef $$EndsTableCreateCompanionBuilder =
    EndsCompanion Function({
      required String id,
      required String matchId,
      required int number,
      required String scoringTeamId,
      required int points,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$EndsTableUpdateCompanionBuilder =
    EndsCompanion Function({
      Value<String> id,
      Value<String> matchId,
      Value<int> number,
      Value<String> scoringTeamId,
      Value<int> points,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$EndsTableReferences
    extends BaseReferences<_$AppDatabase, $EndsTable, EndRow> {
  $$EndsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MatchesTable _matchIdTable(_$AppDatabase db) =>
      db.matches.createAlias('ends__match_id__matches__id');

  $$MatchesTableProcessedTableManager get matchId {
    final $_column = $_itemColumn<String>('match_id')!;

    final manager = $$MatchesTableTableManager(
      $_db,
      $_db.matches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_matchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _scoringTeamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('ends__scoring_team_id__teams__id');

  $$TeamsTableProcessedTableManager get scoringTeamId {
    final $_column = $_itemColumn<String>('scoring_team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scoringTeamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EndsTableFilterComposer extends Composer<_$AppDatabase, $EndsTable> {
  $$EndsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MatchesTableFilterComposer get matchId {
    final $$MatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchId,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableFilterComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get scoringTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scoringTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EndsTableOrderingComposer extends Composer<_$AppDatabase, $EndsTable> {
  $$EndsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MatchesTableOrderingComposer get matchId {
    final $$MatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchId,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableOrderingComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get scoringTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scoringTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EndsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EndsTable> {
  $$EndsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MatchesTableAnnotationComposer get matchId {
    final $$MatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.matchId,
      referencedTable: $db.matches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.matches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get scoringTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scoringTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EndsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EndsTable,
          EndRow,
          $$EndsTableFilterComposer,
          $$EndsTableOrderingComposer,
          $$EndsTableAnnotationComposer,
          $$EndsTableCreateCompanionBuilder,
          $$EndsTableUpdateCompanionBuilder,
          (EndRow, $$EndsTableReferences),
          EndRow,
          PrefetchHooks Function({bool matchId, bool scoringTeamId})
        > {
  $$EndsTableTableManager(_$AppDatabase db, $EndsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EndsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EndsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EndsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> matchId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> scoringTeamId = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EndsCompanion(
                id: id,
                matchId: matchId,
                number: number,
                scoringTeamId: scoringTeamId,
                points: points,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String matchId,
                required int number,
                required String scoringTeamId,
                required int points,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => EndsCompanion.insert(
                id: id,
                matchId: matchId,
                number: number,
                scoringTeamId: scoringTeamId,
                points: points,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$EndsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({matchId = false, scoringTeamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (matchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.matchId,
                                referencedTable: $$EndsTableReferences
                                    ._matchIdTable(db),
                                referencedColumn: $$EndsTableReferences
                                    ._matchIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (scoringTeamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.scoringTeamId,
                                referencedTable: $$EndsTableReferences
                                    ._scoringTeamIdTable(db),
                                referencedColumn: $$EndsTableReferences
                                    ._scoringTeamIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EndsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EndsTable,
      EndRow,
      $$EndsTableFilterComposer,
      $$EndsTableOrderingComposer,
      $$EndsTableAnnotationComposer,
      $$EndsTableCreateCompanionBuilder,
      $$EndsTableUpdateCompanionBuilder,
      (EndRow, $$EndsTableReferences),
      EndRow,
      PrefetchHooks Function({bool matchId, bool scoringTeamId})
    >;
typedef $$RepechagePlayoffsTableCreateCompanionBuilder =
    RepechagePlayoffsCompanion Function({
      required String id,
      required String tournamentId,
      required String teamIds,
      required int qualificationSlots,
      Value<String> qualifiedTeamIds,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$RepechagePlayoffsTableUpdateCompanionBuilder =
    RepechagePlayoffsCompanion Function({
      Value<String> id,
      Value<String> tournamentId,
      Value<String> teamIds,
      Value<int> qualificationSlots,
      Value<String> qualifiedTeamIds,
      Value<String> status,
      Value<int> rowid,
    });

final class $$RepechagePlayoffsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RepechagePlayoffsTable,
          RepechagePlayoffRow
        > {
  $$RepechagePlayoffsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentsTable _tournamentIdTable(_$AppDatabase db) => db
      .tournaments
      .createAlias('repechage_playoffs__tournament_id__tournaments__id');

  $$TournamentsTableProcessedTableManager get tournamentId {
    final $_column = $_itemColumn<String>('tournament_id')!;

    final manager = $$TournamentsTableTableManager(
      $_db,
      $_db.tournaments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tournamentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepechagePlayoffsTableFilterComposer
    extends Composer<_$AppDatabase, $RepechagePlayoffsTable> {
  $$RepechagePlayoffsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamIds => $composableBuilder(
    column: $table.teamIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qualificationSlots => $composableBuilder(
    column: $table.qualificationSlots,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qualifiedTeamIds => $composableBuilder(
    column: $table.qualifiedTeamIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentsTableFilterComposer get tournamentId {
    final $$TournamentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableFilterComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepechagePlayoffsTableOrderingComposer
    extends Composer<_$AppDatabase, $RepechagePlayoffsTable> {
  $$RepechagePlayoffsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamIds => $composableBuilder(
    column: $table.teamIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qualificationSlots => $composableBuilder(
    column: $table.qualificationSlots,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualifiedTeamIds => $composableBuilder(
    column: $table.qualifiedTeamIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentsTableOrderingComposer get tournamentId {
    final $$TournamentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableOrderingComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepechagePlayoffsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepechagePlayoffsTable> {
  $$RepechagePlayoffsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get teamIds =>
      $composableBuilder(column: $table.teamIds, builder: (column) => column);

  GeneratedColumn<int> get qualificationSlots => $composableBuilder(
    column: $table.qualificationSlots,
    builder: (column) => column,
  );

  GeneratedColumn<String> get qualifiedTeamIds => $composableBuilder(
    column: $table.qualifiedTeamIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$TournamentsTableAnnotationComposer get tournamentId {
    final $$TournamentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tournamentId,
      referencedTable: $db.tournaments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentsTableAnnotationComposer(
            $db: $db,
            $table: $db.tournaments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepechagePlayoffsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepechagePlayoffsTable,
          RepechagePlayoffRow,
          $$RepechagePlayoffsTableFilterComposer,
          $$RepechagePlayoffsTableOrderingComposer,
          $$RepechagePlayoffsTableAnnotationComposer,
          $$RepechagePlayoffsTableCreateCompanionBuilder,
          $$RepechagePlayoffsTableUpdateCompanionBuilder,
          (RepechagePlayoffRow, $$RepechagePlayoffsTableReferences),
          RepechagePlayoffRow,
          PrefetchHooks Function({bool tournamentId})
        > {
  $$RepechagePlayoffsTableTableManager(
    _$AppDatabase db,
    $RepechagePlayoffsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepechagePlayoffsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepechagePlayoffsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepechagePlayoffsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tournamentId = const Value.absent(),
                Value<String> teamIds = const Value.absent(),
                Value<int> qualificationSlots = const Value.absent(),
                Value<String> qualifiedTeamIds = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepechagePlayoffsCompanion(
                id: id,
                tournamentId: tournamentId,
                teamIds: teamIds,
                qualificationSlots: qualificationSlots,
                qualifiedTeamIds: qualifiedTeamIds,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tournamentId,
                required String teamIds,
                required int qualificationSlots,
                Value<String> qualifiedTeamIds = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepechagePlayoffsCompanion.insert(
                id: id,
                tournamentId: tournamentId,
                teamIds: teamIds,
                qualificationSlots: qualificationSlots,
                qualifiedTeamIds: qualifiedTeamIds,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RepechagePlayoffsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tournamentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tournamentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tournamentId,
                                referencedTable:
                                    $$RepechagePlayoffsTableReferences
                                        ._tournamentIdTable(db),
                                referencedColumn:
                                    $$RepechagePlayoffsTableReferences
                                        ._tournamentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RepechagePlayoffsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepechagePlayoffsTable,
      RepechagePlayoffRow,
      $$RepechagePlayoffsTableFilterComposer,
      $$RepechagePlayoffsTableOrderingComposer,
      $$RepechagePlayoffsTableAnnotationComposer,
      $$RepechagePlayoffsTableCreateCompanionBuilder,
      $$RepechagePlayoffsTableUpdateCompanionBuilder,
      (RepechagePlayoffRow, $$RepechagePlayoffsTableReferences),
      RepechagePlayoffRow,
      PrefetchHooks Function({bool tournamentId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TournamentsTableTableManager get tournaments =>
      $$TournamentsTableTableManager(_db, _db.tournaments);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$PetanqueBallsTableTableManager get petanqueBalls =>
      $$PetanqueBallsTableTableManager(_db, _db.petanqueBalls);
  $$TeamsTableTableManager get teams =>
      $$TeamsTableTableManager(_db, _db.teams);
  $$TeamPlayersTableTableManager get teamPlayers =>
      $$TeamPlayersTableTableManager(_db, _db.teamPlayers);
  $$MatchesTableTableManager get matches =>
      $$MatchesTableTableManager(_db, _db.matches);
  $$EndsTableTableManager get ends => $$EndsTableTableManager(_db, _db.ends);
  $$RepechagePlayoffsTableTableManager get repechagePlayoffs =>
      $$RepechagePlayoffsTableTableManager(_db, _db.repechagePlayoffs);
}
