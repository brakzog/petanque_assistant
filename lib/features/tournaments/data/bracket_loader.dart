import '../../../domain/tournament.dart';
import '../../../domain/tournament_progression_result.dart';
import '../domain/bracket_view.dart';
import 'bracket_generator.dart';
import 'match_repository.dart';
import 'repechage_playoff_repository.dart';
import 'team_repository.dart';
import 'tournament_progression_service.dart';

/// Loads a bracket, creating the first round on first opening and advancing
/// the tournament when a round is complete.
class BracketLoader {
  const BracketLoader({
    required this.teamRepository,
    required this.matchRepository,
    required this.playoffRepository,
    required this.progressionService,
    required this.bracketGenerator,
  });

  final TeamRepository teamRepository;
  final MatchRepository matchRepository;
  final RepechagePlayoffRepository playoffRepository;
  final TournamentProgressionService progressionService;
  final BracketGenerator bracketGenerator;

  Future<BracketView> load(Tournament tournament) async {
    final teams = await teamRepository.getTeamsForTournament(tournament.id);
    var matches = await matchRepository.getMatchesForTournament(tournament.id);

    TournamentProgressionResult? progression;
    if (matches.isEmpty) {
      matches = bracketGenerator.generateFirstRound(
        tournament: tournament,
        teams: teams,
      );
      await matchRepository.saveMatches(matches);
    } else {
      progression = await progressionService.progressIfPossible(tournament);
      matches = await matchRepository.getMatchesForTournament(tournament.id);
    }

    final playoff = await playoffRepository.getForTournament(tournament.id);

    return BracketView(
      teams: teams,
      matches: matches,
      playoff: playoff,
      progression: progression,
    );
  }
}
