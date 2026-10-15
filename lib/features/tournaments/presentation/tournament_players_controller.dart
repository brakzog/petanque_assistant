import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/player.dart';
import '../../../domain/tournament.dart';
import '../data/roster_service.dart';
import '../data/tournament_providers.dart';

final tournamentPlayersControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TournamentPlayersController, Roster, Tournament>(
      TournamentPlayersController.new,
    );

/// Participants and teams of a tournament. Each change returns the refusal
/// message to show, or null on success.
class TournamentPlayersController extends AsyncNotifier<Roster> {
  TournamentPlayersController(this._tournament);

  final Tournament _tournament;

  RosterService get _service => ref.read(rosterServiceProvider);

  @override
  Future<Roster> build() => _service.load(_tournament);

  Future<String?> addPlayer(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return Future.value();
    return _change(
      (roster) => _service.addPlayer(roster, _tournament, trimmed),
    );
  }

  Future<String?> deletePlayer(Player player) {
    return _change((roster) => _service.deletePlayer(roster, player));
  }

  Future<String?> generateTeams() {
    return _change((roster) => _service.generateTeams(roster, _tournament));
  }

  Future<String?> resetTeams() {
    return _change((_) => _service.resetTeams(_tournament));
  }

  /// Reloads while keeping the current roster on screen.
  Future<void> reload() async {
    final result = await AsyncValue.guard(() => _service.load(_tournament));
    if (ref.mounted) state = result;
  }

  Future<String?> _change(Future<void> Function(Roster roster) action) async {
    final roster = state.value;
    if (roster == null) return null;

    try {
      await action(roster);
    } on RosterException catch (error) {
      return error.message;
    }

    await reload();
    return null;
  }
}
