import 'package:uuid/uuid.dart';

import '../../../domain/match.dart';
import '../../../domain/team.dart';
import '../../../domain/tournament.dart';

class BracketGenerator {
  const BracketGenerator();

  List<Match> generateFirstRound({
    required Tournament tournament,
    required List<Team> teams,
  }) {
    if (teams.length < 2) {
      throw ArgumentError(
        'Au moins deux équipes sont nécessaires.',
      );
    }

    final shuffledTeams = List<Team>.from(teams)..shuffle();

    final bracketSize = _nextPowerOfTwo(
      shuffledTeams.length,
    );

    final numberOfByes =
        bracketSize - shuffledTeams.length;

    final matches = <Match>[];

    var teamIndex = 0;
    var position = 0;

    // Les premières équipes bénéficient d'une exemption.
    for (var i = 0; i < numberOfByes; i++) {
      final team = shuffledTeams[teamIndex++];

      matches.add(
        Match(
          id: const Uuid().v4(),
          tournamentId: tournament.id,
          round: 1,
          position: position++,
          teamAId: team.id,
          teamBId: null,
          targetScore: tournament.rules.targetScore,
          status: MatchStatus.finished,
          winnerTeamId: team.id,
        ),
      );
    }

    while (teamIndex < shuffledTeams.length) {
      final teamA = shuffledTeams[teamIndex++];
      final teamB = shuffledTeams[teamIndex++];

      matches.add(
        Match(
          id: const Uuid().v4(),
          tournamentId: tournament.id,
          round: 1,
          position: position++,
          teamAId: teamA.id,
          teamBId: teamB.id,
          targetScore: tournament.rules.targetScore,
        ),
      );
    }

    return matches;
  }

  int _nextPowerOfTwo(int value) {
    var result = 1;

    while (result < value) {
      result *= 2;
    }

    return result;
  }
}