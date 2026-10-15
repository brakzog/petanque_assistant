import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/domain/match.dart';
import 'package:tournoi_de_petanque/domain/team.dart';
import 'package:tournoi_de_petanque/domain/tournament_progression_result.dart';
import 'package:tournoi_de_petanque/features/tournaments/domain/bracket_view.dart';

Match match(
  int round,
  int position, {
  String? a = 'a',
  String? b = 'b',
  MatchStatus status = MatchStatus.pending,
  String? winner,
  MatchType type = MatchType.tournament,
}) {
  return Match(
    id: 'm$round$position',
    tournamentId: 't',
    round: round,
    position: position,
    teamAId: a,
    teamBId: b,
    targetScore: 13,
    status: status,
    winnerTeamId: winner,
    type: type,
  );
}

const teams = [
  Team(id: 'a', tournamentId: 't', name: 'Alpha'),
  Team(id: 'b', tournamentId: 't', name: 'Bravo'),
];

BracketView view(
  List<Match> matches, {
  TournamentProgressionResult? progression,
}) {
  return BracketView(
    teams: teams,
    matches: matches,
    playoff: null,
    progression: progression,
  );
}

void main() {
  test('lists rounds and sorts matches by position, ignoring playoffs', () {
    final bracket = view([
      match(1, 1),
      match(1, 0),
      match(2, 0),
      match(3, 0, type: MatchType.repechagePlayoff),
    ]);

    expect(bracket.rounds, [1, 2]);
    expect(bracket.matchesOfRound(1).map((m) => m.position), [0, 1]);
  });

  test('names the last rounds', () {
    final bracket = view([match(1, 0), match(2, 0), match(3, 0), match(4, 0)]);

    expect(bracket.roundLabel(4), 'Finale');
    expect(bracket.roundLabel(3), 'Demi-finales');
    expect(bracket.roundLabel(2), 'Quarts de finale');
    expect(bracket.roundLabel(1), 'Tour 1');
  });

  test('is finished once the final has a winner', () {
    final ongoing = view([match(1, 0), match(1, 1), match(2, 0)]);
    final finished = view([
      match(1, 0),
      match(1, 1),
      match(2, 0, status: MatchStatus.finished, winner: 'b'),
    ]);

    expect(ongoing.isFinished, isFalse);
    expect(ongoing.winner, isNull);
    expect(finished.isFinished, isTrue);
    expect(finished.winner?.name, 'Bravo');
  });

  test('has no final while the last round has several matches', () {
    expect(view([match(1, 0), match(1, 1)]).finalMatch, isNull);
  });

  test('requires a playoff only when the tournament is not finished', () {
    const playoff = TournamentProgressionResult(
      state: TournamentProgressionState.playoffRequired,
    );

    expect(view([match(1, 0)], progression: playoff).playoffRequired, isTrue);
    expect(
      view([
        match(1, 0, status: MatchStatus.finished, winner: 'a'),
      ], progression: playoff).playoffRequired,
      isFalse,
    );
  });

  test('labels unknown teams with a dash', () {
    final bracket = view([match(1, 0)]);

    expect(bracket.teamLabel('a'), 'Alpha');
    expect(bracket.teamLabel(null), '—');
    expect(bracket.playersLabel('zzz'), '');
  });
}
