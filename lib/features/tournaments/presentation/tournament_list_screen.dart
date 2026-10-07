import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../domain/tournament.dart';
import '../data/tournament_repository.dart';
import 'tournament_create_screen.dart';
import 'tournament_players_screen.dart';
import '../data/match_repository.dart';
import 'tournament_bracket_screen.dart';


class TournamentListScreen extends StatefulWidget {
  const TournamentListScreen({super.key});

  @override
  State<TournamentListScreen> createState() =>
      _TournamentListScreenState();
}

class _TournamentListScreenState extends State<TournamentListScreen> {
  late final AppDatabase _database;
  late final TournamentRepository _repository;

  List<Tournament> _tournaments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _repository = TournamentRepository(_database);

    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    final tournaments = await _repository.getTournaments();

    if (!mounted) {
      return;
    }

    setState(() {
      _tournaments = tournaments;
      _loading = false;
    });
  }

  Future<void> _createTournament() async {
    final tournament = await Navigator.of(context).push<Tournament>(
      MaterialPageRoute(
        builder: (_) => const TournamentCreateScreen(),
      ),
    );

    if (tournament == null) {
      return;
    }

    await _repository.saveTournament(tournament);
    await _loadTournaments();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  String _formatLabel(PetanqueFormat format) {
    switch (format) {
      case PetanqueFormat.singles:
        return 'Tête-à-tête';
      case PetanqueFormat.doubles:
        return 'Doublette';
      case PetanqueFormat.triples:
        return 'Triplette';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournoi de Pétanque'),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _tournaments.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports,
              size: 72,
            ),
            SizedBox(height: 24),
            Text(
              'Aucun tournoi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Créez votre premier tournoi de pétanque.'),
          ],
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _tournaments.length,
        separatorBuilder: (_, _) =>
        const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final tournament = _tournaments[index];

          return Card(
            child: ListTile(
              title: Text(tournament.name),
              subtitle: Text(
                '${_formatLabel(tournament.format)}'
                    ' • ${tournament.rules.targetScore} points'
                    '${tournament.location.isEmpty ? '' : ' • ${tournament.location}'}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteTournament(tournament);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 8),
                        Text('Supprimer'),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () async {
                final database = AppDatabase();
                final matchRepository = MatchRepository(database);

                final matches = await matchRepository.getMatchesForTournament(
                  tournament.id,
                );

                await database.close();

                if (!context.mounted) {
                  return;
                }

                if (matches.isEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TournamentPlayersScreen(
                        tournament: tournament,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TournamentBracketScreen(
                        tournament: tournament,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createTournament,
        icon: const Icon(Icons.add),
        label: const Text('Nouveau tournoi'),
      ),
    );
  }

  Future<void> _deleteTournament(Tournament tournament) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le tournoi'),
          content: Text(
            'Supprimer définitivement "${tournament.name}" ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _repository.deleteTournament(tournament.id);
    await _loadTournaments();
  }
}