import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/tournament.dart';
import '../../../domain/tournament_rules.dart';

class TournamentCreateScreen extends StatefulWidget {
  const TournamentCreateScreen({super.key});

  @override
  State<TournamentCreateScreen> createState() =>
      _TournamentCreateScreenState();
}

class _TournamentCreateScreenState extends State<TournamentCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _targetScoreController = TextEditingController(text: '13');
  final _repechageSlotsController = TextEditingController(text: '3');

  DateTime _date = DateTime.now();
  PetanqueFormat _format = PetanqueFormat.doubles;
  TeamCreationMode _teamCreationMode = TeamCreationMode.random;
  bool _allowRepechage = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _targetScoreController.dispose();
    _repechageSlotsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _date = selectedDate;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final tournament = Tournament(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      date: _date,
      location: _locationController.text.trim(),
      format: _format,
      teamCreationMode: _teamCreationMode,
      rules: TournamentRules(
        targetScore: int.parse(_targetScoreController.text),
        allowFirstRoundRepechage: _allowRepechage,
        firstRoundRepechageSlots: _allowRepechage
            ? int.parse(_repechageSlotsController.text)
            : 0,
        repechageRule: RepechageRule.bestScore,
      ),
    );

    Navigator.of(context).pop(tournament);
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
        title: const Text('Nouveau tournoi'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du tournoi',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Saisissez un nom';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Lieu',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(
                '${_date.day.toString().padLeft(2, '0')}/'
                    '${_date.month.toString().padLeft(2, '0')}/'
                    '${_date.year}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: _selectDate,
            ),

            const Divider(),

            const Text(
              'Format',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            RadioGroup<PetanqueFormat>(
              groupValue: _format,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _format = value;
                });
              },
              child: Column(
                children: PetanqueFormat.values
                    .map(
                      (format) => RadioListTile<PetanqueFormat>(
                    title: Text(_formatLabel(format)),
                    value: format,
                  ),
                )
                    .toList(),
              ),
            ),

            const Divider(),

            const Text(
              'Composition des équipes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            RadioGroup<TeamCreationMode>(
              groupValue: _teamCreationMode,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _teamCreationMode = value;
                });
              },
              child: const Column(
                children: [
                  RadioListTile<TeamCreationMode>(
                    title: Text('Tirage aléatoire'),
                    value: TeamCreationMode.random,
                  ),
                  RadioListTile<TeamCreationMode>(
                    title: Text('Équipes prédéfinies'),
                    value: TeamCreationMode.predefined,
                  ),
                ],
              ),
            ),

            const Divider(),

            TextFormField(
              controller: _targetScoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Score pour gagner',
                suffixText: 'points',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final score = int.tryParse(value ?? '');

                if (score == null || score <= 0) {
                  return 'Saisissez un score valide';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Repêchage au premier tour'),
              subtitle: const Text(
                'Classe les perdants selon leur score.',
              ),
              value: _allowRepechage,
              onChanged: (value) {
                setState(() {
                  _allowRepechage = value;
                });
              },
            ),

            if (_allowRepechage) ...[
              const SizedBox(height: 8),

              TextFormField(
                controller: _repechageSlotsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nombre de perdants repêchés',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (!_allowRepechage) {
                    return null;
                  }

                  final slots = int.tryParse(value ?? '');

                  if (slots == null || slots <= 0) {
                    return 'Saisissez un nombre valide';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 8),

              const Text(
                'En cas d’égalité au niveau de la dernière place '
                    'qualificative, un barrage sera nécessaire.',
              ),
            ],

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Créer le tournoi'),
            ),
          ],
        ),
      ),
    );
  }
}