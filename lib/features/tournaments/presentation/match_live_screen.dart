import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/match.dart';
import '../../../domain/team.dart';
import '../../../domain/tournament.dart';
import '../../terrain_analysis/presentation/terrain_analysis_screen.dart';
import '../data/tournament_providers.dart';
import 'match_live_controller.dart';
import 'widgets/end_history.dart';
import 'widgets/score_buttons.dart';
import 'widgets/team_score_card.dart';
import 'widgets/winner_card.dart';

class MatchLiveScreen extends ConsumerWidget {
  final Match match;
  final Team teamA;
  final Team teamB;
  final PetanqueFormat format;

  const MatchLiveScreen({
    super.key,
    required this.match,
    required this.teamA,
    required this.teamB,
    required this.format,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = matchLiveControllerProvider(match);
    final data = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(title: const Text('Partie')),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(error.toString()),
          ),
        ),
        data: (data) => _content(
          context,
          data,
          ref.read(provider.notifier),
          ref.read(matchScorerProvider).maxPointsPerEnd(format),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    MatchLiveData data,
    MatchLiveController controller,
    int maxPointsPerEnd,
  ) {
    final current = data.match;
    final ends = data.ends;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TeamScoreCard(
          team: teamA,
          players: _playersLabel(teamA),
          score: current.teamAScore,
        ),
        const SizedBox(height: 8),
        Center(
          child: Text('VS', style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 8),
        TeamScoreCard(
          team: teamB,
          players: _playersLabel(teamB),
          score: current.teamBScore,
        ),
        const SizedBox(height: 16),
        Center(child: Text('Objectif : ${current.targetScore} points')),
        const SizedBox(height: 24),
        if (current.isFinished)
          WinnerCard(winnerName: _teamName(current.winnerTeamId!))
        else ...[
          Text(
            'Mène ${ends.length + 1}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const TerrainAnalysisScreen(),
              ),
            ),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Analyser le terrain'),
          ),
          const SizedBox(height: 24),
          ScoreButtons(
            team: teamA,
            onScore: (points) =>
                controller.addEnd(teamId: teamA.id, points: points),
            maxPoints: maxPointsPerEnd,
          ),
          const SizedBox(height: 16),
          ScoreButtons(
            team: teamB,
            onScore: (points) =>
                controller.addEnd(teamId: teamB.id, points: points),
            maxPoints: maxPointsPerEnd,
          ),
        ],
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Historique des mènes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        EndHistory(ends: ends, teamName: _teamName),
        if (ends.isNotEmpty) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: controller.undoLastEnd,
            icon: const Icon(Icons.undo),
            label: const Text('Annuler la dernière mène'),
          ),
        ],
      ],
    );
  }

  String _playersLabel(Team team) {
    return team.players.map((player) => player.name).join(' + ');
  }

  String _teamName(String teamId) {
    return teamId == teamA.id ? teamA.name : teamB.name;
  }
}
