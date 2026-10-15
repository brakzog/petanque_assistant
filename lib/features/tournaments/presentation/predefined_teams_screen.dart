import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/player.dart';
import '../../../domain/tournament.dart';
import '../domain/team_assignment.dart';
import 'predefined_teams_controller.dart';
import 'widgets/player_assignment_tile.dart';
import 'widgets/team_slot_card.dart';

/// Pops with true once the teams are saved.
class PredefinedTeamsScreen extends ConsumerStatefulWidget {
  final Tournament tournament;

  const PredefinedTeamsScreen({super.key, required this.tournament});

  @override
  ConsumerState<PredefinedTeamsScreen> createState() =>
      _PredefinedTeamsScreenState();
}

class _PredefinedTeamsScreenState extends ConsumerState<PredefinedTeamsScreen> {
  bool _saving = false;

  PredefinedTeamsController get _controller =>
      ref.read(predefinedTeamsControllerProvider(widget.tournament).notifier);

  void _assign(Player player, int? team) {
    final refusal = _controller.assign(player, team);
    if (refusal != null) _showMessage(refusal);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final saved = await _controller.save();
      if (!mounted) return;
      if (saved) {
        Navigator.of(context).pop(true);
      } else {
        _showMessage('Toutes les équipes doivent être complètes.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final assignment = ref.watch(
      predefinedTeamsControllerProvider(widget.tournament),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Composer les équipes')),
      body: assignment.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(error.toString()),
          ),
        ),
        data: _content,
      ),
    );
  }

  Widget _content(TeamAssignment assignment) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(widget.tournament.name, style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          '${assignment.players.length} joueurs • '
          '${assignment.teamCount} équipes • '
          '${assignment.playersPerTeam} joueur(s) par équipe',
        ),
        const SizedBox(height: 24),
        for (var team = 0; team < assignment.teamCount; team++)
          TeamSlotCard(
            name: TeamAssignment.teamName(team),
            players: assignment.playersOf(team),
            capacity: assignment.playersPerTeam,
            onRemove: (player) => _assign(player, null),
          ),
        const SizedBox(height: 16),
        Text('Joueurs', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        for (final player in assignment.players)
          PlayerAssignmentTile(
            player: player,
            team: assignment.teamOf(player),
            teamCount: assignment.teamCount,
            onChanged: (team) => _assign(player, team),
          ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _saving || !assignment.isComplete ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
          label: const Text('Valider les équipes'),
        ),
      ],
    );
  }
}
