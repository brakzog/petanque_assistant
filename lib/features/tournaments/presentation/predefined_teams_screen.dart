import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/player.dart';
import '../../../domain/team.dart';
import '../../../domain/tournament.dart';
import '../data/player_repository.dart';
import '../data/team_repository.dart';

class PredefinedTeamsScreen extends StatefulWidget {
  final Tournament tournament;

  const PredefinedTeamsScreen({
    super.key,
    required this.tournament,
  });

  @override
  State<PredefinedTeamsScreen> createState() =>
      _PredefinedTeamsScreenState();
}

class _PredefinedTeamsScreenState extends State<PredefinedTeamsScreen> {
  late final AppDatabase _database;
  late final PlayerRepository _playerRepository;
  late final TeamRepository _teamRepository;

  List<Player> _players = [];

  final Map<String, String?> _assignments = {};

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _playerRepository = PlayerRepository(_database);
    _teamRepository = TeamRepository(_database);

    _loadData();
  }

  int get _playersPerTeam {
    switch (widget.tournament.format) {
      case PetanqueFormat.singles:
        return 1;
      case PetanqueFormat.doubles:
        return 2;
      case PetanqueFormat.triples:
        return 3;
    }
  }

  int get _teamCount {
    if (_players.isEmpty) {
      return 0;
    }

    return _players.length ~/ _playersPerTeam;
  }

  String _teamName(int index) {
    return 'Équipe ${index + 1}';
  }

  Future<void> _loadData() async {
    final players = await _playerRepository.getPlayersForTournament(
      widget.tournament.id,
    );

    final teams = await _teamRepository.getTeamsForTournament(
      widget.tournament.id,
    );

    final assignments = <String, String?>{};

    for (final player in players) {
      assignments[player.id] = null;
    }

    for (var index = 0; index < teams.length; index++) {
      final teamName = _teamName(index);

      for (final player in teams[index].players) {
        assignments[player.id] = teamName;
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _players = players;
      _assignments
        ..clear()
        ..addAll(assignments);
      _loading = false;
    });
  }

  int _numberOfPlayersInTeam(String teamName) {
    return _assignments.values
        .where((value) => value == teamName)
        .length;
  }

  bool _teamIsFull(String teamName) {
    return _numberOfPlayersInTeam(teamName) >= _playersPerTeam;
  }

  bool get _allPlayersAssigned {
    if (_players.isEmpty) {
      return false;
    }

    return _assignments.values.every(
          (teamName) => teamName != null,
    );
  }

  bool get _allTeamsComplete {
    if (_teamCount == 0) {
      return false;
    }

    for (var index = 0; index < _teamCount; index++) {
      if (_numberOfPlayersInTeam(_teamName(index)) !=
          _playersPerTeam) {
        return false;
      }
    }

    return true;
  }

  void _assignPlayer(
      Player player,
      String? teamName,
      ) {
    if (teamName != null &&
        _assignments[player.id] != teamName &&
        _teamIsFull(teamName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$teamName est déjà complète.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _assignments[player.id] = teamName;
    });
  }

  Future<void> _saveTeams() async {
    if (!_allPlayersAssigned || !_allTeamsComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Toutes les équipes doivent être complètes.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _saving = true;
    });

    await _teamRepository.deleteTeamsForTournament(
      widget.tournament.id,
    );

    for (var index = 0; index < _teamCount; index++) {
      final teamName = _teamName(index);

      final players = _players
          .where(
            (player) =>
        _assignments[player.id] == teamName,
      )
          .toList();

      final team = Team(
        id: const Uuid().v4(),
        tournamentId: widget.tournament.id,
        name: teamName,
        players: players,
      );

      await _teamRepository.saveTeam(team);
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Composer les équipes'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Composer les équipes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.tournament.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 8),

          Text(
            '${_players.length} joueurs • '
                '$_teamCount équipes • '
                '$_playersPerTeam joueur(s) par équipe',
          ),

          const SizedBox(height: 24),

          ...List.generate(
            _teamCount,
                (index) {
              final teamName = _teamName(index);

              final assignedPlayers = _players
                  .where(
                    (player) =>
                _assignments[player.id] == teamName,
              )
                  .toList();

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        teamName,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${assignedPlayers.length}'
                            '/$_playersPerTeam joueur(s)',
                      ),

                      const SizedBox(height: 8),

                      if (assignedPlayers.isEmpty)
                        const Text(
                          'Aucun joueur',
                        )
                      else
                        ...assignedPlayers.map(
                              (player) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              child: Text(
                                player.name
                                    .substring(0, 1)
                                    .toUpperCase(),
                              ),
                            ),
                            title: Text(player.name),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.close,
                              ),
                              onPressed: () {
                                _assignPlayer(
                                  player,
                                  null,
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          Text(
            'Joueurs',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 8),

          ..._players.map(
                (player) {
              final currentTeam =
              _assignments[player.id];

              return Card(
                child: ListTile(
                  title: Text(player.name),
                  subtitle: Text(
                    currentTeam ?? 'Non affecté',
                  ),
                  trailing: DropdownButton<String?>(
                    value: currentTeam,
                    hint: const Text('Équipe'),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Aucune'),
                      ),
                      ...List.generate(
                        _teamCount,
                            (index) {
                          final teamName =
                          _teamName(index);

                          return DropdownMenuItem<String?>(
                            value: teamName,
                            child: Text(teamName),
                          );
                        },
                      ),
                    ],
                    onChanged: (value) {
                      _assignPlayer(
                        player,
                        value,
                      );
                    },
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: _saving ||
                !_allPlayersAssigned ||
                !_allTeamsComplete
                ? null
                : _saveTeams,
            icon: _saving
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.check),
            label: const Text(
              'Valider les équipes',
            ),
          ),
        ],
      ),
    );
  }
}