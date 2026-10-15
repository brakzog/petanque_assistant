import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/domain/end.dart';
import 'package:tournoi_de_petanque/domain/match.dart';
import 'package:tournoi_de_petanque/domain/tournament.dart';
import 'package:tournoi_de_petanque/features/tournaments/domain/match_scorer.dart';

void main() {
  const scorer = MatchScorer();

  const match = Match(
    id: 'm1',
    tournamentId: 't1',
    round: 1,
    position: 0,
    teamAId: 'a',
    teamBId: 'b',
    targetScore: 13,
  );

  End endFor(String teamId, int points) => End(
    id: 'e',
    matchId: 'm1',
    number: 1,
    scoringTeamId: teamId,
    points: points,
    createdAt: DateTime(2026),
  );

  group('maxPointsPerEnd', () {
    test('is 3 in singles and 6 otherwise', () {
      expect(scorer.maxPointsPerEnd(PetanqueFormat.singles), 3);
      expect(scorer.maxPointsPerEnd(PetanqueFormat.doubles), 6);
      expect(scorer.maxPointsPerEnd(PetanqueFormat.triples), 6);
    });
  });

  group('applyEnd', () {
    test('adds points to the scoring team and starts the match', () {
      final result = scorer.applyEnd(match, teamId: 'b', points: 4);

      expect(result.teamAScore, 0);
      expect(result.teamBScore, 4);
      expect(result.status, MatchStatus.inProgress);
      expect(result.winnerTeamId, isNull);
    });

    test('finishes the match when the target is reached', () {
      final result = scorer.applyEnd(
        match.copyWith(teamAScore: 11),
        teamId: 'a',
        points: 2,
      );

      expect(result.teamAScore, 13);
      expect(result.status, MatchStatus.finished);
      expect(result.winnerTeamId, 'a');
    });
  });

  group('revertEnd', () {
    test('removes points and clears the winner', () {
      final finished = match.copyWith(
        teamAScore: 13,
        teamBScore: 5,
        status: MatchStatus.finished,
        winnerTeamId: 'a',
      );

      final result = scorer.revertEnd(
        finished,
        endFor('a', 3),
        remainingEnds: 4,
      );

      expect(result.teamAScore, 10);
      expect(result.teamBScore, 5);
      expect(result.status, MatchStatus.inProgress);
      expect(result.winnerTeamId, isNull);
    });

    test('goes back to pending when no end is left', () {
      final result = scorer.revertEnd(
        match.copyWith(teamBScore: 2, status: MatchStatus.inProgress),
        endFor('b', 2),
        remainingEnds: 0,
      );

      expect(result.teamBScore, 0);
      expect(result.status, MatchStatus.pending);
    });
  });
}
