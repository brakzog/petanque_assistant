import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/domain/tournament.dart';
import 'package:tournoi_de_petanque/domain/tournament_rules.dart';
import 'package:tournoi_de_petanque/features/tournaments/domain/roster_status.dart';

Tournament tournament({
  PetanqueFormat format = PetanqueFormat.doubles,
  TeamCreationMode mode = TeamCreationMode.random,
}) {
  return Tournament(
    id: 't',
    name: 'Test',
    date: DateTime(2026),
    location: '',
    format: format,
    teamCreationMode: mode,
    rules: const TournamentRules(),
  );
}

void main() {
  test('counts complete teams and leftover players', () {
    final status = RosterStatus(
      tournament: tournament(format: PetanqueFormat.triples),
      playerCount: 7,
      teamCount: 0,
    );

    expect(status.completeTeams, 2);
    expect(status.remainingPlayers, 1);
    expect(status.canGenerateTeams, isFalse);
  });

  test('allows a random draw only with complete teams and no teams yet', () {
    expect(
      RosterStatus(
        tournament: tournament(),
        playerCount: 4,
        teamCount: 0,
      ).canGenerateTeams,
      isTrue,
    );
    expect(
      RosterStatus(
        tournament: tournament(),
        playerCount: 4,
        teamCount: 2,
      ).canGenerateTeams,
      isFalse,
    );
    expect(
      RosterStatus(
        tournament: tournament(),
        playerCount: 0,
        teamCount: 0,
      ).canGenerateTeams,
      isFalse,
    );
  });

  test('never draws for predefined teams', () {
    final status = RosterStatus(
      tournament: tournament(mode: TeamCreationMode.predefined),
      playerCount: 4,
      teamCount: 0,
    );

    expect(status.usesRandomTeams, isFalse);
    expect(status.canGenerateTeams, isFalse);
  });
}
