import '../../../domain/tournament.dart';
import '../../../domain/tournament_rules.dart';

/// Creates a new tournament from the creation form values.
class TournamentFactory {
  const TournamentFactory({required this.newId});

  final String Function() newId;

  /// [repechageSlots] null means no first-round repechage.
  Tournament create({
    required String name,
    required String location,
    required DateTime date,
    required PetanqueFormat format,
    required TeamCreationMode teamCreationMode,
    required int targetScore,
    int? repechageSlots,
  }) {
    return Tournament(
      id: newId(),
      name: name.trim(),
      date: date,
      location: location.trim(),
      format: format,
      teamCreationMode: teamCreationMode,
      rules: TournamentRules(
        targetScore: targetScore,
        allowFirstRoundRepechage: repechageSlots != null,
        firstRoundRepechageSlots: repechageSlots ?? 0,
        repechageRule: RepechageRule.bestScore,
      ),
    );
  }
}
