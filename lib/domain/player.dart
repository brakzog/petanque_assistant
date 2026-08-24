class Player {
  final String id;
  final String tournamentId;
  final String name;

  const Player({
    required this.id,
    required this.tournamentId,
    required this.name,
  });

  Player copyWith({
    String? id,
    String? tournamentId,
    String? name,
  }) {
    return Player(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
    );
  }
}