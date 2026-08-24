import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/repechage_playoff.dart';
import '../../../domain/team.dart';
import '../data/repechage_playoff_repository.dart';
import '../data/team_repository.dart';

class RepechagePlayoffScreen extends StatefulWidget {
  final RepechagePlayoff playoff;

  const RepechagePlayoffScreen({
    super.key,
    required this.playoff,
  });

  @override
  State<RepechagePlayoffScreen> createState() =>
      _RepechagePlayoffScreenState();
}

class _RepechagePlayoffScreenState
    extends State<RepechagePlayoffScreen> {
  late final AppDatabase _database;
  late final TeamRepository _teamRepository;
  late final RepechagePlayoffRepository _playoffRepository;

  List<Team> _teams = [];

  final Set<String> _selectedTeamIds = {};

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _teamRepository = TeamRepository(_database);
    _playoffRepository =
        RepechagePlayoffRepository(_database);

    _loadData();
  }

  Future<void> _loadData() async {
    final allTeams =
    await _teamRepository.getTeamsForTournament(
      widget.playoff.tournamentId,
    );

    final playoffTeams = allTeams
        .where(
          (team) =>
          widget.playoff.teamIds.contains(team.id),
    )
        .toList();

    if (!mounted) {
      return;
    }

    setState(() {
      _teams = playoffTeams;
      _selectedTeamIds
        ..clear()
        ..addAll(widget.playoff.qualifiedTeamIds);
      _loading = false;
    });
  }

  void _toggleTeam(String teamId) {
    setState(() {
      if (_selectedTeamIds.contains(teamId)) {
        _selectedTeamIds.remove(teamId);
        return;
      }

      if (_selectedTeamIds.length >=
          widget.playoff.qualificationSlots) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Vous devez sélectionner exactement '
                  '${widget.playoff.qualificationSlots} équipe(s).',
            ),
          ),
        );

        return;
      }

      _selectedTeamIds.add(teamId);
    });
  }

  Future<void> _validatePlayoff() async {
    if (_selectedTeamIds.length !=
        widget.playoff.qualificationSlots) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sélectionnez exactement '
                '${widget.playoff.qualificationSlots} équipe(s).',
          ),
        ),
      );

      return;
    }

    setState(() {
      _saving = true;
    });

    await _playoffRepository.resolve(
      playoff: widget.playoff,
      qualifiedTeamIds: _selectedTeamIds.toList(),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  String _playersLabel(Team team) {
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
        title: const Text(
          'Barrage de repêchage',
        ),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Équipes à égalité',
            style:
            Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 8),

          Text(
            '${widget.playoff.teamIds.length} équipes '
                'pour ${widget.playoff.qualificationSlots} '
                'place(s) qualificative(s).',
          ),

          const SizedBox(height: 8),

          Text(
            'Sélectionnées : '
                '${_selectedTeamIds.length}/'
                '${widget.playoff.qualificationSlots}',
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),

          const SizedBox(height: 24),

          ..._teams.map(
                (team) {
              final selected =
              _selectedTeamIds.contains(team.id);

              return Card(
                child: CheckboxListTile(
                  value: selected,
                  onChanged: (_) {
                    _toggleTeam(team.id);
                  },
                  title: Text(team.name),
                  subtitle: Text(
                    _playersLabel(team),
                  ),
                  secondary: CircleAvatar(
                    child: Text(
                      team.name
                          .replaceAll('Équipe ', ''),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: _saving ||
                _selectedTeamIds.length !=
                    widget.playoff
                        .qualificationSlots
                ? null
                : _validatePlayoff,
            icon: _saving
                ? const SizedBox(
              width: 18,
              height: 18,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.check),
            label: const Text(
              'Valider le barrage',
            ),
          ),
        ],
      ),
    );
  }
}