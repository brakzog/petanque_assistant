import 'tournament.dart';

extension PetanqueFormatRules on PetanqueFormat {
  int get playersPerTeam => switch (this) {
    PetanqueFormat.singles => 1,
    PetanqueFormat.doubles => 2,
    PetanqueFormat.triples => 3,
  };
}
