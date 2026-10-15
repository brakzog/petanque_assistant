import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/player.dart';
import '../../../domain/tournament.dart';
import '../data/tournament_providers.dart';
import '../domain/team_assignment.dart';

final predefinedTeamsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<PredefinedTeamsController, TeamAssignment, Tournament>(
      PredefinedTeamsController.new,
    );

/// Composition of predefined teams, saved only on validation.
class PredefinedTeamsController extends AsyncNotifier<TeamAssignment> {
  PredefinedTeamsController(this._tournament);

  final Tournament _tournament;

  @override
  Future<TeamAssignment> build() {
    return ref.read(predefinedTeamsServiceProvider).load(_tournament);
  }

  /// Returns the refusal message, or null when the player was moved.
  String? assign(Player player, int? team) {
    final assignment = state.value;
    if (assignment == null) return null;

    if (team != null && !assignment.canAssign(player, team)) {
      return '${TeamAssignment.teamName(team)} est déjà complète.';
    }

    state = AsyncData(assignment.assign(player, team));
    return null;
  }

  /// Returns false when some team is not complete yet.
  Future<bool> save() async {
    final assignment = state.value;
    if (assignment == null || !assignment.isComplete) return false;

    await ref
        .read(predefinedTeamsServiceProvider)
        .save(_tournament, assignment);
    return true;
  }
}
