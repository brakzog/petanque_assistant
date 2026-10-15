import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repechage_playoff.dart';
import '../../../domain/team.dart';
import '../data/tournament_providers.dart';
import '../domain/playoff_selection.dart';

class RepechagePlayoffData {
  const RepechagePlayoffData({required this.teams, required this.selection});

  /// Tied teams taking part in the playoff.
  final List<Team> teams;
  final PlayoffSelection selection;
}

final repechagePlayoffControllerProvider = AsyncNotifierProvider.autoDispose
    .family<RepechagePlayoffController, RepechagePlayoffData, RepechagePlayoff>(
      RepechagePlayoffController.new,
    );

class RepechagePlayoffController extends AsyncNotifier<RepechagePlayoffData> {
  RepechagePlayoffController(this._playoff);

  final RepechagePlayoff _playoff;

  @override
  Future<RepechagePlayoffData> build() async {
    final teams = await ref
        .read(teamRepositoryProvider)
        .getTeamsForTournament(_playoff.tournamentId);

    return RepechagePlayoffData(
      teams: teams.where((team) => _playoff.teamIds.contains(team.id)).toList(),
      selection: PlayoffSelection(
        slots: _playoff.qualificationSlots,
        selectedTeamIds: _playoff.qualifiedTeamIds.toSet(),
      ),
    );
  }

  /// Returns the refusal message, or null when the team was toggled.
  String? toggle(String teamId) {
    final data = state.value;
    if (data == null) return null;

    final selection = data.selection.toggle(teamId);
    if (selection == null) {
      return 'Vous devez sélectionner exactement '
          '${_playoff.qualificationSlots} équipe(s).';
    }

    state = AsyncData(
      RepechagePlayoffData(teams: data.teams, selection: selection),
    );
    return null;
  }

  /// Returns false when the selection does not fill the slots exactly.
  Future<bool> validate() async {
    final selection = state.value?.selection;
    if (selection == null || !selection.isValid) return false;

    await ref
        .read(repechagePlayoffRepositoryProvider)
        .resolve(
          playoff: _playoff,
          qualifiedTeamIds: selection.selectedTeamIds.toList(),
        );
    return true;
  }
}
