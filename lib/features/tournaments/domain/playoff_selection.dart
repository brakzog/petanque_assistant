/// Teams picked as qualified in a repechage playoff.
class PlayoffSelection {
  const PlayoffSelection({
    required this.slots,
    this.selectedTeamIds = const {},
  });

  final int slots;
  final Set<String> selectedTeamIds;

  bool isSelected(String teamId) => selectedTeamIds.contains(teamId);

  bool get isFull => selectedTeamIds.length >= slots;

  /// Exactly [slots] teams are selected.
  bool get isValid => selectedTeamIds.length == slots;

  /// Selects or unselects [teamId]. Returns null when selecting it would
  /// exceed the number of slots.
  PlayoffSelection? toggle(String teamId) {
    if (isSelected(teamId)) {
      return PlayoffSelection(
        slots: slots,
        selectedTeamIds: {...selectedTeamIds}..remove(teamId),
      );
    }
    if (isFull) return null;
    return PlayoffSelection(
      slots: slots,
      selectedTeamIds: {...selectedTeamIds, teamId},
    );
  }
}
