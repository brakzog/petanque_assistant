import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repechage_playoff.dart';
import 'repechage_playoff_controller.dart';
import 'widgets/playoff_team_tile.dart';

/// Pops with true once the playoff is resolved.
class RepechagePlayoffScreen extends ConsumerStatefulWidget {
  final RepechagePlayoff playoff;

  const RepechagePlayoffScreen({super.key, required this.playoff});

  @override
  ConsumerState<RepechagePlayoffScreen> createState() =>
      _RepechagePlayoffScreenState();
}

class _RepechagePlayoffScreenState
    extends ConsumerState<RepechagePlayoffScreen> {
  bool _saving = false;

  RepechagePlayoffController get _controller =>
      ref.read(repechagePlayoffControllerProvider(widget.playoff).notifier);

  void _toggle(String teamId) {
    final refusal = _controller.toggle(teamId);
    if (refusal != null) _showMessage(refusal);
  }

  Future<void> _validate() async {
    setState(() => _saving = true);
    try {
      final resolved = await _controller.validate();
      if (!mounted) return;
      if (resolved) {
        Navigator.of(context).pop(true);
      } else {
        _showMessage(
          'Sélectionnez exactement '
          '${widget.playoff.qualificationSlots} équipe(s).',
        );
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
    final data = ref.watch(repechagePlayoffControllerProvider(widget.playoff));

    return Scaffold(
      appBar: AppBar(title: const Text('Barrage de repêchage')),
      body: data.when(
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

  Widget _content(RepechagePlayoffData data) {
    final textTheme = Theme.of(context).textTheme;
    final selection = data.selection;
    final playoff = widget.playoff;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Équipes à égalité', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          '${playoff.teamIds.length} équipes '
          'pour ${playoff.qualificationSlots} '
          'place(s) qualificative(s).',
        ),
        const SizedBox(height: 8),
        Text(
          'Sélectionnées : '
          '${selection.selectedTeamIds.length}/${selection.slots}',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        for (final team in data.teams)
          PlayoffTeamTile(
            team: team,
            selected: selection.isSelected(team.id),
            onToggle: () => _toggle(team.id),
          ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _saving || !selection.isValid ? null : _validate,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
          label: const Text('Valider le barrage'),
        ),
      ],
    );
  }
}
