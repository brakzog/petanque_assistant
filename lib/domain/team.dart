import 'player.dart';

class Team {
  final String id;
  final String tournamentId;
  final String name;
  final List<Player> players;

  const Team({
    required this.id,
    required this.tournamentId,
    required this.name,
    this.players = const [],
  });

  Team copyWith({
    String? id,
    String? tournamentId,
    String? name,
    List<Player>? players,
  }) {
    return Team(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
      players: players ?? this.players,
    );
  }
}