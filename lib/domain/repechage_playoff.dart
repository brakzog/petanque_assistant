enum RepechagePlayoffStatus {
  pending,
  resolved,
}

class RepechagePlayoff {
  final String id;
  final String tournamentId;

  /// Équipes concernées par l'égalité.
  final List<String> teamIds;

  /// Nombre d'équipes qui doivent sortir qualifiées du barrage.
  final int qualificationSlots;

  /// Renseigné lorsque le barrage est terminé.
  final List<String> qualifiedTeamIds;

  final RepechagePlayoffStatus status;

  const RepechagePlayoff({
    required this.id,
    required this.tournamentId,
    required this.teamIds,
    required this.qualificationSlots,
    this.qualifiedTeamIds = const [],
    this.status = RepechagePlayoffStatus.pending,
  });

  bool get isResolved =>
      status == RepechagePlayoffStatus.resolved;

  RepechagePlayoff copyWith({
    String? id,
    String? tournamentId,
    List<String>? teamIds,
    int? qualificationSlots,
    List<String>? qualifiedTeamIds,
    RepechagePlayoffStatus? status,
  }) {
    return RepechagePlayoff(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      teamIds: teamIds ?? this.teamIds,
      qualificationSlots:
      qualificationSlots ?? this.qualificationSlots,
      qualifiedTeamIds:
      qualifiedTeamIds ?? this.qualifiedTeamIds,
      status: status ?? this.status,
    );
  }
}