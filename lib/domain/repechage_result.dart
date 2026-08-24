class RepechageResult {
  final List<String> qualifiedTeamIds;
  final List<String> eliminatedTeamIds;
  final List<String> playoffTeamIds;

  final int playoffQualificationSlots;

  const RepechageResult({
    required this.qualifiedTeamIds,
    required this.eliminatedTeamIds,
    required this.playoffTeamIds,
    required this.playoffQualificationSlots,
  });

  bool get requiresPlayoff => playoffTeamIds.isNotEmpty;
}