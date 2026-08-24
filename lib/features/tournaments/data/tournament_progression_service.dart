import 'package:uuid/uuid.dart';

import '../../../domain/match.dart';
import '../../../domain/repechage_playoff.dart';
import '../../../domain/tournament.dart';
import '../../../domain/tournament_progression_result.dart';
import 'match_repository.dart';
import 'repechage_playoff_repository.dart';
import 'repechage_service.dart';

class TournamentProgressionService {
  final MatchRepository matchRepository;
  final RepechagePlayoffRepository playoffRepository;
  final RepechageService repechageService;

  const TournamentProgressionService({
    required this.matchRepository,
    required this.playoffRepository,
    this.repechageService = const RepechageService(),
  });

  Future<TournamentProgressionResult> progressIfPossible(
      Tournament tournament,
      ) async {
    final allMatches =
    await matchRepository.getMatchesForTournament(
      tournament.id,
    );

    if (allMatches.isEmpty) {
      return const TournamentProgressionResult(
        state: TournamentProgressionState.waiting,
      );
    }

    final currentRound = allMatches
        .map((match) => match.round)
        .reduce((a, b) => a > b ? a : b);

    final currentRoundMatches = allMatches
        .where(
          (match) =>
      match.round == currentRound &&
          match.type == MatchType.tournament,
    )
        .toList()
      ..sort(
            (a, b) => a.position.compareTo(b.position),
      );

    if (currentRoundMatches.isEmpty) {
      return const TournamentProgressionResult(
        state: TournamentProgressionState.waiting,
      );
    }

    final roundFinished = currentRoundMatches.every(
          (match) =>
      match.status == MatchStatus.finished &&
          match.winnerTeamId != null,
    );

    if (!roundFinished) {
      return const TournamentProgressionResult(
        state: TournamentProgressionState.waiting,
      );
    }

    final winners = currentRoundMatches
        .map((match) => match.winnerTeamId!)
        .toList();

    if (currentRound == 1 &&
        tournament.rules.allowFirstRoundRepechage &&
        tournament.rules.firstRoundRepechageSlots > 0) {
      final repechage = repechageService.calculate(
        firstRoundMatches: currentRoundMatches,
        numberOfRepechageSlots:
        tournament.rules.firstRoundRepechageSlots,
      );

      if (repechage.requiresPlayoff) {
        var playoff = await playoffRepository.getForTournament(
          tournament.id,
        );

        if (playoff == null) {
          playoff = RepechagePlayoff(
            id: const Uuid().v4(),
            tournamentId: tournament.id,
            teamIds: repechage.playoffTeamIds,
            qualificationSlots:
            repechage.playoffQualificationSlots,
          );

          await playoffRepository.save(playoff);
        }

        if (!playoff.isResolved) {
          return TournamentProgressionResult(
            state: TournamentProgressionState.playoffRequired,
            playoffTeamIds: playoff.teamIds,
            playoffQualificationSlots:
            playoff.qualificationSlots,
          );
        }

        winners.addAll(
          repechage.qualifiedTeamIds,
        );

        winners.addAll(
          playoff.qualifiedTeamIds,
        );
      } else {
        winners.addAll(
          repechage.qualifiedTeamIds,
        );
      }
    }

    if (winners.length == 1) {
      return const TournamentProgressionResult(
        state: TournamentProgressionState.finished,
      );
    }

    final nextRound = currentRound + 1;

    final nextRoundAlreadyExists = allMatches.any(
          (match) =>
      match.round == nextRound &&
          match.type == MatchType.tournament,
    );

    if (nextRoundAlreadyExists) {
      return const TournamentProgressionResult(
        state: TournamentProgressionState.waiting,
      );
    }

    final nextMatches = <Match>[];

    var position = 0;

    for (var index = 0; index < winners.length; index += 2) {
      final teamAId = winners[index];

      final String? teamBId =
      index + 1 < winners.length
          ? winners[index + 1]
          : null;

      final isBye = teamBId == null;

      nextMatches.add(
        Match(
          id: const Uuid().v4(),
          tournamentId: tournament.id,
          round: nextRound,
          position: position++,
          teamAId: teamAId,
          teamBId: teamBId,
          targetScore: tournament.rules.targetScore,
          type: MatchType.tournament,
          status: isBye
              ? MatchStatus.finished
              : MatchStatus.pending,
          winnerTeamId: isBye ? teamAId : null,
        ),
      );
    }

    await matchRepository.saveMatches(nextMatches);

    return const TournamentProgressionResult(
      state: TournamentProgressionState.progressed,
    );
  }
}