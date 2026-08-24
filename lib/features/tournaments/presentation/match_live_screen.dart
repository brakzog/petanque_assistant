import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/end.dart';
import '../../../domain/match.dart';
import '../../../domain/team.dart';
import '../data/end_repository.dart';
import '../data/match_repository.dart';
import '../../../domain/tournament.dart';

class MatchLiveScreen extends StatefulWidget {
  final Match match;
  final Team teamA;
  final Team teamB;
  final PetanqueFormat format;

  const MatchLiveScreen({
    super.key,
    required this.match,
    required this.teamA,
    required this.teamB,
    required this.format,
  });

  @override
  State<MatchLiveScreen> createState() => _MatchLiveScreenState();
}

class _MatchLiveScreenState extends State<MatchLiveScreen> {
  late final AppDatabase _database;
  late final MatchRepository _matchRepository;
  late final EndRepository _endRepository;

  late Match _match;
  List<End> _ends = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _matchRepository = MatchRepository(_database);
    _endRepository = EndRepository(_database);

    _match = widget.match;

    _loadData();
  }

  int get _maxPointsPerEnd {
    switch (widget.format) {
      case PetanqueFormat.singles:
        return 3;
      case PetanqueFormat.doubles:
      case PetanqueFormat.triples:
        return 6;
    }
  }

  Future<void> _loadData() async {
    final storedMatch = await _matchRepository.getMatch(_match.id);
    final ends = await _endRepository.getEndsForMatch(_match.id);

    if (!mounted) {
      return;
    }

    setState(() {
      if (storedMatch != null) {
        _match = storedMatch;
      }

      _ends = ends;
      _loading = false;
    });
  }

  Future<void> _addEnd({
    required String teamId,
    required int points,
  }) async {
    if (_match.isFinished) {
      return;
    }

    final isTeamA = teamId == _match.teamAId;

    final newTeamAScore =
        _match.teamAScore + (isTeamA ? points : 0);

    final newTeamBScore =
        _match.teamBScore + (isTeamA ? 0 : points);

    String? winnerTeamId;
    var status = MatchStatus.inProgress;

    if (newTeamAScore >= _match.targetScore) {
      winnerTeamId = _match.teamAId;
      status = MatchStatus.finished;
    } else if (newTeamBScore >= _match.targetScore) {
      winnerTeamId = _match.teamBId;
      status = MatchStatus.finished;
    }

    final end = End(
      id: const Uuid().v4(),
      matchId: _match.id,
      number: _ends.length + 1,
      scoringTeamId: teamId,
      points: points,
      createdAt: DateTime.now(),
    );

    final updatedMatch = _match.copyWith(
      teamAScore: newTeamAScore,
      teamBScore: newTeamBScore,
      status: status,
      winnerTeamId: winnerTeamId,
    );

    await _database.transaction(() async {
      await _endRepository.saveEnd(end);
      await _matchRepository.saveMatch(updatedMatch);
    });

    await _loadData();
  }

  Future<void> _undoLastEnd() async {
    if (_ends.isEmpty) {
      return;
    }

    final lastEnd = _ends.last;

    final isTeamA = lastEnd.scoringTeamId == _match.teamAId;

    final newTeamAScore = isTeamA
        ? _match.teamAScore - lastEnd.points
        : _match.teamAScore;

    final newTeamBScore = isTeamA
        ? _match.teamBScore
        : _match.teamBScore - lastEnd.points;

    final updatedMatch = _match.copyWith(
      teamAScore: newTeamAScore,
      teamBScore: newTeamBScore,
      status: _ends.length <= 1
          ? MatchStatus.pending
          : MatchStatus.inProgress,
      winnerTeamId: null,
    );

    await _database.transaction(() async {
      await _endRepository.deleteEnd(lastEnd.id);
      await _matchRepository.saveMatch(updatedMatch);
    });

    await _loadData();
  }

  String _playersLabel(Team team) {
    return team.players
        .map((player) => player.name)
        .join(' + ');
  }

  String _teamNameFromId(String teamId) {
    if (teamId == widget.teamA.id) {
      return widget.teamA.name;
    }

    return widget.teamB.name;
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
        title: const Text('Partie'),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TeamScoreCard(
            team: widget.teamA,
            players: _playersLabel(widget.teamA),
            score: _match.teamAScore,
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              'VS',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 8),

          _TeamScoreCard(
            team: widget.teamB,
            players: _playersLabel(widget.teamB),
            score: _match.teamBScore,
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              'Objectif : ${_match.targetScore} points',
            ),
          ),

          const SizedBox(height: 24),

          if (_match.isFinished)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Victoire',
                      style:
                      Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _teamNameFromId(
                        _match.winnerTeamId!,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            Text(
              'Mène ${_ends.length + 1}',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 16),

            _ScoreButtons(
              team: widget.teamA,
              onScore: (points) {
                _addEnd(
                  teamId: widget.teamA.id,
                  points: points,
                );
              },
              maxPoints: _maxPointsPerEnd,
            ),

            const SizedBox(height: 16),

            _ScoreButtons(
              team: widget.teamB,
              onScore: (points) {
                _addEnd(
                  teamId: widget.teamB.id,
                  points: points,
                );
              },
              maxPoints: _maxPointsPerEnd,
            ),
          ],

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          Text(
            'Historique des mènes',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 8),

          if (_ends.isEmpty)
            const Text(
              'Aucune mène enregistrée.',
            )
          else
            ..._ends.reversed.map(
                  (end) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Text('${end.number}'),
                ),
                title: Text(
                  _teamNameFromId(
                    end.scoringTeamId,
                  ),
                ),
                trailing: Text(
                  '+${end.points}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),
              ),
            ),

          if (_ends.isNotEmpty) ...[
            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: _undoLastEnd,
              icon: const Icon(Icons.undo),
              label: const Text(
                'Annuler la dernière mène',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TeamScoreCard extends StatelessWidget {
  final Team team;
  final String players;
  final int score;

  const _TeamScoreCard({
    required this.team,
    required this.players,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  Text(players),
                ],
              ),
            ),
            Text(
              '$score',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreButtons extends StatelessWidget {
  final Team team;
  final ValueChanged<int> onScore;
  final int maxPoints;

  const _ScoreButtons({
    required this.team,
    required this.onScore,
    required this.maxPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        Text(
          team.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var points = 1; points <= maxPoints; points++)
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 4),
                  child: FilledButton(
                    onPressed: () => onScore(points),
                    child: Text('+$points'),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}