import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/match.dart';
import '../../../domain/team.dart';
import '../../../domain/tournament.dart';
import '../data/bracket_generator.dart';
import '../data/match_repository.dart';
import '../data/team_repository.dart';
import 'match_live_screen.dart';
import '../data/tournament_progression_service.dart';
import '../../../domain/tournament_progression_result.dart';
import '../data/repechage_playoff_repository.dart';
import '../../../domain/repechage_playoff.dart';
import 'repechage_playoff_screen.dart';

class TournamentBracketScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentBracketScreen({
    super.key,
    required this.tournament,
  });

  @override
  State<TournamentBracketScreen> createState() =>
      _TournamentBracketScreenState();
}

class _TournamentBracketScreenState extends State<TournamentBracketScreen> {
  late final AppDatabase _database;
  late final TeamRepository _teamRepository;
  late final MatchRepository _matchRepository;
  late final TournamentProgressionService _progressionService;
  late final RepechagePlayoffRepository _playoffRepository;

  final BracketGenerator _bracketGenerator = const BracketGenerator();

  TournamentProgressionResult? _progressionResult;

  List<Team> _teams = [];
  List<Match> _matches = [];

  bool _loading = true;

  RepechagePlayoff? _playoff;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _teamRepository = TeamRepository(_database);
    _matchRepository = MatchRepository(_database);
    _playoffRepository = RepechagePlayoffRepository(
      _database,
    );
    _progressionService = TournamentProgressionService(
      matchRepository: _matchRepository,
      playoffRepository: _playoffRepository,
    );

    _loadTournament();
  }

  Future<void> _loadTournament() async {
    final teams = await _teamRepository.getTeamsForTournament(
      widget.tournament.id,
    );

    var matches = await _matchRepository.getMatchesForTournament(
      widget.tournament.id,
    );

    TournamentProgressionResult? progressionResult;

    if (matches.isEmpty) {
      matches = _bracketGenerator.generateFirstRound(
        tournament: widget.tournament,
        teams: teams,
      );

      await _matchRepository.saveMatches(matches);
    } else {
      progressionResult =
      await _progressionService.progressIfPossible(
        widget.tournament,
      );

      matches = await _matchRepository.getMatchesForTournament(
        widget.tournament.id,
      );
    }

    final playoff =
    await _playoffRepository.getForTournament(
      widget.tournament.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _teams = teams;
      _matches = matches;
      _playoff = playoff;
      _progressionResult = progressionResult;
      _loading = false;
    });
  }

  Team? _findTeam(String? teamId) {
    if (teamId == null) {
      return null;
    }

    for (final team in _teams) {
      if (team.id == teamId) {
        return team;
      }
    }

    return null;
  }

  String _teamLabel(String? teamId) {
    return _findTeam(teamId)?.name ?? '—';
  }

  String _playersLabel(String? teamId) {
    final team = _findTeam(teamId);

    if (team == null) {
      return '';
    }

    return team.players
        .map((player) => player.name)
        .join(' + ');
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tournament.name),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final rounds = _matches
        .map((match) => match.round)
        .toSet()
        .toList()
      ..sort();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Tournoi en cours',
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 4),

        Text(
          '${_teams.length} équipes • '
              '${widget.tournament.rules.targetScore} points',
        ),

        const SizedBox(height: 24),

        if (_progressionResult?.state ==
            TournamentProgressionState.playoffRequired) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Barrage de repêchage nécessaire',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${_progressionResult!.playoffTeamIds.length} '
                        'équipes sont à égalité pour '
                        '${_progressionResult!.playoffQualificationSlots} '
                        'place(s).',
                  ),

                  const SizedBox(height: 12),

                  ..._progressionResult!.playoffTeamIds.map(
                        (teamId) => Text(
                      '• ${_teamLabel(teamId)}',
                    ),
                  ),

                  const SizedBox(height: 16),

                  FilledButton.icon(
                    onPressed: _playoff == null
                        ? null
                        : () async {
                      final resolved =
                      await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) =>
                              RepechagePlayoffScreen(
                                playoff: _playoff!,
                              ),
                        ),
                      );

                      if (resolved == true) {
                        await _loadTournament();
                      }
                    },
                    icon: const Icon(Icons.sports_score),
                    label: const Text(
                      'Résoudre le barrage',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        for (final round in rounds) ...[
          Text(
            _roundLabel(round, rounds.length),
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          ...(_matches
              .where((match) => match.round == round)
              .toList()
            ..sort(
                  (a, b) => a.position.compareTo(b.position),
            ))
              .map(
                (match) => _MatchCard(
              match: match,
              teamA: _findTeam(match.teamAId),
              teamB: _findTeam(match.teamBId),
              teamALabel: _teamLabel(match.teamAId),
              teamBLabel: _teamLabel(match.teamBId),
              teamAPlayers: _playersLabel(match.teamAId),
              teamBPlayers: _playersLabel(match.teamBId),
              onTap: () async {
                final teamA = _findTeam(match.teamAId);
                final teamB = _findTeam(match.teamBId);

                if (teamA == null ||
                    teamB == null ||
                    match.isBye) {
                  return;
                }

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MatchLiveScreen(
                      match: match,
                      teamA: teamA,
                      teamB: teamB,
                      format: widget.tournament.format,
                    ),
                  ),
                );

                await _loadTournament();
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ],
    );
  }

  String _roundLabel(int round, int totalRounds) {
    if (round == totalRounds && totalRounds > 1) {
      return 'Finale';
    }

    if (round == totalRounds - 1 && totalRounds > 2) {
      return 'Demi-finales';
    }

    if (round == totalRounds - 2 && totalRounds > 3) {
      return 'Quarts de finale';
    }

    return 'Tour $round';
  }
}

class _MatchCard extends StatelessWidget {
  final Match match;

  final String teamALabel;
  final String teamBLabel;

  final String teamAPlayers;
  final String teamBPlayers;

  final Team? teamA;
  final Team? teamB;
  final VoidCallback? onTap;

  const _MatchCard({
    required this.match,
    required this.teamALabel,
    required this.teamBLabel,
    required this.teamAPlayers,
    required this.teamBPlayers,
    required this.teamA,
    required this.teamB,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (match.isBye) {
      final teamName =
      match.teamAId != null ? teamALabel : teamBLabel;

      final players =
      match.teamAId != null ? teamAPlayers : teamBPlayers;

      return Card(
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.fast_forward),
          ),
          title: Text(teamName),
          subtitle: Text(
            '$players\nExemptée — qualifiée automatiquement',
          ),
          isThreeLine: true,
          trailing: const Icon(Icons.check_circle),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TeamDisplay(
                      name: teamALabel,
                      players: teamAPlayers,
                    ),
                  ),

                  Text(
                    '${match.teamAScore}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),

              Row(
                children: [
                  Expanded(
                    child: _TeamDisplay(
                      name: teamBLabel,
                      players: teamBPlayers,
                    ),
                  ),

                  Text(
                    '${match.teamBScore}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'En ${match.targetScore} points',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamDisplay extends StatelessWidget {
  final String name;
  final String players;

  const _TeamDisplay({
    required this.name,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (players.isNotEmpty)
          Text(
            players,
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}