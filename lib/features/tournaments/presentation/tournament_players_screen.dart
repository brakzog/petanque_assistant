import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/player.dart';
import '../../../domain/tournament.dart';
import '../data/roster_service.dart';
import '../domain/roster_status.dart';
import 'ball_description.dart';
import 'player_balls_screen.dart';
import 'predefined_teams_screen.dart';
import 'tournament_bracket_screen.dart';
import 'tournament_players_controller.dart';
import 'widgets/add_player_field.dart';
import 'widgets/player_tile.dart';
import 'widgets/team_tile.dart';

class TournamentPlayersScreen extends ConsumerWidget {
  final Tournament tournament;

  const TournamentPlayersScreen({super.key, required this.tournament});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = tournamentPlayersControllerProvider(tournament);
    final roster = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(tournament.name)),
      body: roster.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(error.toString()),
          ),
        ),
        data: (roster) => _content(context, roster, controller),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    Roster roster,
    TournamentPlayersController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final status = RosterStatus(
      tournament: tournament,
      playerCount: roster.players.length,
      teamCount: roster.teams.length,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Participants', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          '${roster.players.length} joueur(s) • '
          '${status.completeTeams} équipe(s) complète(s)',
        ),
        if (status.remainingPlayers > 0)
          Text(
            '${status.remainingPlayers} joueur(s) sans équipe complète',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 16),
        AddPlayerField(
          enabled: !status.teamsFormed,
          onAdd: (name) async {
            final refusal = await controller.addPlayer(name);
            if (refusal != null && context.mounted) {
              _showMessage(context, refusal);
            }
            return refusal == null;
          },
        ),
        const SizedBox(height: 16),
        if (roster.players.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Aucun participant pour le moment.')),
          )
        else
          for (final player in roster.players)
            PlayerTile(
              player: player,
              ballDescription: describeBalls(roster.balls[player.id]),
              onOpenBalls: () => _openPlayerBalls(context, controller, player),
              onDelete: status.teamsFormed
                  ? null
                  : () => _run(context, controller.deletePlayer(player)),
            ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Text('Équipes', style: textTheme.headlineSmall),
        const SizedBox(height: 16),
        if (!status.teamsFormed)
          _composeTeamsButton(context, status, controller)
        else ...[
          for (final team in roster.teams) TeamTile(team: team),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TournamentBracketScreen(tournament: tournament),
              ),
            ),
            icon: const Icon(Icons.emoji_events),
            label: const Text('Démarrer le tournoi'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _run(context, controller.resetTeams()),
            icon: const Icon(Icons.refresh),
            label: const Text('Refaire le tirage'),
          ),
        ],
      ],
    );
  }

  Widget _composeTeamsButton(
    BuildContext context,
    RosterStatus status,
    TournamentPlayersController controller,
  ) {
    if (status.usesRandomTeams) {
      return FilledButton.icon(
        onPressed: status.canGenerateTeams
            ? () => _run(context, controller.generateTeams())
            : null,
        icon: const Icon(Icons.shuffle),
        label: const Text('Constituer les équipes'),
      );
    }

    return FilledButton.icon(
      onPressed: () async {
        final changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PredefinedTeamsScreen(tournament: tournament),
          ),
        );
        if (changed == true) await controller.reload();
      },
      icon: const Icon(Icons.groups),
      label: const Text('Composer les équipes'),
    );
  }

  Future<void> _openPlayerBalls(
    BuildContext context,
    TournamentPlayersController controller,
    Player player,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlayerBallsScreen(player: player)),
    );
    await controller.reload();
  }

  /// Shows the refusal message of a change, if any.
  Future<void> _run(BuildContext context, Future<String?> change) async {
    final refusal = await change;
    if (refusal != null && context.mounted) _showMessage(context, refusal);
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
