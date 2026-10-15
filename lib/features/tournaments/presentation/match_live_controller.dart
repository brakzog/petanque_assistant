import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/end.dart';
import '../../../domain/match.dart';
import '../data/tournament_providers.dart';

class MatchLiveData {
  const MatchLiveData({required this.match, required this.ends});

  final Match match;
  final List<End> ends;
}

final matchLiveControllerProvider = AsyncNotifierProvider.autoDispose
    .family<MatchLiveController, MatchLiveData, Match>(MatchLiveController.new);

/// Loads a match with its ends and records score changes.
class MatchLiveController extends AsyncNotifier<MatchLiveData> {
  MatchLiveController(this._initialMatch);

  final Match _initialMatch;
  bool _saving = false;

  @override
  Future<MatchLiveData> build() => _fetch();

  Future<void> addEnd({required String teamId, required int points}) {
    return _save((data) {
      if (data.match.isFinished) return Future.value();
      return ref
          .read(matchEndRecorderProvider)
          .recordEnd(data.match, data.ends, teamId: teamId, points: points);
    });
  }

  Future<void> undoLastEnd() {
    return _save(
      (data) =>
          ref.read(matchEndRecorderProvider).undoLastEnd(data.match, data.ends),
    );
  }

  /// Ignores taps while a previous write is still running, so two quick taps
  /// cannot create two ends with the same number.
  Future<void> _save(Future<void> Function(MatchLiveData data) write) async {
    final data = state.value;
    if (data == null || _saving) return;

    _saving = true;
    try {
      await write(data);
      final refreshed = await _fetch();
      if (ref.mounted) state = AsyncData(refreshed);
    } finally {
      _saving = false;
    }
  }

  Future<MatchLiveData> _fetch() async {
    final storedMatch = await ref
        .read(matchRepositoryProvider)
        .getMatch(_initialMatch.id);
    final ends = await ref
        .read(endRepositoryProvider)
        .getEndsForMatch(_initialMatch.id);
    return MatchLiveData(match: storedMatch ?? _initialMatch, ends: ends);
  }
}
