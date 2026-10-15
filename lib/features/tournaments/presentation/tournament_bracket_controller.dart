import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/tournament.dart';
import '../data/tournament_providers.dart';
import '../domain/bracket_view.dart';

final tournamentBracketControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TournamentBracketController, BracketView, Tournament>(
      TournamentBracketController.new,
    );

class TournamentBracketController extends AsyncNotifier<BracketView> {
  TournamentBracketController(this._tournament);

  final Tournament _tournament;

  @override
  Future<BracketView> build() => _load();

  /// Reloads while keeping the current bracket on screen.
  Future<void> reload() async {
    final result = await AsyncValue.guard(_load);
    if (ref.mounted) state = result;
  }

  Future<BracketView> _load() {
    return ref.read(bracketLoaderProvider).load(_tournament);
  }
}
