import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/player.dart';
import '../../../domain/team.dart';
import '../../../domain/tournament.dart';
import '../data/petanque_ball_repository.dart';
import '../data/player_repository.dart';
import '../data/team_generator.dart';
import '../data/team_repository.dart';
import 'player_balls_screen.dart';
import 'predefined_teams_screen.dart';
import 'tournament_bracket_screen.dart';

class TournamentPlayersScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentPlayersScreen({
    super.key,
    required this.tournament,
  });

  @override
  State<TournamentPlayersScreen> createState() =>
      _TournamentPlayersScreenState();
}

class _TournamentPlayersScreenState extends State<TournamentPlayersScreen> {
  late final AppDatabase _database;
  late final PlayerRepository _playerRepository;
  late final TeamRepository _teamRepository;
  late final PetanqueBallRepository _ballRepository;

  final TeamGenerator _teamGenerator = const TeamGenerator();
  final _nameController = TextEditingController();

  List<Player> _players = [];
  List<Team> _teams = [];

  final Map<String, PlayerBallData?> _playerBalls = {};

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _playerRepository = PlayerRepository(_database);
    _teamRepository = TeamRepository(_database);
    _ballRepository = PetanqueBallRepository(_database);

    _loadData();
  }

  Future<void> _loadData() async {
    final players = await _playerRepository.getPlayersForTournament(
      widget.tournament.id,
    );

    final teams = await _teamRepository.getTeamsForTournament(
      widget.tournament.id,
    );

    final playerBalls = <String, PlayerBallData?>{};

    for (final player in players) {
      playerBalls[player.id] =
          await _ballRepository.getForPlayer(player.id);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _players = players;
      _teams = teams;

      _playerBalls
        ..clear()
        ..addAll(playerBalls);

      _loading = false;
    });
  }

  Future<void> _addPlayer() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    if (_teams.isNotEmpty) {
      _showMessage(
        'Les équipes sont déjà constituées. '
        'Supprimez le tirage avant de modifier les participants.',
      );
      return;
    }

    final player = Player(
      id: const Uuid().v4(),
      tournamentId: widget.tournament.id,
      name: name,
    );

    await _playerRepository.savePlayer(player);

    _nameController.clear();

    await _loadData();
  }

  Future<void> _deletePlayer(Player player) async {
    if (_teams.isNotEmpty) {
      _showMessage(
        'Les équipes sont déjà constituées. '
        'Supprimez le tirage avant de modifier les participants.',
      );
      return;
    }

    await _playerRepository.deletePlayer(player.id);
    await _loadData();
  }

  Future<void> _openPlayerBalls(Player player) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayerBallsScreen(
          player: player,
        ),
      ),
    );

    await _loadData();
  }

  Future<void> _generateTeams() async {
    if (widget.tournament.teamCreationMode != TeamCreationMode.random) {
      _showMessage(
        'Ce tournoi utilise des équipes prédéfinies.',
      );
      return;
    }

    if (_teams.isNotEmpty) {
      _showMessage(
        'Les équipes ont déjà été constituées.',
      );
      return;
    }

    try {
      final teams = _teamGenerator.generateRandomTeams(
        tournament: widget.tournament,
        players: _players,
      );

      for (final team in teams) {
        await _teamRepository.saveTeam(team);
      }

      await _loadData();
    } on ArgumentError catch (error) {
      _showMessage(
        error.message?.toString() ??
            'Impossible de constituer les équipes.',
      );
    }
  }

  Future<void> _resetTeams() async {
    await _teamRepository.deleteTeamsForTournament(
      widget.tournament.id,
    );

    await _loadData();
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _ballDescription(Player player) {
    final ball = _playerBalls[player.id];

    if (ball == null) {
      return 'Boules : non renseignées';
    }

    final parts = <String>[];

    if (ball.brand != null && ball.brand!.isNotEmpty) {
      parts.add(ball.brand!);
    }

    if (ball.model != null && ball.model!.isNotEmpty) {
      parts.add(ball.model!);
    }

    if (ball.diameter != null) {
      parts.add('${ball.diameter} mm');
    }

    if (ball.weight != null) {
      parts.add('${ball.weight} g');
    }

    if (parts.isEmpty) {
      return 'Boules : renseignées';
    }

    return parts.join(' • ');
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

  bool get _canGenerateTeams {
    return _players.isNotEmpty &&
        _players.length % _playersPerTeam == 0 &&
        _teams.isEmpty &&
        widget.tournament.teamCreationMode ==
            TeamCreationMode.random;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completeTeams = _players.length ~/ _playersPerTeam;
    final remainingPlayers = _players.length % _playersPerTeam;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tournament.name),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Participants',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                Text(
                  '${_players.length} joueur(s) • '
                  '$completeTeams équipe(s) complète(s)',
                ),

                if (remainingPlayers > 0)
                  Text(
                    '$remainingPlayers joueur(s) '
                    'sans équipe complète',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        enabled: _teams.isEmpty,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Nom du joueur',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addPlayer(),
                      ),
                    ),

                    const SizedBox(width: 8),

                    IconButton.filled(
                      onPressed:
                          _teams.isEmpty ? _addPlayer : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (_players.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 24,
                    ),
                    child: Center(
                      child: Text(
                        'Aucun participant pour le moment.',
                      ),
                    ),
                  )
                else
                  ..._players.map(
                    (player) => Card(
                      child: ListTile(
                        onTap: () => _openPlayerBalls(player),
                        leading: CircleAvatar(
                          child: Text(
                            player.name
                                .substring(0, 1)
                                .toUpperCase(),
                          ),
                        ),
                        title: Text(player.name),
                        subtitle: Text(
                          _ballDescription(player),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Configurer les boules',
                              icon: const Icon(
                                Icons.sports,
                              ),
                              onPressed: () =>
                                  _openPlayerBalls(player),
                            ),
                            IconButton(
                              tooltip: 'Supprimer',
                              icon: const Icon(
                                Icons.delete_outline,
                              ),
                              onPressed: _teams.isEmpty
                                  ? () => _deletePlayer(player)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                Text(
                  'Équipes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 16),

                if (_teams.isEmpty) ...[
                  if (widget.tournament.teamCreationMode ==
                      TeamCreationMode.random)
                    FilledButton.icon(
                      onPressed:
                          _canGenerateTeams ? _generateTeams : null,
                      icon: const Icon(Icons.shuffle),
                      label: const Text(
                        'Constituer les équipes',
                      ),
                    )
                  else
                    FilledButton.icon(
                      onPressed: () async {
                        final changed =
                            await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) =>
                                PredefinedTeamsScreen(
                              tournament: widget.tournament,
                            ),
                          ),
                        );

                        if (changed == true) {
                          await _loadData();
                        }
                      },
                      icon: const Icon(Icons.groups),
                      label: const Text(
                        'Composer les équipes',
                      ),
                    ),
                ] else ...[
                  ..._teams.map(
                    (team) => Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.groups),
                        ),
                        title: Text(team.name),
                        subtitle: Text(
                          team.players
                              .map((player) => player.name)
                              .join(' + '),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              TournamentBracketScreen(
                            tournament: widget.tournament,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.emoji_events),
                    label: const Text(
                      'Démarrer le tournoi',
                    ),
                  ),

                  const SizedBox(height: 8),

                  OutlinedButton.icon(
                    onPressed: _resetTeams,
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Refaire le tirage',
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}