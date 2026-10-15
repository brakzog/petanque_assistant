import 'package:uuid/uuid.dart';

import '../../../domain/petanque_format_rules.dart';
import '../../../domain/player.dart';
import '../../../domain/team.dart';
import '../../../domain/tournament.dart';

class TeamGenerator {
  const TeamGenerator();

  List<Team> generateRandomTeams({
    required Tournament tournament,
    required List<Player> players,
  }) {
    final playersPerTeam = tournament.format.playersPerTeam;

    if (players.isEmpty) {
      throw ArgumentError('Aucun joueur inscrit.');
    }

    if (players.length % playersPerTeam != 0) {
      throw ArgumentError(
        'Le nombre de joueurs ne permet pas de constituer '
            'des équipes complètes.',
      );
    }

    final shuffledPlayers = List<Player>.from(players)..shuffle();

    final teams = <Team>[];

    for (
    var index = 0;
    index < shuffledPlayers.length;
    index += playersPerTeam
    ) {
      final teamPlayers = shuffledPlayers
          .skip(index)
          .take(playersPerTeam)
          .toList();

      teams.add(
        Team(
          id: const Uuid().v4(),
          tournamentId: tournament.id,
          name: 'Équipe ${teams.length + 1}',
          players: teamPlayers,
        ),
      );
    }

    return teams;
  }
}