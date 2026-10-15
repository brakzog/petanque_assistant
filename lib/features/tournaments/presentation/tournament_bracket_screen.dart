import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/match.dart';
import '../../../domain/tournament.dart';
import '../domain/bracket_view.dart';
import 'match_live_screen.dart';
import 'repechage_playoff_screen.dart';
import 'tournament_bracket_controller.dart';
import 'widgets/match_card.dart';
import 'widgets/playoff_required_card.dart';
import 'widgets/tournament_finished_card.dart';

class TournamentBracketScreen extends ConsumerWidget {
  final Tournament tournament;

  const TournamentBracketScreen({super.key, required this.tournament});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = tournamentBracketControllerProvider(tournament);
    final bracket = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(tournament.name)),
      body: bracket.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          debugPrint('ERREUR CHARGEMENT TOURNOI: $error');
          debugPrintStack(stackTrace: stackTrace);
          return _LoadError(error: error, onRetry: controller.reload);
        },
        data: (bracket) => _content(context, bracket, controller),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    BracketView bracket,
    TournamentBracketController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final playoff = bracket.playoff;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (bracket.isFinished)
          TournamentFinishedCard(bracket: bracket, tournament: tournament)
        else ...[
          Text('Tournoi en cours', style: textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            '${bracket.teams.length} équipes • '
            '${tournament.rules.targetScore} points',
          ),
        ],
        const SizedBox(height: 24),
        if (bracket.playoffRequired) ...[
          PlayoffRequiredCard(
            bracket: bracket,
            onResolve: playoff == null
                ? null
                : () async {
                    final resolved = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) =>
                            RepechagePlayoffScreen(playoff: playoff),
                      ),
                    );
                    if (resolved == true) await controller.reload();
                  },
          ),
          const SizedBox(height: 24),
        ],
        for (final round in bracket.rounds) ...[
          Text(bracket.roundLabel(round), style: textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final match in bracket.matchesOfRound(round))
            MatchCard(
              match: match,
              teamA: bracket.findTeam(match.teamAId),
              teamB: bracket.findTeam(match.teamBId),
              teamALabel: bracket.teamLabel(match.teamAId),
              teamBLabel: bracket.teamLabel(match.teamBId),
              teamAPlayers: bracket.playersLabel(match.teamAId),
              teamBPlayers: bracket.playersLabel(match.teamBId),
              onTap: bracket.isFinished
                  ? null
                  : () => _openMatch(context, bracket, controller, match),
            ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Future<void> _openMatch(
    BuildContext context,
    BracketView bracket,
    TournamentBracketController controller,
    Match match,
  ) async {
    final teamA = bracket.findTeam(match.teamAId);
    final teamB = bracket.findTeam(match.teamBId);
    if (teamA == null || teamB == null || match.isBye) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MatchLiveScreen(
          match: match,
          teamA: teamA,
          teamB: teamB,
          format: tournament.format,
        ),
      ),
    );

    await controller.reload();
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
              'Erreur lors du chargement du tournoi : $error',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
