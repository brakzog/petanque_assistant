import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/domain/player.dart';
import 'package:tournoi_de_petanque/domain/team.dart';
import 'package:tournoi_de_petanque/features/tournaments/domain/team_assignment.dart';

const players = [
  Player(id: 'p1', tournamentId: 't', name: 'Ana'),
  Player(id: 'p2', tournamentId: 't', name: 'Bob'),
  Player(id: 'p3', tournamentId: 't', name: 'Cid'),
  Player(id: 'p4', tournamentId: 't', name: 'Dan'),
];

void main() {
  const empty = TeamAssignment(players: players, playersPerTeam: 2);

  test('derives the team count from players per team', () {
    expect(empty.teamCount, 2);
    expect(TeamAssignment.teamName(0), 'Équipe 1');
  });

  test('refuses to overfill a team but allows reassigning in place', () {
    final full = empty.assign(players[0], 0).assign(players[1], 0);

    expect(full.isFull(0), isTrue);
    expect(full.canAssign(players[2], 0), isFalse);
    expect(full.canAssign(players[0], 0), isTrue);
    expect(full.canAssign(players[2], null), isTrue);
  });

  test('removes a player from their team', () {
    final assigned = empty.assign(players[0], 1);

    expect(assigned.teamOf(players[0]), 1);
    expect(assigned.assign(players[0], null).teamOf(players[0]), isNull);
  });

  test('is complete only when every team is full', () {
    final partial = empty.assign(players[0], 0).assign(players[1], 0);
    final complete = partial.assign(players[2], 1).assign(players[3], 1);

    expect(partial.isComplete, isFalse);
    expect(complete.isComplete, isTrue);
  });

  test('rebuilds from saved teams and builds teams back', () {
    final assignment = TeamAssignment.fromTeams(
      players: players,
      teams: [
        Team(
          id: 'x',
          tournamentId: 't',
          name: 'Les As',
          players: [players[3], players[0]],
        ),
        Team(
          id: 'y',
          tournamentId: 't',
          name: 'Les Rois',
          players: [players[1], players[2]],
        ),
      ],
      playersPerTeam: 2,
    );

    var counter = 0;
    final teams = assignment.buildTeams(
      tournamentId: 't',
      newId: () => 'id${counter++}',
    );

    expect(teams.map((team) => team.name), ['Équipe 1', 'Équipe 2']);
    expect(teams.map((team) => team.id), ['id0', 'id1']);
    expect(teams[0].players.map((p) => p.id), ['p1', 'p4']);
    expect(teams[1].players.map((p) => p.id), ['p2', 'p3']);
  });
}
