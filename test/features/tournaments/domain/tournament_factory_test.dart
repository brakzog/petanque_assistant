import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/domain/tournament.dart';
import 'package:tournoi_de_petanque/features/tournaments/domain/tournament_factory.dart';
import 'package:tournoi_de_petanque/features/tournaments/presentation/tournament_form_validators.dart';

void main() {
  const tournamentFactory = TournamentFactory(newId: _fixedId);

  Tournament create({int? repechageSlots}) => tournamentFactory.create(
    name: '  Open  ',
    location: ' Nice ',
    date: DateTime(2026, 7, 14),
    format: PetanqueFormat.triples,
    teamCreationMode: TeamCreationMode.predefined,
    targetScore: 11,
    repechageSlots: repechageSlots,
  );

  test('trims texts and uses the injected id', () {
    final tournament = create();

    expect(tournament.id, 'id');
    expect(tournament.name, 'Open');
    expect(tournament.location, 'Nice');
    expect(tournament.rules.targetScore, 11);
  });

  test('enables repechage only when slots are given', () {
    expect(create().rules.allowFirstRoundRepechage, isFalse);
    expect(create().rules.firstRoundRepechageSlots, 0);

    final withRepechage = create(repechageSlots: 3);
    expect(withRepechage.rules.allowFirstRoundRepechage, isTrue);
    expect(withRepechage.rules.firstRoundRepechageSlots, 3);
  });

  group('validators', () {
    test('reject empty names and non-positive numbers', () {
      expect(TournamentFormValidators.name('  '), isNotNull);
      expect(TournamentFormValidators.name('Open'), isNull);
      expect(TournamentFormValidators.targetScore('0'), isNotNull);
      expect(TournamentFormValidators.targetScore('abc'), isNotNull);
      expect(TournamentFormValidators.targetScore('13'), isNull);
      expect(TournamentFormValidators.repechageSlots('-1'), isNotNull);
      expect(TournamentFormValidators.repechageSlots('2'), isNull);
    });

    test('formats dates as dd/mm/yyyy', () {
      expect(formatDate(DateTime(2026, 3, 5)), '05/03/2026');
    });
  });
}

String _fixedId() => 'id';
