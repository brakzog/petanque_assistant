import '../../../domain/tournament.dart';

extension PetanqueFormatLabel on PetanqueFormat {
  String get label => switch (this) {
    PetanqueFormat.singles => 'Tête-à-tête',
    PetanqueFormat.doubles => 'Doublette',
    PetanqueFormat.triples => 'Triplette',
  };
}
