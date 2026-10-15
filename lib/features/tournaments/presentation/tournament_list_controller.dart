import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/tournament.dart';
import '../data/tournament_providers.dart';

final tournamentListControllerProvider =
    AsyncNotifierProvider.autoDispose<
      TournamentListController,
      List<Tournament>
    >(TournamentListController.new);

class TournamentListController extends AsyncNotifier<List<Tournament>> {
  @override
  Future<List<Tournament>> build() => _fetch();

  Future<void> add(Tournament tournament) async {
    await ref.read(tournamentRepositoryProvider).saveTournament(tournament);
    await _reload();
  }

  Future<void> delete(Tournament tournament) async {
    await ref
        .read(tournamentRepositoryProvider)
        .deleteTournament(tournament.id);
    await _reload();
  }

  /// A tournament has started once its first round has been generated.
  Future<bool> hasStarted(Tournament tournament) async {
    final matches = await ref
        .read(matchRepositoryProvider)
        .getMatchesForTournament(tournament.id);
    return matches.isNotEmpty;
  }

  Future<void> _reload() async {
    final result = await AsyncValue.guard(_fetch);
    if (ref.mounted) state = result;
  }

  Future<List<Tournament>> _fetch() {
    return ref.read(tournamentRepositoryProvider).getTournaments();
  }
}
