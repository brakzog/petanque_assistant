import 'tournament_rules.dart';

enum PetanqueFormat {
  singles,
  doubles,
  triples,
}

enum TeamCreationMode {
  random,
  predefined,
}

class Tournament {
  final String id;
  final String name;
  final DateTime date;
  final String location;

  final PetanqueFormat format;
  final TeamCreationMode teamCreationMode;
  final TournamentRules rules;

  const Tournament({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.format,
    required this.teamCreationMode,
    required this.rules,
  });

  Tournament copyWith({
    String? id,
    String? name,
    DateTime? date,
    String? location,
    PetanqueFormat? format,
    TeamCreationMode? teamCreationMode,
    TournamentRules? rules,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      location: location ?? this.location,
      format: format ?? this.format,
      teamCreationMode: teamCreationMode ?? this.teamCreationMode,
      rules: rules ?? this.rules,
    );
  }
}