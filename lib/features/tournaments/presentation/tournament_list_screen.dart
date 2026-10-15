import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/tournament.dart';
import 'tournament_bracket_screen.dart';
import 'tournament_create_screen.dart';
import 'tournament_list_controller.dart';
import 'tournament_players_screen.dart';
import 'widgets/confirm_delete_tournament_dialog.dart';
import 'widgets/empty_tournament_list.dart';
import 'widgets/tournament_tile.dart';

class TournamentListScreen extends ConsumerWidget {
  const TournamentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournaments = ref.watch(tournamentListControllerProvider);
    final controller = ref.read(tournamentListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Tournoi de Pétanque')),
      body: tournaments.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(error.toString()),
          ),
        ),
        data: (tournaments) => tournaments.isEmpty
            ? const EmptyTournamentList()
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: tournaments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final tournament = tournaments[index];
                  return TournamentTile(
                    tournament: tournament,
                    onOpen: () => _open(context, controller, tournament),
                    onDelete: () => _delete(context, controller, tournament),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau tournoi'),
      ),
    );
  }

  Future<void> _create(
    BuildContext context,
    TournamentListController controller,
  ) async {
    final tournament = await Navigator.of(context).push<Tournament>(
      MaterialPageRoute(builder: (_) => const TournamentCreateScreen()),
    );
    if (tournament != null) await controller.add(tournament);
  }

  /// Opens the bracket once the tournament has started, the players before.
  Future<void> _open(
    BuildContext context,
    TournamentListController controller,
    Tournament tournament,
  ) async {
    final started = await controller.hasStarted(tournament);
    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => started
            ? TournamentBracketScreen(tournament: tournament)
            : TournamentPlayersScreen(tournament: tournament),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    TournamentListController controller,
    Tournament tournament,
  ) async {
    if (await confirmDeleteTournament(context, tournament)) {
      await controller.delete(tournament);
    }
  }
}
