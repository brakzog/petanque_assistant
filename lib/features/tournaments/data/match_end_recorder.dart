import '../../../core/database/transaction_runner.dart';
import '../../../domain/end.dart';
import '../../../domain/match.dart';
import '../domain/match_scorer.dart';
import 'end_repository.dart';
import 'match_repository.dart';

/// Persists ends and the resulting match score atomically.
class MatchEndRecorder {
  const MatchEndRecorder({
    required this.transactions,
    required this.matchRepository,
    required this.endRepository,
    required this.scorer,
    required this.newId,
    required this.now,
  });

  final TransactionRunner transactions;
  final MatchRepository matchRepository;
  final EndRepository endRepository;
  final MatchScorer scorer;
  final String Function() newId;
  final DateTime Function() now;

  Future<void> recordEnd(
    Match match,
    List<End> ends, {
    required String teamId,
    required int points,
  }) {
    final end = End(
      id: newId(),
      matchId: match.id,
      number: ends.length + 1,
      scoringTeamId: teamId,
      points: points,
      createdAt: now(),
    );
    final updatedMatch = scorer.applyEnd(match, teamId: teamId, points: points);

    return transactions.run(() async {
      await endRepository.saveEnd(end);
      await matchRepository.saveMatch(updatedMatch);
    });
  }

  Future<void> undoLastEnd(Match match, List<End> ends) async {
    if (ends.isEmpty) return;

    final lastEnd = ends.last;
    final updatedMatch = scorer.revertEnd(
      match,
      lastEnd,
      remainingEnds: ends.length - 1,
    );

    await transactions.run(() async {
      await endRepository.deleteEnd(lastEnd.id);
      await matchRepository.saveMatch(updatedMatch);
    });
  }
}
