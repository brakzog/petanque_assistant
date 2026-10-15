import '../../../domain/match.dart';
import '../../../domain/repechage_playoff.dart';
import '../../../domain/team.dart';
import '../../../domain/tournament_progression_result.dart';

/// Read model of a tournament bracket: rounds, labels, final and winner.
class BracketView {
  BracketView({
    required this.teams,
    required List<Match> matches,
    required this.playoff,
    required this.progression,
  }) : tournamentMatches = matches
           .where((match) => match.type == MatchType.tournament)
           .toList();

  final List<Team> teams;
  final List<Match> tournamentMatches;
  final RepechagePlayoff? playoff;
  final TournamentProgressionResult? progression;

  /// Sorted round numbers.
  List<int> get rounds =>
      tournamentMatches.map((match) => match.round).toSet().toList()..sort();

  List<Match> matchesOfRound(int round) {
    return tournamentMatches.where((match) => match.round == round).toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  bool get playoffRequired =>
      !isFinished &&
      progression?.state == TournamentProgressionState.playoffRequired;

  /// The only match of the last round, if the last round is a final.
  Match? get finalMatch {
    if (tournamentMatches.isEmpty) return null;
    final lastRound = matchesOfRound(rounds.last);
    return lastRound.length == 1 ? lastRound.first : null;
  }

  bool get isFinished {
    if (progression?.state == TournamentProgressionState.finished) {
      return true;
    }
    final last = finalMatch;
    return last != null &&
        last.status == MatchStatus.finished &&
        last.winnerTeamId != null;
  }

  Team? get winner => isFinished ? findTeam(finalMatch?.winnerTeamId) : null;

  Team? findTeam(String? teamId) {
    if (teamId == null) return null;
    for (final team in teams) {
      if (team.id == teamId) return team;
    }
    return null;
  }

  String teamLabel(String? teamId) => findTeam(teamId)?.name ?? '—';

  String playersLabel(String? teamId) {
    final team = findTeam(teamId);
    if (team == null) return '';
    return team.players.map((player) => player.name).join(' + ');
  }

  String roundLabel(int round) {
    final totalRounds = rounds.length;
    if (round == totalRounds && totalRounds > 1) return 'Finale';
    if (round == totalRounds - 1 && totalRounds > 2) return 'Demi-finales';
    if (round == totalRounds - 2 && totalRounds > 3) return 'Quarts de finale';
    return 'Tour $round';
  }
}
